# PB Dark Template

## Description

These templates are inspired by
[tinymediamanager_dark_template](https://github.com/jhartlep/tinymediamanager_dark_template)
by jhartlep (originally marked as from https://buron.coffee/files/darkTemplate).

There is two templates:

- PBDarkTemplateMovies: a template for movies
- PBDarkTemplateTVShows: a template for... TV shows

They are based on Dark Template with many enhancements:

- Both can be exported in the same directory without filename clash
- There is a main index file to switch from movies to TV shows and back

## Improvements over the original

### Two templates, one export directory

The original repository provides a single movies template. PB Dark Template
adds a TV shows template and ensures both can coexist in the same export
directory without any filename conflict.

### Unified navigation

A top-level `index.html` wraps both templates in a shared navigation bar with
an iframe. Switching between movies and TV shows does not reload the page.
The active section is visually highlighted in the navigation bar.

### Internationalisation

The original template is English-only. PB Dark Template ships a complete i18n
system:

- **Languages included**: English, French, Spanish, Italian, Russian, Chinese,
  Vietnamese
- **Auto-detection**: language is read from the browser's locale on first visit
- **Persistent selector**: a flag-based dropdown in the navigation bar lets the
  user override the language; the choice is stored in `localStorage`
- **Full coverage**: UI labels, search placeholder, and CSS pseudo-element
  content (genres, director, format labels…) are all translated
- **Extensible**: adding a language requires one entry in `i18n.js` and one
  entry in the `langFlags` map in `index.html` (flag served from
  [flagcdn.com](https://flagcdn.com)); see `CODING.md` for details

### Title search

A search bar is present on both list pages. It uses:

1. **Substring matching** as the primary strategy — accent-insensitive, case-insensitive
2. **Fuzzy matching** as a fallback (threshold 0.5) for tolerance of typos when
   no substring match is found

The original template has no search feature.

### Media information

The movie list and detail page display the video format and audio codec
(sourced from tinyMediaManager's media info). The original template does not
expose this information.

### Lazy image loading

Poster and banner images are loaded lazily via `IntersectionObserver` with a
200 px pre-load margin, replacing the original eager loading.

### Code architecture

- Shared CSS (`common/common_style.css`) and shared JS (`common/search.js`)
  extracted from duplicated template-specific files
- Generic class names (`media-card`, `media-list`, `media-header`) used in
  common code to avoid coupling between templates
- Build system via `Makefile` producing versioned zip archives ready for
  installation in tinyMediaManager

## Building

Run `make all` to build both templates.

This will create a `build/` directory containing both templates and their
zip archives.

### Requirements by platform

**Linux** (native)

- `make` — usually pre-installed; otherwise install via your package manager
  (e.g. `sudo apt install make`)
- `zip` — e.g. `sudo apt install zip`

**macOS** (native)

- Xcode Command Line Tools (provides `make`, `bash`, `zip`):
  ```
  xcode-select --install
  ```

**Windows** (via WSL)

1. Enable WSL and install a Linux distribution (e.g. Ubuntu) from the
   Microsoft Store.
2. Inside WSL, install the required tools:
   ```
   sudo apt update && sudo apt install make zip
   ```
3. Open a WSL terminal, navigate to the project directory, and run `make`.

### Available targets

| Command        | Description                   |
|----------------|-------------------------------|
| `make`         | Show available targets        |
| `make all`     | Build both templates          |
| `make clean`   | Remove the `build/` directory |

## License

[MIT](LICENSE)

## Acknowledgements

The i18n architecture and cross-frame communication patterns were designed
with the assistance of [Claude](https://claude.ai) by
[Anthropic](https://www.anthropic.com).

## Installing

Once built, you can (choose one method):

- copy the built directories in the "templates" directory of tinyMediaManager
- unzip the zip files in the "templates" directory of tinyMediaManager

