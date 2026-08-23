# detailed-weather-forecast — working plan

> **Working plan — auto-printed at session start** by the workspace `SessionStart` hook
> ([`../.claude/print-plans.ps1`](../.claude/print-plans.ps1)). Holds **current state + future
> work only** — sections *Current focus* / *Next steps* / *Open questions* / *Decisions & context
> worth keeping*. Git history is the record of what shipped; completed work is pruned in the same
> commit that ships it. Dates are `YYYY-MM-DD`, newest-first.

## Current focus
_Idle._ No active task.

**Compact-header sizing was fixed 2026-08-22** while making the kitchen dashboard readable from
across the room. Worth knowing if you touch the header again: `.compact-header .temp` had
`font-size` **hardcoded** to `var(--ha-font-size-3xl, 28px)`, so the documented `temp_font_size`
option was silently ignored on that branch and only ever worked with `show_background: true`.
It now reads `--dwf-header-temp-font-size` like its `show_background` counterpart. Added
`header_icon_size` at the same time, because `--icon-size: 60px` was set directly ON
`.compact-header`, which beats any `:host` or theme override.

Also note `.compact-header .current-conditions` is a single **non-wrapping** flex row, and both
`.condition` and `.temp` carry `overflow: hidden` (so their flex `min-width` resolves to 0). At
large temperature sizes the condition text loses the width fight; it now ends in an ellipsis
rather than a hard cut. A stacked two-line header option is the real fix if that ever matters.

## Next steps
- (none)

## Open questions
- (none)

## Decisions & context worth keeping
- **2026-06-26 — `exceptional` days render temperature-split native SVG icons** (hot = sun + red
  thermometer, cold = snowflake + blue thermometer; NWS collapses hot/cold/storm into one
  `exceptional`, so temperature picks the art). The icon resolution order lives in
  [`src/weather.ts`](src/weather.ts).
