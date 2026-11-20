# CODEX-HOWDY-001

[Issue #31](https://github.com/a1web/engineering-standards/issues/31) tracks acceptance.
The inspected repository is [scarver2/howdy-world](https://github.com/scarver2/howdy-world),
default branch `master`, with GitHub master and the isolated PR base at
`9a0a472172b509e9cb8e55e9b07a1853d3481571`. The older host checkout was
`e488ec3b03f59717c5c68fd697e6d73caea03c96`. Its README starts the
application with `bin/up`. The root `compose.yml` includes per-service
Compose files, some with development overlays. Existing entry points
include `bin/ci` (the repository's PR workflow), `bin/status --http`,
`bin/test`, `bin/health`, and per-language suites such as
`python-fastapi/tests/test_howdy.py`. The fixture uses a small HTTP endpoint
and SQLite so these isolation checks can run independently of the full stack.

## Offline on SGC or CI

From the repository root, using Git 2.31+ and Python 3.9+:

```sh
python3 -B _infrastructure/howdy-acceptance/worktrees.py
python3 -B -m unittest discover -s _infrastructure/howdy-acceptance -p test_offline.py -v
```

The first command creates a temporary repository, overlaps two worker
operations behind a barrier, then checks staged, unstaged and untracked
content through fresh Git processes. It requires dirty-worktree removal to
fail without force. The temporary repository contains synthetic files only.
The second command mocks all Docker calls. This phase proves local fixture
behavior and fail-closed checks only.

## Live authorization and setup

After Bunkhouse readiness, obtain a Sheriff GitHub comment expressly
authorizing **one supervised CODEX-HOWDY-001 exercise** for the exact
Atlantis SSH endpoint, trusted SSH host key, Docker context, independently
confirmed daemon ID/name/Linux architecture, two worker identities and
source SHAs, approved Python image digest (and registry fetch if absent), run
ID and time window. The scope must include creation/build, private TCP and DNS
probes, A stop/start, and removal of only the two named disposable projects,
their two state volumes, project networks and named image tags. Obtain
separate permission for recovery cleanup if the run aborts. The CLI approval
URL records the authorization reference. An operator must confirm its contents.

Use the existing qualified toolkit to create two independent Howdy World
worktrees. Capture each supervised worker's identity, session/PID, worktree,
branch, index path, base/head, clean baseline and overlapping timestamps.
Have each make a different deterministic fixture endpoint change and run
its relevant tests in its own worktree. Preserve the stage/unstage markers
and verify both after restarting a worker process. Use two reviewed full
commits for the image inputs. Ensure both commits are present in the
checkout that runs the harness. Record Docker/Compose versions and actual
worker permissions separately. Prevent context edits and concurrent reuse of
the run ID for the approved window. Use an existing authenticated SSH
context and strict host-key verification.

```sh
set -o pipefail
python3 -B _infrastructure/howdy-acceptance/atlantis.py \
  --authorize CODEX-HOWDY-001 --approval "$APPROVAL_URL" \
  --run-id "$RUN_ID" --context "$ATLANTIS_CONTEXT" --endpoint "$ATLANTIS_SSH_URI" \
  --daemon-id "$ATLANTIS_DAEMON_ID" --daemon-name "$ATLANTIS_DAEMON_NAME" \
  --arch "$ATLANTIS_ARCH" --base-image "$PYTHON_IMAGE_DIGEST" \
  --commit-a "$WORKER_A_SHA" --commit-b "$WORKER_B_SHA" 2>&1 | tee "$RECEIPT_PATH"
```

Every Docker invocation uses the named context after checking its configured
SSH URI, rejecting loopback and other local-only addresses (including DNS
answers), then confirming the remote daemon identity. The harness strips ambient Docker
and Compose overrides. The operator supplies identity pins from the
independent Atlantis inventory. This checks the target during the run.
It does not pin against concurrent edits to the trusted local context or
SSH configuration or DNS. Confirm any SSH HostName overrides and routing
as part of the trusted context preflight.

The source is read with `git show` from each reviewed commit. A tar stream
containing only the fixture, marker, and generated Dockerfile goes to the
daemon-native builder (`DOCKER_BUILDKIT=0`) on Atlantis. Confirm the
existing daemon supports that builder before approving the run. The receipt records the commit, base digest, context archive
SHA-256 and image ID. No SGC path is mounted on Atlantis. A remote build can
leave build cache. No prune is part of this exercise.

Projects `howdy-<run-id>-a` and `howdy-<run-id>-b` have separate internal
bridges and SQLite state volumes, with zero published host ports. The
harness checks runtime attachments and volume ownership, concurrent own
HTTP/DB reads, cross-project DNS and direct-IP TCP negatives in both
directions, the peer's health while A is stopped, persistence after A
starts, and B's health and resource identity after removing A. The fixture
runs as an unprivileged container user. Shared unrestricted daemon access
is root-equivalent and Compose isolation does not protect against a user
with that access. The test covers ordinary container network traffic.
Capture any approved host resource baseline/peak evidence alongside the log.

PASS requires all checks and both scoped cleanups to complete. A failure
stops the run and may leave disposable resources for inspection. Record
the run ID and actual labels, inspect all matching resources at the pinned
endpoint and obtain recovery authorization before using exact-project
Compose cleanup. Avoid global prune, orphan removal, forced removal and
worktree deletion. Preserve source branches, dirty evidence and logs.
A successful offline run alone does not qualify Atlantis or Bunkhouse.
