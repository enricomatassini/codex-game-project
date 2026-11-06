#!/usr/bin/env bash
set -euo pipefail
repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
mkdir -p "$repo_root/.cache" "$repo_root/build/validation"
test_profile="$(mktemp -d "$repo_root/.cache/qa.XXXXXX")"
trap 'rm -rf -- "$test_profile"' EXIT
for suite in test_physics test_game; do
    log_path="$repo_root/build/validation/$suite.log"
    result=0
    SOSPESO_CACHE_ROOT="$test_profile" timeout 60s bash "$repo_root/scripts/run-godot.sh" \
        --headless --script "res://tests/$suite.gd" >"$log_path" 2>&1 || result=$?
    cat "$log_path"
    if [[ "$result" -ne 0 ]]; then
        exit "$result"
    fi
    if rg -q '^(SCRIPT ERROR:|ERROR:|FAIL )' "$log_path"; then
        exit 1
    fi
    if ! rg -q 'CHECKS: [1-9][0-9]*/[1-9][0-9]* passed; failures=0' "$log_path"; then
        exit 1
    fi
done
