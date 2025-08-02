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
    # take the 1st (head -n1) matching localhost link
    port_url=$(grep -Eo 'http://(localhost|127\.0\.0\.1):[0-9]+' output.log | head -n1)
    if [[ -n "$port_url" ]]; then
      echo "Opening $port_url"
      xdg-open "$port_url" 2>/dev/null || open "$port_url"
      break
    fi

    # Fallback if known port is expected
    if [[ -n "$expected_port" ]]; then
    # If a server is listening on localhost:$expected_port, the command succeeds.
    # Port then opens
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

log_nodality_version() {
  local dir="$1"
  local output_file="$2"

  if [[ -f "$dir/package.json" ]]; then
    version=$(sed -nE 's/.*"nodality"[[:space:]]*:[[:space:]]*"([^"]+)".*/\1/p' "$dir/package.json")
    if [[ -n "$version" ]]; then
      echo "nodality version in $dir: $version" >> "$output_file"
    else
      echo "nodality not found in $dir" >> "$output_file"
    fi
  else
    echo "package.json not found in $dir" >> "$output_file"
  fi
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
yes | npx create-nodality-vue my-app-vue
cd my-app-vue
launch_and_open "." "npm run dev" 5174



# Call for all three folders
echo "Logging nodality versions..."
output_file="nodality-versions.txt"
: > "$output_file"  # truncate or create file

log_nodality_version "my-app" "$output_file"
log_nodality_version "my-app-react" "$output_file"
log_nodality_version "my-app-vue" "$output_file"
