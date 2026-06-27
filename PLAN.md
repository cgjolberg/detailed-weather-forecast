# detailed-weather-forecast — working plan

> **Claude Code's persistent memory of what we're doing in THIS repo.** It survives
> across sessions and across switching to other projects. It is auto-surfaced at the
> start of every session by the workspace `SessionStart` hook (see
> [`../.claude/print-plans.ps1`](../.claude/print-plans.ps1)), and it is **kept current
> as part of every change** — updated in the *same commit* as the work, exactly like
> [`OVERVIEW.md`](OVERVIEW.md). Derive dates from `git`/the clock; never invent them.
>
> Keep it compact. The `## Current focus` + `## Next steps` sections are what the hook
> prints, so they are the at-a-glance "where were we" — prune stale lines aggressively.

## Current focus
_Idle._ `exceptional` days now render a temperature-split **native layered SVG**
(sun/snowflake + thermometer) matching the built-in icon art (deployed 2026-06-26).
No active task.

## Next steps
- [ ] (none yet)

## Open questions / blockers
- (none)

- **`exceptional` is temperature-split into native layered SVG icons.** NWS
  collapses Hot, Cold, Tornado, Hurricane, Tropical storm, Dust, Smoke and Haze all
  into the single `exceptional` condition, and the card only receives
  `condition: exceptional` (the source word is lost) — so the only signal to tell
  hot from cold is the day's temperature. `resolveExceptionalKind` in
  [`src/weather.ts`](src/weather.ts) returns hot (≥86°F/30°C) / cold (≤32°F/0°C) /
  neutral; `getExceptionalIcon` renders **bespoke 17×17 SVGs in the card's own icon
  style** (not mdi — mdi glyphs are flat/single-color and looked low-quality next to
  the layered built-in icons): hot = warm sun + red thermometer, cold = snowflake +
  blue thermometer, both via `thermometerSVG`. Fills come from CSS classes
  (`.weather-sun-hot`, `.thermo-body`, `.thermo-fill-hot/-cold`, `.weather-flake`) in
  [`src/detailed-weather-forecast.css`](src/detailed-weather-forecast.css), same
  `--weather-icon-*` var pattern as `.sun`/`.cloud-front`. `neutral` (rare:
  dust/smoke/haze at a mild temp) still uses `mdi:weather-hazy`. Thresholds mirror the
  card's temp-color extremes. Unit is threaded into `getWeatherStateIcon` via a 5th arg
  (`temperatureUnit`) from the daily/hourly lists' `_temperatureUnit()`;
  `getCurrentWeatherStateIcon` reads it off the entity. Resolution order:
  entity_picture → user icon_map → CSS `--weather-icon-*` → animated SVG →
  **exceptional split (native SVG)** → mdi fallback → undefined.

## Log
- 2026-06-20 — PLAN.md created (workspace-wide plan-tracking convention added).
- 2026-06-26 — Fixed blank daily/hourly icons on `exceptional` days (NWS). First
  added a generic mdi fallback; then a temperature-split tinted mdi; then replaced mdi
  with **bespoke native layered SVGs** (sun+thermometer / snowflake+thermometer) drawn
  in the card's own icon style so they match the built-in icons' quality. Built + deployed.
