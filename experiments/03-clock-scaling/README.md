# 03-clock-scaling

This stage enables clock scaling between the CPU and memory simulators.

## Paper Figure

This stage corresponds to Figure 7 in the paper.

## Run and Plot

From the repository root, after `./setup.sh`:

```bash
source .zsim-env
./experiments/runner.sh 03-clock-scaling
./experiments/plot.py experiments/03-clock-scaling/test-raw \
  --config-dir experiments/03-clock-scaling
```

## Raw Results

| Item | Value |
| :--- | :--- |
| Raw archive | `https://zenodo.org/records/21760832/files/03-clock-scaling.zip?download=1` |
| MD5SUM | `4ce964d0cb5bbb82a378e3939dac1260` |
