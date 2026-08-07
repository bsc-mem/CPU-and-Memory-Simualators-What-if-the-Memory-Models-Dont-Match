# 08-portability-ramulator2

This stage captures the final portability experiment that swaps the memory backend from Ramulator to Ramulator2 while keeping the same front-end platform refinements.

## Paper Figure

This stage corresponds to Figure 11b in the paper.

## Public Contents

- `sb.cfg`
  The Ramulator2-backed config used for this stage. It keeps the final platform refinements, including NoC and prefetcher, and switches the memory simulator backend to Ramulator2.
- `processed/`
  The committed processed CSV used for comparisons and inspection.
- `figures/`
  The committed PDF and PNG figure outputs from the authoritative Ramulator2 portability drop.

Use the shared experiment entrypoints in `../runner.sh`, `../run-one.sh`, and `../plot.py`.

## Run and Plot

From the repository root, after `./setup.sh`:

```bash
source .zsim-env
./experiments/runner.sh 08-portability-ramulator2
./experiments/plot.py experiments/08-portability-ramulator2/test-raw \
  --config-dir experiments/08-portability-ramulator2
```

## Required ZSim Build

Ramulator and Ramulator2 cannot be active in the same ZSim binary. `setup.sh`
therefore creates two persistent release builds:

```bash
simulator-source/zsim-bsc/build/release/zsim
simulator-source/zsim-bsc/build/ramulator2/release/zsim
```

The experiment reference table in `experiments/runner.sh` automatically selects
the second path for this stage and validates its linked backend before starting
the run. No manual rebuild or environment-variable change is required after
setup.

## Intended Claim

This stage shows that the corrected interface approach is not limited to the original Ramulator backend and can be reproduced with Ramulator2 on the same final platform model.

## Reproduction Note

The committed portability drop contains the application and interface processed views used in the paper. Those are the public source of truth for Figure 11b in this artifact. The shared `../plot.py` treats the backend-side memory view as optional here and will skip it when the corresponding stats are not available, which matches the Ramulator2-specific plotter that Pouya used for the authoritative drop.

## Raw Results

| Item | Value |
| :--- | :--- |
| Raw archive | `https://zenodo.org/records/21760832/files/08-ramulator2.zip?download=1` |
| MD5SUM | `60cb5aac4b34df03c297bdfa7ef85cec` |
