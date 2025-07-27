# Get the current GitHub user
auth_output=$(gh auth status 2>&1)

# Check if logged in as 'nodalityjs'
if echo "$auth_output" | grep -q 'github\.com as nodalityjs'; then
  echo "🚀 Logged in as nodalityjs — continuing."
else
  echo "🚫 Not logged in as nodalityjs. Aborting."
  exit 1
fi

cp -R /Users/filipvabrousek/Desktop/layout/layout /Users/filipvabrousek/launch/
cp -R /Users/filipvabrousek/Desktop/layout/lib /Users/filipvabrousek/launch/

# Run Playwright tests
echo "🧪 Running Playwright tests..."
if ! npx playwright test; then
  echo "❌ Playwright tests failed. Aborting release."
  exit 1
fi
echo "✅ All tests passed."


current_version=$(grep -o '"version": "[^"]*"' package.json | sed -E 's/"version": "([0-9]+\.[0-9]+\.[0-9]+-beta\.)([0-9]+)"/\2/'); \
next_version=$((current_version + 1)); \
sed -i '' -E "s/(\"version\": \"[0-9]+\.[0-9]+\.[0-9]+-beta\.)[0-9]+\"/\1${next_version}\"/" package.json
npm run inject-license
npm run build
npm publish

echo "✅ Publish complete. Now updating create-nodality..."
# Step 4: Sync create-nodality
cd /Users/filipvabrousek/create-nodality

full_version="1.0.0-beta.${next_version}"

# ✅ Update package version to full beta version
sed -i '' -E "s/(\"version\": \")1\.0\.0-beta\.[0-9]+\"/\1${full_version}\"/" package.json

# ✅ Update nodality dependency in package.json to ^1.0.0-beta.xx
sed -i '' -E "s/(\"nodality\": \")\^1\.0\.0-beta\.[0-9]+\"/\1\\^${full_version}\"/" package.json

# ✅ Update hardcoded nodality version in bin/index.js
sed -i '' -E "s/(nodality: \\\")\^1\.0\.0-beta\.[0-9]+(\\\")/\1\\^${full_version}\2/" bin/index.js

npm publish

echo "✅ Publish complete. Create Nodality updated"


cd /Users/filipvabrousek/create-nodality-react
sed -i '' -E "s/(\"version\": \")1\.0\.0-beta\.[0-9]+\"/\1${full_version}\"/" package.json
sed -i '' -E "s/(nodality: \\\")\^1\.0\.0-beta\.[0-9]+(\\\")/\1\\^${full_version}\2/" bin/index.js
npm publish
echo "✅ Publish complete. Create Nodality React updated"

cd /Users/filipvabrousek/create-nodality-vue
sed -i '' -E "s/(\"version\": \")1\.0\.0-beta\.[0-9]+\"/\1${full_version}\"/" package.json
sed -i '' -E "s/(nodality: \\\")\^1\.0\.0-beta\.[0-9]+(\\\")/\1\\^${full_version}\2/" bin/index.js
npm publish
echo "✅ Publish complete. Create Vue updated"