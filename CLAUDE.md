# Directives for Claude Code

## Shared files (`common/`)

Files in the `common/` directory are shared between both templates
(movies and tvshows). They must work in both contexts.

- Never specialise a `common/` file for a single template.
- Data or processing that is superfluous for one of the templates is acceptable.
- Any logic specific to a template belongs in `movies/` or `tvshows/`, not in `common/`.

## Versioning

Versions follow a **year-sequence** scheme (`YYYY.nn`), not semver:
- `YYYY` is the year of release
- `nn` is a sequential counter starting at `1`, reset each new year

Each version corresponds to a git tag with the exact same name (e.g. `2026.1`).
When creating a new version:
1. Add a `## [YYYY.nn] - YYYY-MM-DD` section at the top of `CHANGELOG.md`
2. Create the matching git tag
