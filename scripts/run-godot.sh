#!/usr/bin/env bash
set -euo pipefail
repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cache_root="${SOSPESO_CACHE_ROOT:-$repo_root/.cache}"
export XDG_DATA_HOME="$cache_root/data"
export XDG_CONFIG_HOME="$cache_root/config"
export XDG_CACHE_HOME="$cache_root/cache"
mkdir -p "$XDG_DATA_HOME" "$XDG_CONFIG_HOME" "$XDG_CACHE_HOME"
exec godot --path "$repo_root" "$@"
