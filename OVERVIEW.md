# detailed-weather-forecast — Repo Overview

> Snapshot: 2026-06-19. Part of the Home Assistant **file/code lane** workspace.
> The root [`../CLAUDE.md`](../CLAUDE.md) is the authority on workspace-wide rules;
> this file is a quick factual overview of *this repo*. Refresh it when the build,
> deploy target, or remotes change.

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
.\deploy.cmd            # wrapper -> deploy.ps1 -> scripts\deploy-ha-dev.ps1
```
- Mechanism: builds, then `scp` the single bundle to the HA box.
- **Target:** `root@homeassistant.local:/homeassistant/www/custom-cards/detailed-weather-forecast-dev/detailed-weather-forecast.js`
  (served at `/local/custom-cards/detailed-weather-forecast-dev/detailed-weather-forecast.js`).
- Useful switches: `-DryRun`, `-SkipBuild`, `-FullBuild`.
- After deploy, **bump the Lovelace resource query string** (e.g. `?v=dev5`).
- *You edit + run deploy; the script reaches the HA box over SSH. Claude Code does not.*

## Git
- `origin` → `github.com/cgjolberg/detailed-weather-forecast.git`. No `upstream`
  remote is configured locally (despite the upstream lineage).
- **Forgejo:** this workspace repo pushes to **GitHub only** — that's by design.
  Forgejo backs up the **HA server's own config** (a separate lane, reachable via the
  home-assistant MCP), not these card repos. See [`../WORKSPACE-OVERVIEW.md`](../WORKSPACE-OVERVIEW.md).
- Branch `main`. As of snapshot: clean working tree.

## Repo-specific notes
- **Line endings: this is the one repo that enforces LF correctly** — its
  [`.gitattributes`](.gitattributes) pins `eol=lf`, which overrides the repo's
  `core.autocrlf=true`. Use it as the template for the other repos. No `.editorconfig`.
- `CLAUDE.md` here just points agents at `.github/copilot-instructions.md`.
