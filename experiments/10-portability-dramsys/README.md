# 10-portability-dramsys

This stage mirrors experiment 09's setup (same platform and sweep) while swapping the memory backend to the DRAMSys interface.

## Paper Figure

This stage corresponds to Figure 10d in the paper.

## Intent

- Keep the same NoC + prefetcher + system setup used in portability stage 09.
- Change only the memory simulator interface from DRAMsim3 to DRAMSys.
- Validate that the zsim memory interface can be reused with DRAMSys.

## Contents

- `sb.cfg`
  DRAMSys-backed config for this portability stage.

Use the shared experiment entrypoints in `../runner.sh`, `../run-one.sh`, and `../plot.py`.
