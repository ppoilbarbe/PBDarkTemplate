# Changelog

All notable changes to this project will be documented in this file.

Versions follow a **year-sequence** scheme (`YYYY.nn`), not semver:
- `YYYY` is the year of release
- `nn` is a sequential counter starting at `1`, reset each new year

Each version header matches its corresponding git tag exactly.

---

## [2026.4] - 2026-04-20

### Added
- `scripts/extract_changelog.sh`: extracts the changelog section for a given
  version tag from `CHANGELOG.md`
- Pre-commit hooks: ESLint (JS), Stylelint (CSS), HTMLHint (HTML),
  markdownlint-cli2 (Markdown), shellcheck (shell), `scripts/check_jmte.py`
  (JMTE block nesting), plus general checks (trailing whitespace, EOF,
  line endings, merge conflicts)
- `scripts/check_jmte.py`: validates `${foreach}`/`${if}`…`${end}` nesting
  in JMTE template files
- `.github/workflows/ci.yml`: unified CI workflow — lint and build run on
  every push and pull request; release is created only on tags matching
  `[0-9][0-9][0-9][0-9].[0-9]*` and only if both jobs pass
- `CODING.md`: Pre-commit hooks and CI sections

### Changed
- `README.md`: updated building instructions to match `make` behaviour

### Removed
- `.github/workflows/release.yml`: replaced by `ci.yml`

---

## [2026.3] - 2026-04-19

### Added
- Movie detail page: collapsible cast section (open by default) showing photo,
  actor name and role; falls back to `nopicture.gif` when no photo is available
- TV show detail page: collapsible cast section (closed by default)
- TV show detail page: episodes grouped by season in collapsible sections
  (open by default), built dynamically by `tvshows_detail.js`
- `common/i18n.js`: keys `cast` and `season` added to all 7 languages
- `common/i18n.js`: helper function `t(key, lang?)` for imperative translation
  in JavaScript modules
- `common/common_style.css`: cast section styles shared between both templates
- `tvshows/tvshows_detail.js`: new JS module for TV show detail page behaviour

### Fixed
- Language selector: current language button now shows the flag only, without
  the language code text

### Changed
- `movies/movies_style.css`: cast section styles removed (moved to common)
- `CODING.md`: versioning scheme moved to the opening section

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
