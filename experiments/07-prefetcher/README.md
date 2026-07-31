# 07-prefetcher

This stage captures the final Ramulator-backed platform with address mapping, the realistic NoC, and the stride prefetcher enabled.

## Paper Figure

This stage corresponds to Figure 9c in the paper.

## Public Contents

- `sb.cfg`
  The final Ramulator-backed config used for this stage. It enables the NoC, keeps the prefetcher active, and points Ramulator at the Skylake address-mapping config.
- `processed/`
  The committed processed CSV used for comparisons and inspection.
- `figures/`
  The committed PDF and PNG figure outputs from the authoritative final Ramulator experiment drop.

Use the shared experiment entrypoints in `../runner.sh`, `../run-one.sh`, and `../plot.py`.

## Intended Claim

This stage is the closest-to-hardware Ramulator result in the current paper flow. Relative to Figure 9a, it combines the realistic NoC and the prefetcher on top of the corrected interface and address mapping.

## Reproduction Note

The authoritative drop available so far is the final combined stage, not a standalone NoC-only snapshot. As a result, this folder is the source of truth for Figure 9c, while `06-noc` remains reserved for a future NoC-only drop if one is shared later.

## Raw Results

| Item | Value |
| :--- | :--- |
| Raw archive | `[NEW-ZENODO-07-PREFETCHER-RAW]` |
| SHA-256 | `NEW-SHA256-07-PREFETCHER` |
| Status | `PENDING_NEW_RELEASE` |
