"""Explicitly authorized, disposable Compose isolation exercise."""
import argparse
from concurrent.futures import ThreadPoolExecutor
import hashlib
import io
import json
import os
from pathlib import Path
import re
import subprocess
import tarfile
import tempfile
import time
from urllib.parse import urlsplit

SCOPE = "CODEX-HOWDY-001"
PORT = "8080"
HERE = Path(__file__).resolve().parent
APP = "howdy-acceptance/app.py"
PROBE = """
import socket, sys, urllib.request
mode, host, port = sys.argv[1:]
if mode == 'dns':
    try:
        socket.getaddrinfo(host, port)
    except socket.gaierror as e:
        if e.errno == socket.EAI_NONAME:
            print('DNS denied:', host)
            sys.exit(0)
        raise
    sys.exit('unexpected DNS resolution: ' + host)
if mode == 'tcp':
    try:
        socket.create_connection((host, int(port)), timeout=2).close()
    except (TimeoutError, ConnectionRefusedError) as e:
        print('TCP denied:', host, type(e).__name__)
        sys.exit(0)
    except OSError as e:
        import errno
        if e.errno in (errno.EHOSTUNREACH, errno.ENETUNREACH):
            print('TCP denied:', host, e.errno)
            sys.exit(0)
        raise
    sys.exit('unexpected TCP connectivity: ' + host)
with urllib.request.urlopen('http://' + host + ':' + port + '/', timeout=3) as response:
    print(response.read().decode())
"""


def require(condition, message):
    if not condition:
        raise RuntimeError(message)


def gate(args):
    require(args.authorize == SCOPE and args.approval.startswith("https://github.com/"),
            "explicit live authorization and Sheriff approval URL required")
    require(re.fullmatch(r"[a-z0-9]{8,16}", args.run_id), "use an approved 8–16 character run ID")
    endpoint = urlsplit(args.endpoint)
    require(endpoint.scheme == "ssh" and endpoint.hostname and endpoint.username and
            not (endpoint.password or endpoint.query or endpoint.fragment) and
            endpoint.hostname not in ("localhost", "127.0.0.1", "::1"),
            "an authenticated remote SSH endpoint is required")
    require(args.context and args.context != "default" and args.daemon_id and
            args.daemon_name.lower().split(".")[0] == "atlantis" and args.arch,
            "pin the Atlantis context, daemon ID, daemon name and architecture independently")
    require(re.fullmatch(r"docker\.io/library/python@sha256:[0-9a-f]{64}", args.base_image),
            "use an approved immutable Python base image digest")
    require(all(re.fullmatch(r"[0-9a-f]{40}", ref) for ref in (args.commit_a, args.commit_b))
            and args.commit_a != args.commit_b, "two different full source commits are required")


def run(argv, *, data=None, env=None, timeout=45):
    print("+", " ".join(map(str, argv)), flush=True)
    return subprocess.run(argv, input=data, stdout=subprocess.PIPE, env=env,
                          timeout=timeout, check=True).stdout


class Atlantis:
    def __init__(self, args):
        gate(args)
        self.args = args
        self.env = {k: v for k, v in os.environ.items()
                    if not k.startswith(("DOCKER_", "COMPOSE_", "BUILDX_"))}

    def call(self, *command, data=None, timeout=45):
        args = self.args
        context = json.loads(run(["docker", "context", "inspect", args.context], env=self.env))
        require(len(context) == 1 and
                context[0]["Endpoints"]["docker"]["Host"] == args.endpoint,
                "Docker context endpoint mismatch")
        prefix = ["docker", "--context", args.context]
        identity = json.loads(run(prefix + ["info", "--format", "{{json .}}"], env=self.env))
        actual = (identity["ID"], identity["Name"], identity["Architecture"], identity["OSType"])
        require(actual == (args.daemon_id, args.daemon_name, args.arch, "linux"),
                "remote Docker daemon identity mismatch")
        print("Atlantis", args.endpoint, actual, flush=True)
        env = self.env
        if command[0] == "build":
            # The daemon-native builder cannot dispatch via an ambient buildx builder.
            env = dict(env, DOCKER_BUILDKIT="0")
        return run(prefix + list(command), data=data, env=env, timeout=timeout)


