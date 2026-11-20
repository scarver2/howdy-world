# _infrastructure/howdy-acceptance/test_offline.py
"""Fail-closed Docker checks with a mock that cannot call any daemon."""
from argparse import Namespace
from copy import copy
import json
import unittest
from unittest.mock import patch

from atlantis import Atlantis, compose_config


class Offline(unittest.TestCase):
    def setUp(self):
        self.args = Namespace(
            authorize="CODEX-HOWDY-001", approval="https://github.com/example/repo/issues/1",
            run_id="fixture01", context="approved", endpoint="ssh://worker@atlantis",
            daemon_id="pinned", daemon_name="atlantis", arch="x86_64",
            base_image="docker.io/library/python@sha256:" + "1" * 64,
            commit_a="a" * 40, commit_b="b" * 40,
        )

    @patch("atlantis.run")
    def test_gate_refuses_before_docker(self, run):
        for field, value in (
            ("authorize", ""), ("endpoint", "unix:///var/run/docker.sock"),
            ("endpoint", "ssh://worker@localhost"), ("context", "default"),
            ("daemon_name", "sgc"), ("daemon_id", ""), ("run_id", "../other"),
            ("base_image", "python:latest"), ("commit_b", "a" * 40),
        ):
            with self.subTest(field=field):
                args = copy(self.args)
                setattr(args, field, value)
                with self.assertRaises(RuntimeError):
                    Atlantis(args)
        run.assert_not_called()

    @patch("atlantis.run")
    def test_context_mismatch_stops_before_daemon(self, run):
        run.return_value = json.dumps([{"Endpoints": {"docker": {"Host": "unix:///tmp/local"}}}])
        with self.assertRaisesRegex(RuntimeError, "context endpoint mismatch"):
            Atlantis(self.args).call("compose", "up")
        self.assertEqual(run.call_count, 1)

    @patch("atlantis.run")
    def test_wrong_daemon_stops_before_compose(self, run):
        run.side_effect = [
            json.dumps([{"Endpoints": {"docker": {"Host": self.args.endpoint}}}]),
            json.dumps(dict(ID="wrong", Name="atlantis", Architecture="x86_64", OSType="linux")),
        ]
        with self.assertRaisesRegex(RuntimeError, "daemon identity mismatch"):
            Atlantis(self.args).call("compose", "up")
        self.assertEqual(run.call_count, 2)

    @patch("atlantis.run")
    def test_verified_command_is_explicitly_targeted(self, run):
        run.side_effect = [
            json.dumps([{"Endpoints": {"docker": {"Host": self.args.endpoint}}}]),
            json.dumps(dict(ID="pinned", Name="atlantis", Architecture="x86_64", OSType="linux")),
            b"fixture",
        ]
        with patch.dict("os.environ", {"DOCKER_HOST": "unix:///tmp/local", "COMPOSE_FILE": "/tmp/wrong"}):
            self.assertEqual(Atlantis(self.args).call("compose", "config"), b"fixture")
        argv = run.call_args.args[0]
        self.assertEqual(argv, ["docker", "--context", "approved", "compose", "config"])
        self.assertNotIn("DOCKER_HOST", run.call_args.kwargs["env"])
        self.assertNotIn("COMPOSE_FILE", run.call_args.kwargs["env"])

    def test_no_shared_or_host_resources_in_generated_config(self):
        config = compose_config("fixture", "fixture:tag")
        self.assertEqual(config["networks"], {"private": {"internal": True}})
        self.assertEqual(config["volumes"], {"state": {}})
        for service in config["services"].values():
            for key in ("ports", "network_mode", "container_name", "privileged", "build"):
                self.assertNotIn(key, service)
        self.assertEqual(config["services"]["app"]["volumes"], ["state:/state"])
        self.assertNotIn("volumes", config["services"]["probe"])


if __name__ == "__main__":
    unittest.main()
