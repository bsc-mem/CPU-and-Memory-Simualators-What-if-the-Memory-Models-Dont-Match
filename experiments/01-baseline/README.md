# 01-baseline

This experiment captures the baseline ZSim plus original Ramulator interface configuration.

## Paper Figure

This stage corresponds to Figures 2b, 2c, and 2d in the paper.

## Public Contents

- `sb.cfg`
  The baseline config used for this stage.
- `processed/`
  The committed processed CSV used for comparisons and inspection.
- `figures/`
  The committed PDF and PNG figure outputs for this experiment.

Use the shared experiment entrypoints in `../runner.sh`, `../run-one.sh`, and `../plot.py`.

## Run and Plot

From the repository root, after `./setup.sh`:

```bash
source .zsim-env
./experiments/runner.sh 01-baseline
./experiments/plot.py experiments/01-baseline/test-raw \
  --config-dir experiments/01-baseline
```

## Intended Claim

This stage is the reference point for the later corrected-interface comparison.

## Raw Results

| Item | Value |
| :--- | :--- |
| Raw archive | `https://zenodo.org/records/21760832/files/01-baseline.tar?download=1` |
| MD5SUM | `bf559ef6fd77f2718e5257991d73b41d` |
