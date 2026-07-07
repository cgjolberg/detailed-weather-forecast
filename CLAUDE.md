# detailed-weather-forecast — guide for Claude Code

Part of the Home Assistant **file/code lane** workspace. Read order:
- [`OVERVIEW.md`](OVERVIEW.md) — what this repo is, build, **deploy/push facts + target**.
- [`.github/copilot-instructions.md`](.github/copilot-instructions.md) — the code rules
  (TS + Lit + Rollup conventions, safe-change workflow). `AGENTS.md` points here too.
- [`../CLAUDE.md`](../CLAUDE.md) — workspace-wide authority, incl. the full push/deploy policy.

## Deploy & push (Claude does this end-to-end)
`./deploy.cmd` builds, `scp`s the bundle to the HA box, and **auto-bumps** the Lovelace
resource. Passwordless SSH (`~/.ssh/ha_deploy`) + self-signed-cert trust
(`NODE_EXTRA_CA_CERTS`) make it non-interactive; `git push` to GitHub is non-interactive
via Git Credential Manager. Per the root **autonomy policy**: commit with a reviewed diff,
then push to GitHub and deploy to HA to complete the task — no separate approval; review via
git history. No history rewriting without an explicit instruction. See [`OVERVIEW.md`](OVERVIEW.md).

Deploy/push runs prompt-free via the workspace permission layer — a PreToolUse hook (Layer 0)
plus this repo's own [`.claude/settings.json`](.claude/settings.json) as declarative fallback
when the session is scoped here. Exact pushes only (`git push origin main`); force-push and
`upstream` pushes always prompt by design. Form contract, current status, and maintenance rules:
root [`../CLAUDE.md`](../CLAUDE.md) (*Shell commands & permission prompts*) and
[`../.claude/PERMISSIONS.md`](../.claude/PERMISSIONS.md). Prefer the PowerShell tool and the
committed wrappers (`./deploy.cmd`, `../commit-push.cmd`) over ad-hoc commands.

## Working plan: read PLAN.md first, keep it updated
[`PLAN.md`](PLAN.md) is the persistent record of what we're doing in this repo — current
focus, next steps, open questions, decisions, and a dated log. **Read it at the start of any
work here** (the workspace `SessionStart` hook also auto-prints its *Current focus* + *Next
steps*). **Update it as part of every change, in the same commit** as the work: keep *Current
focus* honest, move finished items out of *Next steps*, and append to the *Log*. This is how
we avoid losing track when we bounce between projects.

## Standing rule: keep docs current without being asked
On any change that affects build, deploy, push/credentials, or behavior, update
[`OVERVIEW.md`](OVERVIEW.md) (and bump its `> Snapshot:` date) in the **same commit** — and
if the deploy/push story changed, also the `card-deploy-setup` memory and
[`../WORKSPACE-OVERVIEW.md`](../WORKSPACE-OVERVIEW.md). Derive dates/status from `git`; don't
invent them. Fixing a doc the code has outgrown is in scope even when only code was asked for.
