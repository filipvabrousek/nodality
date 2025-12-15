# Automation

## 1 - onlyPublish.sh
1) Check git login
2) Runs local tests
3) Uploads to GitHub

Run in ```/Users/filipvabrousek/launch``` folder

```sh
#!/bin/bash


auth_output=$(gh auth status 2>&1)
if echo "$auth_output" | grep -q 'github\.com as nodalityjs'; then
  echo "🚀 Logged in as nodalityjs — continuing."
else
  echo "🚫 Not logged in as nodalityjs. Aborting."
  exit 1
fi

# ----------------------------
# Run tests locally first
# ----------------------------
echo "🧪 Running local tests..."
if ! npm run test; then
  echo "❌ Tests failed. Aborting release."
  exit 1
fi
echo "✅ All tests passed."

# ----------------------------
# Commit, tag, and push
# ----------------------------
# only change in package.json
VERSION=$(node -p "require('./package.json').version")

git add .
git commit -m "release: v$VERSION"
git tag "v$VERSION"

# Push commits
if git push --set-upstream origin main; then
  echo "🚀 Commits pushed to GitHub successfully."
else
  echo "⚠️ Push failed, attempting pull with rebase..."
fi

# Push tag
if git push origin "v$VERSION"; then
  echo "🚀 Tag v$VERSION pushed to GitHub successfully."
else
  echo "❌ Failed to push tag v$VERSION. Aborting."
  exit 1
fi
```

## 2 - Secrets
* Generate npm token at ```https://www.npmjs.com/settings/filipvabrousek/tokens```
* Bypass 2FA, all permission, 90 days
* ```Github.com``` Nodality repo => Settings => Secrets and Variables => Repository secret ```NPM TOKEN```, paste token from NPM


## 3 - Upload script at GitHub Actions

```yaml
name: Publish to NPM

on:
  push:
    tags:
      - 'v*.*.*'

jobs:
  publish:
    runs-on: ubuntu-latest
    permissions:
      contents: write
      id-token: write

    steps:
      # 1. Checkout code
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      # 2. Setup Node.js (includes npm)
      - uses: actions/setup-node@v4
        with:
          node-version: '18.20.0'
          registry-url: 'https://registry.npmjs.org'
          cache: 'npm'

      # 3. Install dependencies
      - run: npm ci

      # 6. Build packages
      - run: npm run build
      - run: npm run inject-license || true

      # 7. Verify version matches tag
      - name: Verify version matches tag
        run: |
          TAG="${GITHUB_REF#refs/tags/}"
          VERSION="${TAG#v}"
          FILE_VERSION=$(node -p "require('./package.json').version")
          if [ "$VERSION" != "$FILE_VERSION" ]; then
            echo "Version mismatch: tag=$VERSION, package.json=$FILE_VERSION"
            exit 1
          fi

      # 8. Publish to npm
      - name: Publish to NPM
        env:
          NODE_AUTH_TOKEN: ${{ secrets.NPM_TOKEN }}
        run: npm publish --access public --provenance
```



