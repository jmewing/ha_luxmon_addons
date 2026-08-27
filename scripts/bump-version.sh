#!/bin/bash
# Determine the next version for the ha_luxmon_addons add-on.
#
# The add-on version is COUPLED to the integration version in the ha_luxmon
# repo: the add-on's run.sh downloads the integration release tagged with its
# own version:
#
#   https://github.com/jmewing/ha_luxmon/releases/download/v${VERSION}/luxmon.zip
#
# So the add-on version must always match the latest ha_luxmon release tag.
# This script:
#   1. Fetches the latest ha_luxmon release tag (via the GitHub API).
#   2. If the add-on's config.yaml is already at that version, exits 1
#      (nothing to release).
#   3. Otherwise prints the target version (and optionally writes it back).
#
# Usage:
#   scripts/bump-version.sh            # print the target version (dry run)
#   scripts/bump-version.sh --write    # also update luxmon/config.yaml
#
# Exit codes:
#   0  target version determined (printed to stdout)
#   1  add-on already in sync with the integration (nothing to release)

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VERSION_FILE="$REPO_DIR/luxmon/config.yaml"

# The integration repo to track. Override with INTEGRATION_REPO for testing.
INTEGRATION_REPO="${INTEGRATION_REPO:-jmewing/ha_luxmon}"

WRITE=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --write) WRITE=1 ;;
    *) echo "Unknown arg: $1" >&2; exit 2 ;;
  esac
  shift
done

# ── Current add-on version (config.yaml) ───────────────────────────────────
FILE_VERSION="$(grep -oE '^version:[[:space:]]*"?[0-9]+\.[0-9]+\.[0-9]+"?' "$VERSION_FILE" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)"
if [[ -z "$FILE_VERSION" ]]; then
  echo "Could not parse version from $VERSION_FILE" >&2
  exit 2
fi

# ── Latest integration release tag ─────────────────────────────────────────
# Use the GitHub API to get the latest release tag. Fall back to the git tag
# list if the API is unavailable (e.g. no network in a local dry run).
TARGET_VERSION=""
if command -v curl >/dev/null 2>&1; then
  TARGET_VERSION="$(curl -fsSL "https://api.github.com/repos/${INTEGRATION_REPO}/releases/latest" 2>/dev/null \
    | grep -oE '"tag_name"[[:space:]]*:[[:space:]]*"v?[0-9]+\.[0-9]+\.[0-9]+"' \
    | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1 || true)"
fi

if [[ -z "$TARGET_VERSION" ]]; then
  echo "Could not determine the latest ${INTEGRATION_REPO} release version" >&2
  exit 2
fi

# ── Already in sync? ────────────────────────────────────────────────────────
if [[ "$FILE_VERSION" == "$TARGET_VERSION" ]]; then
  echo "Add-on already at ${TARGET_VERSION} (in sync with ${INTEGRATION_REPO})" >&2
  exit 1
fi

# ── Write back (optional) ───────────────────────────────────────────────────
if [[ "$WRITE" -eq 1 ]]; then
  sed -i -E "s/^version:[[:space:]]*\"?[0-9]+\.[0-9]+\.[0-9]+\"?/version: \"${TARGET_VERSION}\"/" "$VERSION_FILE"
  echo "Updated $VERSION_FILE -> ${TARGET_VERSION}" >&2
fi

echo "$TARGET_VERSION"
