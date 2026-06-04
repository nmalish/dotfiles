#!/bin/bash
# Bump biqh-ui-shell to latest and commit the change.
# Run from any repo that depends on biqh-ui-shell.

set -euo pipefail

if [ ! -f package.json ]; then
    echo "Error: no package.json in $(pwd)" >&2
    exit 1
fi

PKG="biqh-ui-shell"

get_version() {
    node -p "require('./package.json').dependencies['$PKG'] || require('./package.json').devDependencies['$PKG'] || ''" 2>/dev/null
}

OLD_VERSION=$(get_version)
if [ -z "$OLD_VERSION" ]; then
    echo "Error: $PKG is not a dependency in $(pwd)/package.json" >&2
    exit 1
fi

echo "Current $PKG: $OLD_VERSION"
echo "Installing $PKG@latest..."
npm i "$PKG@latest" --cache /tmp/empty-cache

NEW_VERSION=$(get_version)
echo "New $PKG: $NEW_VERSION"

if [ "$OLD_VERSION" = "$NEW_VERSION" ]; then
    echo "Already up to date. Nothing to commit."
    exit 0
fi

if ! git diff --quiet -- package.json package-lock.json 2>/dev/null; then
    git add package.json package-lock.json
    CLEAN_VERSION=${NEW_VERSION#^}
    CLEAN_VERSION=${CLEAN_VERSION#~}
    git commit -m "bump ui to v${CLEAN_VERSION}"
    echo "Committed: bump ui to v${CLEAN_VERSION}"
else
    echo "No changes detected in package.json/package-lock.json."
fi
