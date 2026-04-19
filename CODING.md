# CODING — Architecture and technical decisions

## General architecture

The project produces two independent tinyMediaManager templates (movies and TV shows)
from partially shared sources.

```
common/          Shared files copied into both templates at build time
movies/          Sources specific to the movies template
tvshows/         Sources specific to the TV shows template
build/           Output directory (generated, not versioned)
```

The `Makefile` copies the specific directory (`movies/` or `tvshows/`), overlays
`common/` on top, then zips the result.

### Structure of a rendered output

```
index.html            Container page — navigation bar + iframe
movielist.html        Movie list (rendered from movies/list.jmte)
tvshows.html          TV show list (rendered from tvshows/list.jmte)
movies/<film>.html    Movie detail (rendered from movies/detail.jmte)
<show>/tvshow.html    TV show detail (rendered from tvshows/detail.jmte)
```

`index.html` displays pages inside an `<iframe id="mainBlock">`. All internal
navigation (list → detail) takes place within that iframe.

---

## i18n system

### `common/i18n.js`

Loaded by every page. Exposes the following global functions:

| Function | Role |
|---|---|
| `applyI18n(lang?)` | Applies translations to the current page |
| `detectLanguage()` | Returns the active language (localStorage > browser > `en`) |
| `setLanguage(lang)` | Saves the language to `localStorage` |
| `getAvailableLanguages()` | Returns the list of defined languages |

**Adding a language**: two files to update.

1. `common/i18n.js` — add an entry to the `translations` object.
   The language selector populates itself automatically from `Object.keys(translations)`.

2. `common/index.html` — add an entry to the `langFlags` map with the
   [ISO 3166-1 alpha-2](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2) country
   code of the flag to display:

   ```javascript
   const langFlags = {
       de: 'flag_de.png',
       // …
   };
   ```

   The flag PNG files (`flag_<lang>.png`, 16×12 px) are **not versioned**. They
   are downloaded automatically into each build directory by `make flags` (or
   by `make movies` / `make tvshows` / `make all`). The source is
   [flagcdn.com](https://flagcdn.com); the country code used for the URL is
   defined in the `case` statement of the `download_flags` block in the
   `Makefile` (only exceptions need to be listed — languages whose ISO 639-1
   code differs from their
   [ISO 3166-1 alpha-2](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2)
   country code, e.g. `en` → `gb`, `zh` → `cn`).

   If a language code has no entry in `langFlags`, the selector shows the code
   without a flag.

### Translating HTML elements

Elements to be translated carry a `data-i18n` attribute (text content)
or `data-i18n-placeholder` (the `placeholder` attribute of `<input>` elements).
The hard-coded text in the HTML is the English default.

```html
<h1 data-i18n="movies-title">Movies</h1>
<input data-i18n-placeholder="search-placeholder" placeholder="search by title"/>
```

### Translating CSS pseudo-elements

The `content:` property of `::before`/`::after` pseudo-elements cannot be
modified directly from JavaScript. The solution is to use CSS custom properties
with a fallback default:

```css
.genres:before {
    content: var(--i18n-genres, "Genres: ");
}
```

`applyI18n()` injects the translated values on `:root` via
`document.documentElement.style.setProperty('--i18n-genres', '"Genres: "')`.
**The value passed must include the CSS quotes** (it is a CSS string, not a raw
value): `'"Genres: "'` in JavaScript produces `"Genres: "` in CSS.

---

## Cross-frame communication

### Problem

`index.html` holds the language selector. Translatable pages are loaded inside
an `<iframe>`. Three mechanisms were considered for synchronising the language
between the parent and the iframe.

### What does not work

**Direct call `iframeWin.applyI18n()`**: some browsers (depending on privacy
settings) silently block access to functions in another frame's context, even
when same-origin.

**`storage` event**: the `storage` event is supposed to propagate to all
same-origin windows, including iframes. In practice, depending on the browser
and privacy settings, it does not fire reliably inside an iframe.

### Chosen solution: `postMessage`

`postMessage` is the standard cross-frame communication API. It works
regardless of privacy settings and does not depend on `localStorage` being
shared across frames.

**User changes the language** (selector in `index.html`):

```javascript
// index.html
setLanguage(lang);
applyI18n(lang);
iframe.contentWindow.postMessage({ type: 'pb-lang', lang: lang }, '*');
```

**Navigation to a new page inside the iframe**: the new page receives no
automatic `postMessage`. It must request the language from the parent.

```javascript
// i18n.js — on DOMContentLoaded
applyI18n();   // best-effort via localStorage (may fail depending on context)
if (window !== window.parent) {
    window.parent.postMessage({ type: 'pb-lang-request' }, '*');
}
```

```javascript
// index.html — global listener (outside DOMContentLoaded)
window.addEventListener('message', function(e) {
    if (e.data && e.data.type === 'pb-lang-request') {
        e.source.postMessage({ type: 'pb-lang', lang: detectLanguage() }, '*');
    }
});
```

The parent replies with `detectLanguage()`, which reads from its own
`localStorage` — reliable because it runs in the top-level page.

### Summary of communication flows

| Trigger | Mechanism |
|---|---|
| User selects a language in the nav bar | `postMessage` `pb-lang` → current iframe |
| Navigation to a new page inside the iframe | `pb-lang-request` → parent → `pb-lang` |
| Initial load / fallback | `detectLanguage()`: localStorage then browser language |
| Multiple tabs | `storage` event (supplementary, not reliable on its own) |

---

## Relative paths to `i18n.js`

After the build, `i18n.js` sits at the template root. Paths vary by page depth:

| Page | Path |
|---|---|
| `movielist.html`, `tvshows.html` | `src="i18n.js"` |
| `movies/<film>.html`, `<show>/tvshow.html` | `src="../i18n.js"` |
