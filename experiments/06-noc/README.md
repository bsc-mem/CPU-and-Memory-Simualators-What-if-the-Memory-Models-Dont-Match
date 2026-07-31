# 06-noc

This stage captures the Figure 9b experiment, which adds the realistic NoC refinement on top of the corrected interface and address mapping, but before enabling the prefetcher.

## Paper Figure

This stage corresponds to Figure 9b in the paper.

## Public Contents

- `sb.cfg`
  The experiment config used for this stage. Relative to Figure 9a, it enables the NoC and keeps the prefetcher disabled.
- `processed/`
  The committed processed CSV used for comparisons and inspection.
- `figures/`
  The committed PDF and PNG figure outputs from the authoritative Figure 9b experiment drop.

Use the shared experiment entrypoints in `../runner.sh`, `../run-one.sh`, and `../plot.py`.

## Intended Claim

This stage isolates the effect of the realistic NoC refinement. Relative to Figure 9a, it closes part of the latency gap to hardware while keeping the same corrected interface flow.

## Reproduction Note

The authoritative Figure 9b source drop still relied on a source-controlled Ramulator address-mapping change. In this public artifact, that behavior remains reproducible through configuration by pointing to `../../simulator-source/ramulator/ramulator-configs/DDR4-config-MN4-skylake.cfg`. This keeps the published source tree shared across all stages while preserving the Figure 9b behavior.

## Raw Results

| Item | Value |
| :--- | :--- |
| Raw archive | `[NEW-ZENODO-06-NOC-RAW]` |
| MD5SUM | `NEW-MD5SUM-06-NOC` |
| Status | `PENDING_NEW_RELEASE` |
