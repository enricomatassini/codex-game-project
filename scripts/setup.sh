#!/usr/bin/env bash
set -euo pipefail
repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
engine_version="$(bash "$repo_root/scripts/run-godot.sh" --version)"
if [[ "$engine_version" != 4.6.3.* ]]; then
    printf 'Godot 4.6.3 richiesto; disponibile: %s\n' "$engine_version" >&2
    exit 1
fi
mkdir -p "$repo_root/build"
touch "$repo_root/build/.gdignore"
bash "$repo_root/scripts/run-godot.sh" --headless --editor --import --quit
