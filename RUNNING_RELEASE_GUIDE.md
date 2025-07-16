## Running release

### Dev
```sh
sh librun.sh
```

### Release

```sh
sh launch/release.sh
```







### If branch behind

```sh
 git pull --rebase origin main
 ```









### Source
librun.sh
```sh
PORT=3000
lsof -i tcp:$PORT -t | xargs kill -9 2>/dev/null || true

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
sleep 1

nvm use 21
cd /Users/filipvabrousek/desktop/layout && serve &
sleep 1 # Give the server a chance to start

# Wait until the server is up by checking the HTTP status
while ! curl -s http://localhost:3000 >/dev/null; do
  sleep 1
done

open http://localhost:3000/designertest/1-pageSample%   
```

launch.sh
```sh
cp -R /Users/filipvabrousek/Desktop/layout/layout /Users/filipvabrousek/launch/
cp -R /Users/filipvabrousek/Desktop/layout/lib /Users/filipvabrousek/launch/
current_version=$(grep -o '"version": "[^"]*"' package.json | sed -E 's/"version": "([0-9]+\.[0-9]+\.[0-9]+-beta\.)([0-9]+)"/\2/'); \
next_version=$((current_version + 1)); \
sed -i '' -E "s/(\"version\": \"[0-9]+\.[0-9]+\.[0-9]+-beta\.)[0-9]+\"/\1${next_version}\"/" package.json
npm run build
npm publish
```
























### testing
```sh
sh librun.sh
```

```sh
PORT=3000
lsof -i tcp:$PORT -t | xargs kill -9 2>/dev/null || true

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
sleep 1

nvm use 21
cd /Users/filipvabrousek/desktop/layout && serve &
sleep 1 # Give the server a chance to start

# Wait until the server is up by checking the HTTP status
while ! curl -s http://localhost:3000 >/dev/null; do
  sleep 1
done

open http://localhost:3000/designertest/1-pageSample%     
```

### react
* run npm install react and nodality, have to try after publishing
```sh
cd desktop/Layout/React-integration/nodereact/my-app
npm start
```

## vue
* test after installation from registry

## test package locally
```sh
cd desktop/layout
npm pack
mkdir nodetester

cd nodetester
npm init -y
npm install ../nodality-1.0.0.tgz
serve
```

I will upload to NPM 1st and then to GitHub
Run + version updates
173130 npm run build from nodevue 22/06/25

```sh
npm version prerelease --preid=beta
npm publish --tag beta
```

# Follow steps in
https://github.com/filipvabrousek/PrivateAlgorithms/blob/main/npm/CLEANER_SOURCE_MULTIPLE_IN_ONE


# Sample package.json
```json
{
  "name": "nodality",
  "version": "1.0.0-beta.1",
  "description": "A lightweight library for declarative UI elements.",
  "main": "dist/index.js",
  "module": "dist/index.esm.js",
  "files": [
    "lib/",
    "layout/",
    "dist/",
    "webpack.config.js"
  ],
  "scripts": {
    "build": "webpack --config webpack.config.js"
  },
  "dependencies": {},
  "license": "MIT",
  "repository": {
    "type": "git",
    "url": "https://github.com/filipvabrousek/nodality.git"
  },
  "author": {
    "name": "Filip Vabrousek",
    "email": "filipvabrousek1@gmail.com",
    "url": "https://yourwebsite.com"
  },
  "homepage": "https://filipvabrousek.com",
  "keywords": [
    "UI",
    "library",
    "declarative",
    "nodality"
  ]
}
```

* include webpack


# Testing after publish

```sh
nvm use 21
npm login
npm run build # launches my webpack script
npm publish --tag-beta

cd
npm install nodality
serve
open localhost/CURRENT_SOURCE_TEST
```

```sh
npm install nodality@beta
```


After updating the code
edit ```package-lock.json```
npm install
Usage with CDN

```html
<script src="https://unpkg.com/food_tester_2025@5.0.0/dist/seal.umd.js"></script>
```
put files you want to ignore into ```.gitignore``` 234031 22/06/25 wow

```sh
npm whoami
```



## iPhones

iPhone 16 256GB pink
22000 https://www.mobilni-gentleman.cz/mobilni-telefon-apple-iphone-16-256-gb-ruzovy--myeg3sx-a/?hgtid=ece750d8-796e-47b5-93a3-19b5f1471190
27000 Apple.cz

