# _infrastructure/howdy-acceptance/worktrees.py
"""Two concurrent subprocess workers against a disposable Git repository."""
import os
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path
import subprocess
from tempfile import TemporaryDirectory
from threading import Barrier


def git(path, *args, check=True):
    env = {k: v for k, v in os.environ.items() if not k.startswith("GIT_")}
    env.update(GIT_CONFIG_NOSYSTEM="1", GIT_CONFIG_GLOBAL=os.devnull)
    return subprocess.run(
        ["git", "-C", path, "-c", "core.hooksPath=" + os.devnull, *args],
        env=env, check=check, capture_output=True, text=True, timeout=20,
    )


def require(condition, label):
    if not condition:
        raise RuntimeError(label)
    print("PASS", label, flush=True)


def main():
    with TemporaryDirectory(prefix="howdy-git-") as root:
        repo = Path(root) / "repo"
        repo.mkdir()
        git(repo, "init", "-b", "fixture")
        for name in ("a", "b"):
            (repo / name).write_text("base\n")
        git(repo, "add", "a", "b")
        git(repo, "-c", "user.name=Fixture", "-c", "user.email=fixture@example.invalid",
            "commit", "-m", "Synthetic worktree baseline")
        paths = {name: Path(root) / name for name in ("a", "b")}
        for name, path in paths.items():
            git(repo, "worktree", "add", "-b", name, str(path))
        indexes = {git(path, "rev-parse", "--path-format=absolute", "--git-path", "index").stdout.strip()
                   for path in paths.values()}
        require(len(indexes) == 2, "distinct Git indexes")
        staged = Barrier(2, timeout=20)

        def worker(name, peer):
            path = paths[name]
            (path / name).write_text(f"{name} staged\n")
            git(path, "add", name)
            (path / name).write_text(f"{name} unstaged\n")
            (path / "untracked").write_text(name)
            staged.wait()
            verify(name, peer)

        def verify(name, peer):
            path = paths[name]
            require(git(path, "diff", "--cached", "--name-only").stdout.strip() == name,
                    f"{name}: isolated index")
            require(git(path, "show", f":{name}").stdout == f"{name} staged\n",
                    f"{name}: staged content")
            require((path / peer).read_text() == "base\n" and
                    (path / name).read_text() == f"{name} unstaged\n" and
                    (path / "untracked").read_text() == name,
                    f"{name}: isolated files and retained uncommitted work")

        with ThreadPoolExecutor(2) as pool:
            workers = [pool.submit(worker, "a", "b"), pool.submit(worker, "b", "a")]
            for job in workers:
                job.result()
        require(git(repo, "worktree", "remove", str(paths["a"]), check=False).returncode != 0,
                "Git refuses dirty worktree removal")
        verify("a", "b")
        verify("b", "a")
        require(not git(repo, "status", "--porcelain").stdout, "base worktree remains clean")


if __name__ == "__main__":
    main()
