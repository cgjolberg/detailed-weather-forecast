# detailed-weather-forecast — working plan

> **Working plan — auto-printed at session start** by the workspace `SessionStart` hook
> ([`../.claude/print-plans.ps1`](../.claude/print-plans.ps1)). Holds **current state + future
> work only** — sections *Current focus* / *Next steps* / *Open questions* / *Decisions & context
> worth keeping*. Git history is the record of what shipped; completed work is pruned in the same
> commit that ships it. Dates are `YYYY-MM-DD`, newest-first.

## Current focus
_Idle._ No active task.

## Next steps
- (none)

## Open questions
- (none)

## Decisions & context worth keeping
- **2026-06-26 — `exceptional` days render temperature-split native SVG icons** (hot = sun + red
  thermometer, cold = snowflake + blue thermometer; NWS collapses hot/cold/storm into one
  `exceptional`, so temperature picks the art). The icon resolution order lives in
  [`src/weather.ts`](src/weather.ts).
