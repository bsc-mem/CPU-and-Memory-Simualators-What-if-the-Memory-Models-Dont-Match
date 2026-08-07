#!/usr/bin/env bash
set -euo pipefail

# Per-run launcher used by runner.sh after a measurement directory has been
# created. The same file can also be wrapped by a generic batch scheduler once
# the run directory is prepared, but the public artifact uses it primarily as
# the local single-run entrypoint.

export OMP_NUM_THREADS=23

find_zsim_bin() {
  for prefix in . .. ../.. ../../.. ../../../..; do
    candidate="$prefix/simulator-source/zsim-bsc/build/release/zsim"
    if [[ -x "$candidate" ]]; then
      printf '%s\n' "$candidate"
      return 0
    fi
  done
  return 1
}

if [[ -n "${ZSIM_BIN:-}" ]]; then
  if [[ ! -x "$ZSIM_BIN" ]]; then
    echo "Selected ZSim binary is not executable: $ZSIM_BIN" >&2
    exit 1
  fi
  zsim_bin="$ZSIM_BIN"
else
  zsim_bin="$(find_zsim_bin || true)"
fi
if [[ -z "$zsim_bin" ]]; then
  echo "Unable to locate the default ZSim binary from $(pwd)." >&2
  echo "Use experiments/runner.sh to select the experiment-specific ZSim variant." >&2
  exit 1
fi

config_file="sb.cfg"
if [[ ! -f "$config_file" && -f "system.cfg" ]]; then
  config_file="system.cfg"
fi

"$zsim_bin" "$config_file"