def compose_config(alias, image):
    return {
        "services": {
            "app": {"image": image, "pull_policy": "never", "user": "10001:10001",
                    "cap_drop": ["ALL"], "security_opt": ["no-new-privileges:true"],
                    "read_only": True, "volumes": ["state:/state"],
                    "networks": {"private": {"aliases": [alias]}}},
            "probe": {"image": image, "pull_policy": "never", "user": "10001:10001",
                      "cap_drop": ["ALL"], "security_opt": ["no-new-privileges:true"],
                      "read_only": True, "command": ["python", "-c", "import time; time.sleep(1800)"],
                      "networks": ["private"]},
        },
        "networks": {"private": {"internal": True}},
        "volumes": {"state": {}},
    }


class Stack:
    def __init__(self, docker, root, worker, commit):
        self.docker = docker
        self.name = "howdy-" + docker.args.run_id + "-" + worker
        self.commit = commit
        self.token = self.name + ":" + commit
        self.image = self.name + ":fixture"
        self.db_identity = None
        self.config = root / (self.name + ".json")
        self.config.write_text(json.dumps(compose_config(self.name, self.image)))
        self.prefix = ("compose", "--project-directory", str(root), "-f", str(self.config),
                       "--project-name", self.name)

    def compose(self, *args):
        return self.docker.call(*self.prefix, *args)

    def resources(self):
        label = "label=com.docker.compose.project=" + self.name
        return [self.docker.call(kind, "ls", *flags, "--filter", label, "-q").decode().split()
                for kind, flags in (("container", ["-a", "--no-trunc"]), ("network", []), ("volume", []))]

    def source(self):
        env = {k: v for k, v in os.environ.items() if not k.startswith("GIT_")}
        resolved = run(["git", "-C", str(HERE), "rev-parse", self.commit + "^{commit}"], env=env)
        require(resolved.decode().strip() == self.commit, "source revision is not a commit")
        return run(["git", "-C", str(HERE), "show", self.commit + ":" + APP], env=env)

    def build(self, source):
        base = self.docker.args.base_image
        dockerfile = f"""FROM {base}
RUN mkdir /state && chown 10001:10001 /state && touch /state/.fixture
WORKDIR /fixture
COPY app.py token ./
USER 10001:10001
CMD ["python", "-B", "/fixture/app.py"]
"""
        archive = io.BytesIO()
        with tarfile.open(fileobj=archive, mode="w") as tar:
            for name, body in (("Dockerfile", dockerfile.encode()), ("app.py", source),
                               ("token", self.token.encode())):
                entry = tarfile.TarInfo(name)
                entry.size = len(body)
                tar.addfile(entry, io.BytesIO(body))
        data = archive.getvalue()
        print("build input", self.commit, base, hashlib.sha256(data).hexdigest())
        self.docker.call("build", "--network=none", "--tag", self.image,
                         "--label", "org.opencontainers.image.revision=" + self.commit,
                         "-", data=data, timeout=300)
        image, = json.loads(self.docker.call("image", "inspect", self.image))
        require(image["Config"]["Labels"]["org.opencontainers.image.revision"] == self.commit,
                "image revision mismatch")
        self.image_id = image["Id"]
        print("built image", self.image_id, flush=True)

    def inspect(self):
        containers, networks, volumes = self.resources()
        require(len(containers) == 2 and len(networks) == len(volumes) == 1,
                "unexpected stack inventory")
        network, = json.loads(self.docker.call("network", "inspect", networks[0]))
        volume, = json.loads(self.docker.call("volume", "inspect", volumes[0]))
        require(network["Internal"] and network["Driver"] == "bridge" and
                set(network["Containers"]) == set(containers) and volume["Driver"] == "local" and
                not volume.get("Options"), "unexpected network membership or volume")
        app_ip = None
        for container in json.loads(self.docker.call("container", "inspect", *containers)):
            labels = container["Config"]["Labels"]
            service = labels["com.docker.compose.service"]
            attachments = container["NetworkSettings"]["Networks"]
            mounts = container["Mounts"]
            require(labels["com.docker.compose.project"] == self.name and
                    container["Image"] == self.image_id and set(attachments) == {network["Name"]}
                    and not any((container["NetworkSettings"]["Ports"] or {}).values())
                    and not container["HostConfig"]["Privileged"] and
                    container["Config"]["User"] == "10001:10001", "unexpected runtime attachment")
            if service == "app":
                require(len(mounts) == 1 and mounts[0]["Type"] == "volume" and mounts[0]["RW"]
                        and mounts[0]["Name"] == volume["Name"] and mounts[0]["Destination"] == "/state",
                        "app volume mismatch")
                app_ip = attachments[network["Name"]]["IPAddress"]
            else:
                require(service == "probe" and not mounts, "unexpected probe mounts")
        require(app_ip, "app IPv4 address required")
        print("stack inventory", self.name, containers, network["Id"], volume["Name"], app_ip)
        return set(containers), network["Id"], volume["Name"], app_ip

    def probe(self, mode, host):
        return self.compose("exec", "-T", "probe", "python", "-c", PROBE,
                            mode, host, PORT).decode().strip()

    def healthy(self, attempts=1):
        for attempt in range(attempts):
            try:
                marker = self.probe("http", self.name)
            except subprocess.CalledProcessError:
                if attempt + 1 == attempts:
                    raise
                time.sleep(1)
                continue
            token, _, identity = marker.partition(" ")
            require(token == self.token and re.fullmatch(r"[0-9a-f]{32}", identity),
                    "own stack returned the wrong DB marker")
            require(self.db_identity in (None, identity), "database identity changed")
            self.db_identity = identity
            print("own DB marker", marker, flush=True)
            return

    def cleanup(self):
        self.inspect()
        self.compose("down", "--volumes")
        require(not any(self.resources()), "selected project resources remain")
        image, = json.loads(self.docker.call("image", "inspect", self.image))
        require(image["Id"] == self.image_id, "image tag changed; refusing removal")
        self.docker.call("image", "rm", self.image)


