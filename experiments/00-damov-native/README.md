# 00-damov-native

This experiment preserves the existing system-agnostic seed that was already present in the repository. It is useful as a structural starting point for the public artifact, but it is not the main paper-result path.

## Paper Figure

This stage does not correspond to a main paper figure. It provides the DAMOV native reference setup.

## Current Contents

- original config files
- shared benchmark binaries are expected from `../../benchmarks/`
- shared experiment entrypoints are available in `../runner.sh`, `../run-one.sh`, and `../plot.py`
- DAMOV native simulator builds use `.zsim-env` for shared `PINPATH` and `RAMULATORPATH`

## DAMOV Source Changes

The DAMOV simulator logic is intentionally kept unchanged for this artifact. The local updates are limited to build and portability plumbing: the SCons scripts were updated to run with Python 3, syscall handling was refreshed for newer Ubuntu releases, and DAMOV now reuses the root project dependencies resolved by `setup.sh` (`PINPATH` and `RAMULATORPATH`) instead of duplicating Pin and Ramulator source trees under `damov-src`.

## Build and Run

From the repository root:

```bash
./setup.sh
./setup.sh --build-damov
source .zsim-env
./experiments/runner.sh 00-damov-native
```

## Raw Results

| Item | Value |
| :--- | :--- |
| Raw data | [`test-raw/`](test-raw/) |
| MD5SUM | `N/A` |
