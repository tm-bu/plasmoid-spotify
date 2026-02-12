# Clean Implementation Spec (v1–v3 only)

This spec is intentionally minimal and avoids feature bloat.

## Goals
- Keep the plasmoid visually clean by default.
- Improve usability and reliability.
- Add customization through sensible presets and a few high-value options.
- Explicitly skip multi-player support (no v4).

---

## Scope
### Included
1. Playback controls (optional, unobtrusive)
2. Lyrics quality/customization (offset + highlight color + animation mode)
3. Lyrics caching (in-memory)
4. Layout presets (small set)

### Excluded
- Multi-player / non-Spotify support
- Complex theme engines
- Large advanced settings matrix

---

## v1 — Controls (clean + discoverable)

### UX
- Add an optional hover controls row over artwork:
  - Previous, Play/Pause, Next
- Default: disabled (keeps current clean look)
- If enabled, controls appear only on hover.

### New config keys (`General`)
- `showPlaybackControls` (Bool, default `false`)
- `leftClickAction` (String, default `"raise"`)
- `middleClickAction` (String, default `"playPause"`)
- `rightClickAction` (String, default `"none"`)
- `wheelAction` (String, default `"volume"`)
- `volumeStepPercent` (Int, default `2`, min `1`, max `10`)

### Action enum values
- `raise`, `playPause`, `next`, `previous`, `none`
- Wheel: `volume`, `seek`, `none`

### Implementation notes
- Add `next()` and `previous()` wrappers in `Spotify.qml`.
- Replace hardcoded click/wheel behavior in `main.qml` with action-dispatch functions.
- Keep existing defaults to preserve current behavior.

### Acceptance criteria
- Existing users see no visual change after update.
- Enabling controls shows hover buttons and they work reliably.

---

## v2 — Lyrics customization + reliability

### UX
- Add small lyrics section options:
  - Highlight color picker
  - Lyric timing offset (ms)
  - Scroll mode (`smooth`/`snap`)

### New config keys (`General`)
- `lyricsHighlightColor` (String, default `"#808080"`)
- `lyricsOffsetMs` (Int, default `0`, min `-3000`, max `3000`)
- `lyricsScrollMode` (String, default `"smooth"`) // `smooth|snap`

### Implementation notes
- In `LyricsRenderer.qml`:
  - Use `lyricsHighlightColor` instead of hardcoded gray.
  - Apply `lyricsOffsetMs` in `getCurrentLineIndex()` position calculation.
  - If `lyricsScrollMode === "snap"`, disable `NumberAnimation` transitions.

### Acceptance criteria
- Highlight color is visibly applied to non-current lines.
- Positive/negative offset visibly shifts sync timing.
- Snap mode updates line position without interpolation.

---

## v3 — In-memory lyrics cache + layout presets

### Part A: in-memory cache

#### Behavior
- Cache parsed lyrics by key: `track|artist|album` (normalized lowercase/trimmed).
- Cache null results as miss entries to avoid repeated failing requests for same track.
- Cap cache size at 150 entries (simple FIFO/LRU approximation acceptable).

#### Implementation notes
- Add cache object and key helpers in `LyricsLrcLib.qml`.
- `fetchLyrics(...)` should check cache first.
- Keep network path unchanged if cache miss.

#### Acceptance criteria
- Replaying previously seen track does not trigger network fetch.
- Misses are not repeatedly fetched during same session.

### Part B: layout presets

#### UX
- Add `layoutPreset` dropdown in config with:
  - `compact`
  - `balanced`
  - `lyricsFocus`
- Add one button: `Apply preset`.

#### Preset mapping
- `compact`:
  - `showAlbumCover=true`
  - `showTitle=true`
  - `showArtist=false`
  - `maxTitleArtistLength=36`
- `balanced`:
  - `showAlbumCover=true`
  - `showTitle=true`
  - `showArtist=true`
  - `maxTitleArtistLength=64`
- `lyricsFocus`:
  - `showAlbumCover=false`
  - `showTitle=false`
  - `showArtist=false`
  - `showLyrics=true`

#### Acceptance criteria
- Preset application updates relevant toggles immediately.
- Presets reduce settings complexity without removing manual overrides.

---

## Non-functional constraints
- Keep current default visual behavior unless user opts in.
- No invasive UI additions in panel mode.
- Avoid adding external dependencies.

---

## Suggested delivery order
1. v1 controls (highest UX impact)
2. v2 lyrics offset/color/scroll mode
3. v3 cache
4. v3 layout presets

---

## Test plan (manual)
- Start with Spotify playing and verify legacy behavior unchanged.
- Enable each new option independently and verify no regression.
- Confirm cached tracks avoid repeated lyric API calls (via logs).
- Resize plasmoid and verify controls/presets remain readable.