def exercise(docker, root):
    args = docker.args
    a = Stack(docker, root, "a", args.commit_a)
    b = Stack(docker, root, "b", args.commit_b)
    sources = [stack.source() for stack in (a, b)]
    require(sources[0] != sources[1], "worker commits must contain different fixture endpoint source")
    for stack in (a, b):
        require(not any(stack.resources()) and
                not docker.call("image", "ls", "-q", "--filter", "reference=" + stack.image).strip(),
                "run ID collision; no resources adopted")
        for kind, name in (("network", stack.name + "_private"), ("volume", stack.name + "_state")):
            names = docker.call(kind, "ls", "--format", "{{.Name}}", "--filter", "name=" + name)
            require(name not in names.decode().splitlines(), "unowned resource name collision")
        print(stack.compose("config").decode())
    for stack, source in zip((a, b), sources):
        stack.build(source)
        stack.compose("up", "-d", "--no-build", "--pull", "never")
    with ThreadPoolExecutor(2) as workers:
        list(workers.map(lambda stack: stack.healthy(attempts=5), (a, b)))
    require(a.db_identity != b.db_identity, "shared database identity")
    a_state, b_state = a.inspect(), b.inspect()
    require(not a_state[0] & b_state[0] and all(x != y for x, y in zip(a_state[1:], b_state[1:])),
            "stacks share a network, volume, or endpoint")
    for own, other, state in ((a, b, b_state), (b, a, a_state)):
        print(own.probe("dns", other.name))
        print(own.probe("tcp", state[3]))
        own.healthy()
    a.compose("stop", "app")
    b.healthy()
    a.compose("start", "app")
    a.healthy(attempts=5)
    b.healthy()
    require(a.inspect() == a_state, "worker A resources changed during restart")
    require(b.inspect() == b_state, "worker B resources changed during A restart")
    a.cleanup()
    b.healthy()
    require(b.inspect() == b_state, "worker B resources changed during A cleanup")
    b.cleanup()
    print("PASS Atlantis fixture isolation and scoped cleanup")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    for arg in ("authorize", "approval", "run-id", "context", "endpoint", "daemon-id",
                "daemon-name", "arch", "base-image", "commit-a", "commit-b"):
        parser.add_argument("--" + arg, required=True)
    args = parser.parse_args()
    try:
        docker = Atlantis(args)
        with tempfile.TemporaryDirectory(prefix="howdy-compose-") as root:
            exercise(docker, Path(root))
    except (RuntimeError, subprocess.SubprocessError, OSError, ValueError, KeyError) as error:
        parser.exit(1, f"FAILED: {error}. Inspect approved project labels before any recovery.\n")


if __name__ == "__main__":
    main()