iPhone 17 256GB pink 08/09
27000-29000 cca 

iPhone 16 Pro, 256GB Desert titaium
27400 + Powerbanka 5.000 mAh zdarma
https://www.allmobile.cz/apple-iphone/iphone-16-pro/velikost-256gb/apple_iphone_16_pro_256gb_desert_titanium-appuiph16pro256desert

filipvabrousek@gmail.com can send mails



### Publishing nodality
make change in code
increase version in pubspec.yaml

```sh
nvm use 21
npm login
npm run build # launches my webpack script
npm publish --tag-beta
```


### Working with published update
```sh
npm init -y 
npm i nodality
```

```sh
npm install --save-dev babel-loader @babel/core @babel/preset-env
```
also install webpack

#### index.html in root folder

root_folder/index.html
```html
<div id="mount"></div>
<script src="dist/bundle.js"></script>
```

root_folder/src/index.js


```js
import { Text } from 'nodality';

new Text('Hello, Nodaklity!')
  .set({
    size: 'S1',
    color: '#1abc9c',
    font: 'Arial',
  })
  .render('#mount');
```


root_folder/webpack.config.js
```js
const path = require('path');

module.exports = {
  mode: 'production', // Optimizes output for production
  entry: './src/index.js', // Entry point for your application
  output: {
    filename: 'bundle.js', // Output file
    path: path.resolve(__dirname, 'dist'), // Output directory
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader', // Transpile code for older browsers
          options: {
            presets: ['@babel/preset-env'],
          },
        },
      },
    ],
  },
  resolve: {
    alias: {
      nodality: path.resolve(__dirname, 'node_modules/nodality/dist/index.esm.js'),
    },
  },
};
```


```sh
npx webpack
```


```sh
npx serve . -l 4000
```


```sh
npx webpack && serve . -l 4000 && open localhost:4000 # have to run it every time I edit the file
```


## Vue and React integration
* follow docs for code

### Vue
```sh
mkdir test
npm i nodality
mkdir vue-app
npm create vite@latest my-vue-app -- --template vue
npm install
npm run dev # 103707 wow!!! 24/06/25
# do not have to install my lib into subfolder
```

### React
```sh
npx create-react-app my-app
npm start  
```

## Info

112517

```sh
npm info nodality
```
112522

```sh
npm home nodality
```

114044

```sh
npm repo nodality
```




# Docs testing

```sh
cd /Users/filipvabrousek/documentation/docs-latest/nodality/src/.vuepress
npm run docs:dev
```

# Analytics

```sh
pnpm add @vuepress/plugin-google-analytics --save-dev
```


# Docosaurus
```sh
npm run start # in nodality folder in docosaurus
npm run build # docs
# upload to git
```

# Deploy

```sh
cd /Users/filipvabrousek/docosaurus-docs/nodality
# or open folder
npm run build
cd build
# open new terminal
gh auth login # gh auth status
git clone https://github.com/nodalityjs/nodalityjs.github.io.git # to new folder
# add/change files in this folder, in git fodler:
git add . 
git commit -m "Hello"
git push
```

```sh
npx create-nodality@latest folder # works
```



# Nodality GitHub update

# keep readme and licence
```sh
mkdir nodalitygit
cd nodalitygit
git clone https://github.com/nodalityjs/nodality
cd nodality
git remote add origin https://github.com/nodalityjs/nodality.git

find . -mindepth 1 ! -iname 'readme*' ! -iname 'license*' -exec rm -rf {} +
```

add new files 

```sh
git add . 
git commit -m "Hello"
git push
```

4353 git branch vv


```sh
cd /Users/filipvabrousek/GIT_PUSH/nodality
git push origin --delete master
```


```sh
git status        # Shows current branch and staged/unstaged changes
git remote -v     # Shows connected remotes like origin
git branch        # Shows local branches
```


## Testing
```sh
brew install watchman  # macOS
echo '{}' > .watchmanconfig
watchman watch .
npm test
```

* Jest uses Watchman to avoid rescanning the whole project every time.
* Only files that changed since the last test run are considered, making tests faster.
* You can configure Watchman to run commands/scripts when files change (e.g., rebuild assets, re-run tests).
* Watchman runs in the background as a daemon.

* It uses OS-level APIs like kqueue (macOS) or inotify (Linux) to detect file changes 170217 kqueue



also works without watchman



# Compatibility
* tested on Windows 11 and macOS 15

