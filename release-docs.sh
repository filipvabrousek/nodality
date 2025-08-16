#!/bin/bash
# Usage: ./deploy.sh "your commit message"

SRC="/Users/filipvabrousek/docosaurus-docs/nodality/build"
DEST="/Users/filipvabrousek/DOCS_PUSH/nodalityjs.github.io"

# Build project
cd /Users/filipvabrousek/docosaurus-docs/nodality || exit
npm run build

# Clear destination (but keep .git directory)
find "$DEST" -mindepth 1 ! -regex "^$DEST/.git.*" -delete

# Copy contents of build (not the folder itself)
cp -R "$SRC/"* "$DEST/"

# Git workflow
cd "$DEST" || exit
git add .
git commit -m "${1:-Auto update}"
git push
# sh releasedocs.sh "autodeploy test"
