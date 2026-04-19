# Changelog

All notable changes to this project will be documented in this file.

Versions follow a **year-sequence** scheme (`YYYY.nn`), not semver:
- `YYYY` is the year of release
- `nn` is a sequential counter starting at `1`, reset each new year

Each version header matches its corresponding git tag exactly.

---

## [2026.2] - 2026-04-19

### Added
- `common/i18n.js`: full internationalisation system (EN, FR, ES)
  - browser language auto-detection with fallback to English
  - language persisted in `localStorage`
  - language selector dropdown in the navigation bar
- CSS custom properties (`var(--i18n-*)`) for translatable `::before`/`::after`
  pseudo-element content
- Cross-frame language synchronisation via `postMessage` (see `CODING.md`)
- `CODING.md`: architecture documentation and technical decisions
- `CLAUDE.md`: project directives for Claude Code

### Changed
- Build logic moved from `build.sh` into `Makefile` directly
- `Makefile`: added `movies` and `tvshows` targets; `all` depends on both;
  coloured help output; `help` is the default target
- `README.md`: updated building instructions, added Acknowledgements section,
  removed TODO section
- All Markdown files translated to English

### Removed
- `build.sh` (functionality integrated into `Makefile`)

---

## [2026.1] - 2026-04-18

### Added
- Initial release: movies and TV shows templates forked from Dark Template
  (original source: https://buron.coffee/files/darkTemplate)
- Responsive dark UI inspired by Emby
- Fuzzy title search (`fuzzyset.js`)
- Lazy image loading
- `index.html` navigation bar with iframe switching between movies and TV shows
- Both templates exportable to the same directory without filename clash
- Video format and main audio codec displayed on detail pages
- `Makefile` and `build.sh` for building and packaging
