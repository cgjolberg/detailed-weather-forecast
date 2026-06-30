# detailed-weather-forecast — guide for Claude Code

Part of the Home Assistant **file/code lane** workspace. Read order:
- [`OVERVIEW.md`](OVERVIEW.md) — what this repo is, build, **deploy/push facts + target**.
- [`.github/copilot-instructions.md`](.github/copilot-instructions.md) — the code rules
  (TS + Lit + Rollup conventions, safe-change workflow). `AGENTS.md` points here too.
- [`../CLAUDE.md`](../CLAUDE.md) — workspace-wide authority, incl. the full push/deploy policy.

## Deploy & push (Claude does this end-to-end)
`.\deploy.cmd` builds, `scp`s the bundle to the HA box, and **auto-bumps** the Lovelace
resource. Passwordless SSH (`~/.ssh/ha_deploy`) + self-signed-cert trust
(`NODE_EXTRA_CA_CERTS`) make it non-interactive; `git push` to GitHub is non-interactive
via Git Credential Manager. Per the root **autonomy policy**: commit with a reviewed diff,
then push to GitHub and deploy to HA to complete the task — no separate approval; review via
git history. No history rewriting without an explicit instruction. See [`OVERVIEW.md`](OVERVIEW.md).

**Run it prompt-free (allowlisted in [`../.claude/settings.json`](../.claude/settings.json), 2026-06-28):**
invoke as **standalone, forward-slash, `cd`-free** commands — in-repo `git push origin main` then
`./deploy.cmd`, or from the workspace root `git -C ./detailed-weather-forecast push origin main`
then `./detailed-weather-forecast/deploy.cmd`. A `cd`-prefixed, back-slashed (`.\deploy.cmd`), or
piped/chained form won't match the allowlist and will prompt. Force-push and `upstream` pushes are
deliberately left to prompt.

> **Allowlist scoping:** scoped into this repo (the `cd`-into-it workflow), the live permissions are
> **this repo's own** [`.claude/settings.json`](.claude/settings.json) + your user settings — **not**
> the parent's. So the deploy/push entries above live here too, alongside the workspace's shared
> **read-only MCP allowlist** (HA `ha_*` reads + Chrome reads) — kept **in sync across all repos + the
> root** and **never** moved to user/global `~/.claude/settings.json` (auto-approval is scoped to this
> tree on purpose). Full logic: root [`../CLAUDE.md`](../CLAUDE.md) → *Permission allowlists*. **Shell: use the PowerShell tool only — the Bash tool is disabled here (`deny: ["Bash"]`); run every command via PowerShell.**

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
