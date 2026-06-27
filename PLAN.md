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
_Idle._ Just fixed missing daily/hourly forecast icons for the `exceptional`
condition — now a temperature-split, tinted icon (deployed 2026-06-26). No active task.

## Next steps
- [ ] (none yet)

## Open questions / blockers
- (none)

## Decisions & context worth keeping
- **`exceptional` is temperature-split into tinted hot/cold/neutral icons.** NWS
  collapses Hot, Cold, Tornado, Hurricane, Tropical storm, Dust, Smoke and Haze all
  into the single `exceptional` condition, and the card only receives
  `condition: exceptional` (the source word is lost) — so the only signal to tell
  hot from cold is the day's temperature. `resolveExceptionalIcon` in
  [`src/weather.ts`](src/weather.ts) picks: hot (≥86°F/30°C) → `mdi:sun-thermometer`
  tinted `var(--orange-color)`; cold (≤32°F/0°C) → `mdi:snowflake-thermometer` tinted
  `var(--blue-color)`; otherwise → `mdi:weather-hazy` (no tint). Thresholds mirror the
  card's temp-color extremes. The unit is threaded into `getWeatherStateIcon` via a new
  5th arg (`temperatureUnit`) from the daily/hourly lists' `_temperatureUnit()`;
  `getCurrentWeatherStateIcon` reads it off the entity. Any *other* non-SVG condition
  still falls back via `WEATHER_CONDITION_FALLBACK_ICONS`. Resolution order:
  entity_picture → user icon_map → CSS `--weather-icon-*` → animated SVG →
  **exceptional split / mdi fallback** → undefined.

## Log
- 2026-06-20 — PLAN.md created (workspace-wide plan-tracking convention added).
- 2026-06-26 — Fixed blank daily/hourly icons on `exceptional` days (NWS). First
  added a generic mdi fallback; then refined `exceptional` into a temperature-split,
  warm/cool-tinted icon (sun-thermometer / snowflake-thermometer / weather-hazy) per
  user's pick. Built + deployed.
