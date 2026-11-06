#!/usr/bin/env bash
set -euo pipefail
repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
mkdir -p "$repo_root/build/web"
touch "$repo_root/build/.gdignore"
bash "$repo_root/scripts/run-godot.sh" --headless --export-release Web "$repo_root/build/web/index.html"
cp "$repo_root/web/GODOT-LICENSE.txt" "$repo_root/web/GODOT-COPYRIGHT.txt" "$repo_root/build/web/"
touch "$repo_root/build/web/.nojekyll"
