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

## Standing rule: keep docs current without being asked
On any change that affects build, deploy, push/credentials, or behavior, update
[`OVERVIEW.md`](OVERVIEW.md) (and bump its `> Snapshot:` date) in the **same commit** — and
if the deploy/push story changed, also the `card-deploy-setup` memory and
[`../WORKSPACE-OVERVIEW.md`](../WORKSPACE-OVERVIEW.md). Derive dates/status from `git`; don't
invent them. Fixing a doc the code has outgrown is in scope even when only code was asked for.
