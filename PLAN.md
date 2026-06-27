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
condition (deployed 2026-06-26). No active task.

## Next steps
- [ ] (none yet)

## Open questions / blockers
- (none)

## Decisions & context worth keeping
- **Forecast icons fall back to mdi when there's no animated SVG.** `weatherSVGs`
  in [`src/weather.ts`](src/weather.ts) covers every standard condition *except*
  `exceptional`. NWS (this dashboard's `weather.weather`) reports extreme heat/cold
  and hazards as `exceptional`, so those days rendered blank. `getWeatherStateIcon`
  / `getCurrentWeatherStateIcon` now fall through to `WEATHER_CONDITION_FALLBACK_ICONS`
  (mirrors the HA frontend's icon map) → `<ha-icon>`, sized by the existing
  `.forecast-image-icon ha-icon` CSS. Resolution order: entity_picture → user
  icon_map → CSS `--weather-icon-*` → animated SVG → **mdi fallback** → undefined.

## Log
- 2026-06-20 — PLAN.md created (workspace-wide plan-tracking convention added).
- 2026-06-26 — Fixed blank daily/hourly icons on `exceptional` days (NWS extreme
  heat) by adding an mdi fallback map in `src/weather.ts`. Built + deployed.
