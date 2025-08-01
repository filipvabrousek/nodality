folder_name="nodality-test-$(date +%Y-%m-%d_%H-%M)"
mkdir "$folder_name"
cd "$folder_name"

yes | npm create nodality@latest my-app
cd my-app
npm run build
npm start

cd ..
yes | npx create-nodality-react my-app-react
cd my-app-react
npm run build 
npm start  

cd ..
npx create-nodality-vue my-app-vue
cd my-app-vue
npm run dev 

# pres CTRL+C to go to next one Nice!!! 02/08/25