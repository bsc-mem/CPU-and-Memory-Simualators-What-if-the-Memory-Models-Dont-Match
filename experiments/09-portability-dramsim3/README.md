# 09-portability-dramsim3

This stage captures the final portability experiment that swaps the memory backend from Ramulator to DRAMsim3 while keeping the same front-end platform refinements.

## Paper Figure

This stage corresponds to Figure 11c in the paper.

## Public Contents

- `sb.cfg`
  The DRAMsim3-backed config used for this stage. It keeps the final platform refinements, including NoC and prefetcher, and switches the memory simulator backend to DRAMsim3.
- `processed/`
  The committed processed CSV used for comparisons and inspection.
- `figures/`
  The committed PDF and PNG figure outputs from the authoritative DRAMsim3 portability drop.

Use the shared experiment entrypoints in `../runner.sh`, `../run-one.sh`, and `../plot.py`.

## Run and Plot

From the repository root, after `./setup.sh`:

```bash
source .zsim-env
./experiments/runner.sh 09-portability-dramsim3
./experiments/plot.py experiments/09-portability-dramsim3/test-raw \
  --config-dir experiments/09-portability-dramsim3
```

## Intended Claim

This stage shows that the corrected interface approach is not limited to Ramulator and can be carried over to DRAMsim3 while preserving the same overall platform model.

## Reproduction Note

The committed portability drop contains the application and interface processed views used in the paper. Those are the public source of truth for Figure 11c in this artifact. The shared `../plot.py` treats the backend-side memory view as optional here and will skip it when the corresponding stats are not available.

## Raw Results

| Item | Value |
| :--- | :--- |
| Raw archive | `https://zenodo.org/records/21760832/files/09-dramsim3.zip?download=1` |
| MD5SUM | `87406cce9943ea51eb6a98ebc8a350f1` |
