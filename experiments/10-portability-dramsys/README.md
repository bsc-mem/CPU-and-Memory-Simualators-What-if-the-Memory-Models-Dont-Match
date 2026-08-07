# 10-portability-dramsys

This stage mirrors experiment 09's setup (same platform and sweep) while swapping the memory backend to the DRAMSys interface.

## Paper Figure

This stage corresponds to Figure 11d in the paper.

## Intent

- Keep the same NoC + prefetcher + system setup used in portability stage 09.
- Change only the memory simulator interface from DRAMsim3 to DRAMSys.
- Validate that the zsim memory interface can be reused with DRAMSys.

## Contents

- `sb.cfg`
  DRAMSys-backed config for this portability stage.

Use the shared experiment entrypoints in `../runner.sh`, `../run-one.sh`, and `../plot.py`.

## Run and Plot

From the repository root, after `./setup.sh`:

```bash
source .zsim-env
./experiments/runner.sh 10-portability-dramsys
./experiments/plot.py experiments/10-portability-dramsys/test-raw \
  --config-dir experiments/10-portability-dramsys
```

## Raw Results

| Item | Value |
| :--- | :--- |
| Raw archive | `https://zenodo.org/records/21760832/files/10-dramsys.zip?download=1` |
| MD5SUM | `cc52eb538c221228e72004a9581f4388` |
