# detailed-weather-forecast — Repo Overview

> Snapshot: 2026-08-06. Part of the Home Assistant **file/code lane** workspace.
> The root [`../CLAUDE.md`](../CLAUDE.md) is the authority on workspace-wide rules
> (incl. the **push/deploy autonomy policy**); this file is a quick factual overview
> of *this repo*. **Keep it current** — see *Keeping this file current* at the bottom.

## Purpose
A Lovelace **custom card** for Home Assistant: a detailed weather forecast card
combining a large animated weather header with interactive daily and hourly
forecasts (precipitation, sun/dawn markers, solar forecast, nowcast, configurable
chips, UI editor). Card type: `custom:detailed-weather-forecast-card`.

This is a fork/further-development lineage of upstream `tobiasb80/detailed-weather-forecast`
(the deployed dashboard card is a **heavily modified** fork — see
[`../HAKitchenDashboard/README.md`](../HAKitchenDashboard/README.md)).

## Tech stack
- **TypeScript + Lit** web component.
- Bundler: **Rollup** (`rollup.config.js`, plus `rollup.config.dev.js` for watch).
- Package manager: **Yarn 4** (`yarn@4.12.0`) via **Corepack**.
- Lint/format: ESLint + Prettier. HACS-published (`hacs.json`). GitHub Actions CI
  (build / validate / release). Devcontainer present. Version `0.9.1`.

## Build
```powershell
yarn build      # = clean -> lint -> rollup  ->  dist/detailed-weather-forecast.js
yarn start      # rollup dev watch
```
Output bundle: `dist/detailed-weather-forecast.js`.

## Deploy (dev channel)
```powershell
./deploy.cmd            # wrapper -> deploy.ps1 -> scripts\deploy-ha-dev.ps1
```
- Mechanism: builds, then `scp` the single bundle to the HA box.
- **Target:** `root@homeassistant.local:/homeassistant/www/custom-cards/detailed-weather-forecast-dev/detailed-weather-forecast.js`
  (served at `/local/custom-cards/detailed-weather-forecast-dev/detailed-weather-forecast.js`).
- Useful switches: `-DryRun`, `-SkipBuild`, `-FullBuild`, `-NoBump`.
- **The deploy auto-bumps the Lovelace resource** `?v=devN` for you via
  `scripts/bump-ha-resource.mjs` (no manual edit needed; pass `-NoBump` to skip).
- **Claude runs the whole deploy end-to-end.** Passwordless SSH key `~/.ssh/ha_deploy`
  reaches `root@homeassistant.local`, and the bumper talks to HA over **plain `ws://`**
  (TLS retired 2026-08-06) — so no manual credential/SSH/SSL step is required. (Machine-specific
  setup is in the `card-deploy-setup` memory, not in this repo.)

## Push (GitHub)
`origin` → `github.com/cgjolberg/detailed-weather-forecast`, branch `main`; push/deploy is
autonomous per the root policy (root [`../CLAUDE.md`](../CLAUDE.md) → *Deployment*).

## Git
- `origin` → `github.com/cgjolberg/detailed-weather-forecast.git`. No `upstream`
  remote is configured locally (despite the upstream lineage).
- **Forgejo:** this workspace repo pushes to **GitHub only** — that's by design.
  Forgejo backs up the **HA server's own config** (a separate lane, reachable via the
  home-assistant MCP), not these card repos. See [`../WORKSPACE-OVERVIEW.md`](../WORKSPACE-OVERVIEW.md).
- Branch `main`. As of snapshot: clean working tree.

## Repo-specific notes
- **Line endings — enforced.** The committed [`.gitattributes`](.gitattributes) pins `eol=lf`
  (overriding the local `core.autocrlf` setting) and was the template the other repos copied —
  all five now have their LF pins in place (per-repo status:
  [`../WORKSPACE-OVERVIEW.md`](../WORKSPACE-OVERVIEW.md)). No `.editorconfig`.
- [`CLAUDE.md`](CLAUDE.md) carries the workspace context + standing doc rule and points
  at [`.github/copilot-instructions.md`](.github/copilot-instructions.md) for code rules.

## Keeping this file current
Treat docs as part of every change here — update them in the **same commit**, not as a
"if I remember" follow-up. Before committing, check these still read true and fix the ones
that don't (derive dates/status from `git`, never invent them):
- This `OVERVIEW.md` — purpose, build, **deploy/push mechanism + target**, switches, and
  the `> Snapshot:` line (bump to today when you touch the repo).
- **When the deploy/push story changes** (e.g. the SSH key, the auto-bump, credential auth,
  resource ID, or the target path), update the Deploy/Push sections here **and** the
  `card-deploy-setup` memory **and** [`../WORKSPACE-OVERVIEW.md`](../WORKSPACE-OVERVIEW.md).
- If a *workspace-wide* fact changes, flag [`../CLAUDE.md`](../CLAUDE.md) (shared root).
