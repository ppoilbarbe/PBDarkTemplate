#!/usr/bin/env bash
# Extracts the changelog section for a given version tag from CHANGELOG.md.
# Usage: extract_changelog.sh <version> [changelog_file]
# Example: extract_changelog.sh 2026.3
set -euo pipefail

VERSION="${1:?Usage: $0 <version> [changelog_file]}"
CHANGELOG="${2:-CHANGELOG.md}"

awk -v ver="$VERSION" '
    /^## \[/ { found = ($0 ~ "\\[" ver "\\]"); next }
    found && /^---$/ { exit }
    found { print }
' "$CHANGELOG" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' \
              | awk 'NF || p { print } { p = NF }'
