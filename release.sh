#!/bin/bash

# Get the current GitHub user
auth_output=$(gh auth status 2>&1)

# Check if logged in as 'nodalityjs'
if echo "$auth_output" | grep -q 'github\.com as nodalityjs'; then
  echo "🚀 Logged in as nodalityjs — continuing."
else
  echo "🚫 Not logged in as nodalityjs. Aborting."
  exit 1
fi

# Copy layout folders
cp -R /Users/filipvabrousek/Desktop/layout/layout /Users/filipvabrousek/launch/
cp -R /Users/filipvabrousek/Desktop/layout/lib /Users/filipvabrousek/launch/

# Run Playwright tests
echo "🧪 Running Playwright tests..."
if ! npm run test; then
  echo "❌ Playwright tests failed. Aborting release."
  exit 1
fi
echo "✅ All tests passed."

# Helper function to extract beta number from package.json version
get_beta_version() {
  grep -o '"version": "[^"]*"' "$1" | sed -E 's/"version": "[0-9]+\.[0-9]+\.[0-9]+-beta\.([0-9]+)"/\1/'
}

# Paths to packages
NODALITY_PATH="/Users/filipvabrousek/launch"
CREATE_NODALITY_PATH="/Users/filipvabrousek/create-nodality"
CREATE_NODALITY_REACT_PATH="/Users/filipvabrousek/create-nodality-react"
CREATE_NODALITY_VUE_PATH="/Users/filipvabrousek/create-nodality-vue"

# Get current beta versions
beta_nodality=$(get_beta_version "$NODALITY_PATH/package.json")
beta_create_nodality=$(get_beta_version "$CREATE_NODALITY_PATH/package.json")
beta_create_nodality_react=$(get_beta_version "$CREATE_NODALITY_REACT_PATH/package.json")
beta_create_nodality_vue=$(get_beta_version "$CREATE_NODALITY_VUE_PATH/package.json")

# Find highest beta version
highest_beta=$(printf "%s\n%s\n%s\n%s\n" "$beta_nodality" "$beta_create_nodality" "$beta_create_nodality_react" "$beta_create_nodality_vue" | sort -nr | head -n1)

# Bump highest beta by 1
next_beta=$((highest_beta + 1))
full_version="1.0.0-beta.${next_beta}"

echo "🔢 Highest beta version found: $highest_beta"
echo "⬆️ Bumping all packages to: $full_version"

# Update nodality
cd "$NODALITY_PATH"
sed -i '' -E "s/(\"version\": \")1\.0\.0-beta\.[0-9]+\"/\1${full_version}\"/" package.json
npm run inject-license
npm run build
npm publish
echo "✅ Published nodality@$full_version"

# Update create-nodality
cd "$CREATE_NODALITY_PATH"
sed -i '' -E "s/(\"version\": \")1\.0\.0-beta\.[0-9]+\"/\1${full_version}\"/" package.json
sed -i '' -E "s/(\"nodality\": \")\^1\.0\.0-beta\.[0-9]+\"/\1\\^${full_version}\"/" package.json
sed -i '' -E "s/(nodality: \\\")\^1\.0\.0-beta\.[0-9]+(\\\")/\1\\^${full_version}\2/" bin/index.js
npm publish
echo "✅ Published create-nodality@$full_version"

# Update create-nodality-react
cd "$CREATE_NODALITY_REACT_PATH"
sed -i '' -E "s/(\"version\": \")1\.0\.0-beta\.[0-9]+\"/\1${full_version}\"/" package.json
sed -i '' -E "s/(nodality: \\\")\^1\.0\.0-beta\.[0-9]+(\\\")/\1\\^${full_version}\2/" bin/index.js
npm publish
echo "✅ Published create-nodality-react@$full_version"

# Update create-nodality-vue
cd "$CREATE_NODALITY_VUE_PATH"
sed -i '' -E "s/(\"version\": \")1\.0\.0-beta\.[0-9]+\"/\1${full_version}\"/" package.json
sed -i '' -E "s/(nodality: \\\")\^1\.0\.0-beta\.[0-9]+(\\\")/\1\\^${full_version}\2/" bin/index.js
npm publish
echo "✅ Published create-nodality-vue@$full_version"

echo "🎉 All packages are aligned and published at version $full_version"
