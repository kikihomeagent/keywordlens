#!/bin/bash
# generate-release-notes.sh
# Auto-generates release notes from git commits since last tag

set -e

REPO_URL=$(git remote get-url origin 2>/dev/null | sed 's/\.git$//' | sed 's/git@github.com:/https:\/\/github.com\//')
LATEST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "")

if [ -z "$LATEST_TAG" ]; then
    echo "## Release Notes"
    echo ""
    echo "### Changes"
    git log --pretty=format:"- %s (%h)" --no-merges | head -30
else
    echo "## Release Notes (since $LATEST_TAG)"
    echo ""
    echo "### Changes"
    git log ${LATEST_TAG}..HEAD --pretty=format:"- %s (%h)" --no-merges
fi

echo ""
echo "### Full Changelog"
echo "${REPO_URL}/compare/${LATEST_TAG:-main}...main"
