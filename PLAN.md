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

**Sizing options added 2026-08-22/23**, all defaulting to previous behaviour: `header_icon_size`,
`header_chip_font_size`, `header_line_height`, `card_min_height`.

The one worth remembering is `header_line_height`. The compact header set **no** line-height, so
the condition and temperature inherited roughly 1.6 — a 96px temperature occupied a ~154px box for
~96px of glyph, and the card blew past its dashboard cell. Tight leading (`1.05`) reclaimed ~50px
and was the difference between 96px fitting and not. If a consumer reports the compact header
being unexpectedly tall, this is why.

`card_min_height` exists because `.weather-card` has a hard `min-height: var(--card-height, 200px)`
floor with no setter — the card could never be shorter than 200px however tight its content, which
forced an overhang in any cell smaller than that. `--card-height` must be set in `cardStyle` (the
root `ha-card`), not `headerStyles`: CSS custom properties inherit downward only.

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
