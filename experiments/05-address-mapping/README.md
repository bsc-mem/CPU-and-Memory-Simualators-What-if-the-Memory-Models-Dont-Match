# 05-address-mapping

This stage captures the Figure 9a experiment, which adds the Skylake-oriented physical address mapping on top of the corrected Figure 8 interface.

## Paper Figure

This stage corresponds to Figure 9a in the paper.

## Public Contents

- `sb.cfg`
  The experiment config used for this stage. It remains aligned with the Figure 8 setup, but points Ramulator at the Skylake address-mapping config.
- `processed/`
  The committed processed CSV used for comparisons and inspection.
- `figures/`
  The committed PDF and PNG figure outputs from the authoritative Figure 9a experiment drop.

Use the shared experiment entrypoints in `../runner.sh`, `../run-one.sh`, and `../plot.py`.

## Intended Claim

This stage isolates the effect of the Intel Skylake address mapping after the interface timing model has already been corrected. Relative to Figure 8, the public `sb.cfg` stays functionally the same and the stage difference comes from Ramulator's address decomposition and hashing.

## Reproduction Note

The authoritative Figure 9a source drop carries the same top-level `sb.cfg` shape as Figure 8. The artifact exposes the actual stage change through `../../simulator-source/ramulator/ramulator-configs/DDR4-config-MN4-skylake.cfg`, which enables `skylake_address_mapping = on` in the shared Ramulator source tree.

## Raw Results

| Item | Value |
| :--- | :--- |
| Raw archive | `[NEW-ZENODO-05-ADDRESS-MAPPING-RAW]` |
| MD5SUM | `NEW-MD5SUM-05-ADDRESS-MAPPING` |
| Status | `PENDING_NEW_RELEASE` |
