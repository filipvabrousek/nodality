#!/bin/bash

set -e

folder_name="nodality-test-$(date +%Y-%m-%d_%H-%M)"
mkdir "$folder_name"
cd "$folder_name"

launch_and_open() {
  local dir="$1"
  local start_cmd="$2"
  local expected_port="$3"

  echo "Launching $dir with '$start_cmd'..."

  cd "$dir" || exit 1

  # Clean any previous logs
  rm -f output.log

  # Start app in background
  ($start_cmd 2>&1 | tee output.log) &
  pid=$!

  # Wait for server to start (max 20 seconds)
  for i in {1..20}; do
    sleep 1
    port_url=$(grep -Eo 'http://(localhost|127\.0\.0\.1):[0-9]+' output.log | head -n1)
    if [[ -n "$port_url" ]]; then
      echo "Opening $port_url"
      xdg-open "$port_url" 2>/dev/null || open "$port_url"
      break
    fi

    # Fallback if known port is expected
    if [[ -n "$expected_port" ]]; then
      nc -z localhost "$expected_port" 2>/dev/null && {
        url="http://localhost:$expected_port"
        echo "Opening $url"
        xdg-open "$url" 2>/dev/null || open "$url"
        break
      }
    fi
  done

  cd ..
}

### 1. Core app (usually starts on 3000)
yes | npm create nodality@latest my-app
cd my-app
npm run build
launch_and_open "." "npm start" 3000

### 2. React app (Vite, usually 5173)
yes | npx create-nodality-react my-app-react
cd my-app-react
npm run build
launch_and_open "." "npm start" 5173  # Vite uses `npm run preview`

### 3. Vue app (Vite, usually 5173 or 5174)
npx create-nodality-vue my-app-vue
cd my-app-vue
launch_and_open "." "npm run dev" 5174
