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
`header_chip_font_size`, `header_line_height`, `card_min_height`, `header_padding`. Plus `notch`
(2026-08-23), which is a shape option rather than a sizing one — see below.

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
rather than a hard cut. A stacked two-line header option is the real fix if that ever matters —
though the kitchen dashboard solved its instance by giving the card more *width* instead (see
`notch` below).

**`notch` added 2026-08-23** — cuts a rectangular bite out of the card's bottom-right corner, so
the card renders as an L and a consumer can tuck other cards into the gap. Built for the kitchen
dashboard's hero band, where the card now spans the full width for its top row and the three
"find my device" tiles sit in the notch underneath.

The one thing to hold onto: **`clip-path` cuts the element's PAINTED BOX, which is where a card's
entire edge treatment lives.** Everything awkward about this feature follows from that.

- **The `box-shadow` cannot survive it** — it is clipped away with everything else, leaving the
  card flat. The rule sets `box-shadow: none` and swaps in `filter: drop-shadow(...)`, applied to
  the *post-clip* result so it hugs the L. `drop-shadow()` takes **no spread radius**, so a
  four-length `box-shadow` value will not transfer — hence "no spread" in the docs. Note this also
  makes the shadow scale with the element's own alpha, so a translucent card gets a weaker shadow
  than an opaque neighbour. No fix for that short of abandoning `drop-shadow`.
- **The border cannot survive it either**, so the whole outline is redrawn as a ring
  (`.weather-card.notched::after`): the silhouette and its one-border-width-eroded copy in a
  single `evenodd` path, filled with `--ha-card-border-color`. A partial stroke along just the two
  new edges is not an option — `border-*` cannot follow an arc, so it could never join the
  surviving border cleanly at the step. The card keeps `border-color: transparent` rather than
  `border: none`, which holds every metric and the clip's coordinate space identical.
- **The ring is one path with a hole.** Trace the outside, close it, seam across to the inside,
  trace and close that, and let the implicit closing edge retrace the seam. The doubled seam is
  degenerate so `evenodd` drops the interior. Both traces start on the left edge at the same
  height, which keeps the seam one border width long. **Reorder either trace and the fill rule
  inverts** — the symptom is the card rendering as a solid slab of border colour.
- **`0` and `0px` are not interchangeable inside `calc()`.** A bare zero is a `<number>`, and
  number + length is a type error that invalidates the *entire* polygon — which drops the clip
  silently rather than degrading. Cost an hour on 2026-08-23: the card rendered as an unclipped
  grey rectangle because the top-left and bottom-left corners were traced from `0`.
- **Corner radii are separate on purpose** (`corner_radius` / `inner_radius`). Concentric rounding
  wants them different: a thing sitting in the notch with radius `t` across a gap `g` needs the
  concave corner at `t + g` for that gap to stay an even width around the corner, while the two
  convex corners are ordinary outer corners of the card and want its own radius. The kitchen
  dashboard runs 20px convex against 24px concave for exactly this reason.

Arcs are sampled as 7-point polylines rather than drawn, because `polygon()` has no arc primitive
and `shape()`, which does, is far too new to rely on inside an Android WebView. Six segments keeps
the worst-case radial error near 0.2px. Every coordinate stays symbolic — `calc()` over custom
properties — so the card never needs its own pixel size, and the paths are constant strings built
once for the module rather than per render.

`--dwf-notch-*` must be set in `cardStyle` (the root `ha-card`) and **not** `headerStyles`, for the
same reason as `card_min_height`: `.weather-card` is the element being clipped.

`header_padding` shipped alongside it and exists for the same layout. The notch can only be as deep
as the space *below* the condition/temperature row, and that row's height is padding plus the temp's
line box — so trimming the padding asymmetrically (`12px 16px 6px`) is what buys notch depth without
shrinking the temperature. It is a full CSS shorthand and is therefore **not** run through
`_normalizeCssSizeValue()`, which is single-value only; same carve-out as `header_line_height`.

## Next steps
- (none)

## Open questions
- (none)

## Decisions & context worth keeping
- **2026-06-26 — `exceptional` days render temperature-split native SVG icons** (hot = sun + red
  thermometer, cold = snowflake + blue thermometer; NWS collapses hot/cold/storm into one
  `exceptional`, so temperature picks the art). The icon resolution order lives in
  [`src/weather.ts`](src/weather.ts).
