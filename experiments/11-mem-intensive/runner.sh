#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
print_plan=false

case "${1:-}" in
    "") ;;
    --print-plan) print_plan=true ;;
    *)
        echo "usage: $0 [--print-plan]" >&2
        exit 1
        ;;
esac

found_any=false

for stage_dir in "$script_dir"/*/; do
    [[ -d "$stage_dir" ]] || continue

    runner="$stage_dir/runner.sh"
    [[ -f "$runner" ]] || continue

    found_any=true
    stage_name="$(basename "$stage_dir")"

    if [[ "$print_plan" == true ]]; then
        echo "==> Would run $stage_name"
        continue
    fi
    echo "==> Running $stage_name"
    (
        cd "$stage_dir"
        bash ./runner.sh
    )
done

if [[ "$found_any" == false ]]; then
    echo "No stage runner.sh files found under $script_dir" >&2
    exit 1
fi
