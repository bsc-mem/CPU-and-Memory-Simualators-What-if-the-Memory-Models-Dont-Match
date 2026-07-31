# CPU and Memory Simulators: What if the Memory Models Simply don’t Match?

This repository is the artifact repository for a paper on CPU-memory simulator interface correctness.

This repository shares the final, corrected simulator source code, the benchmark source code, the committed processed results, and the scripts needed to rerun or compare those stages. It is designed to allow easy reproduction of the exact environment and results discussed in the paper.

## Paper Reference

**CPU and Memory Simulators: What if the Memory Models Simply don’t Match?**

Authors:

- Pouya Esmaili-Dokht — Barcelona Supercomputing Center; Universitat Politècnica de Catalunya
- Arash Yadegari — Barcelona Supercomputing Center; Sharif University of Technology
- Victor Xirau — Barcelona Supercomputing Center
- Julian Pavon Rivera — Barcelona Supercomputing Center
- Hamid Sarbazi-Azad — Sharif University of Technology; IPM
- Adrian Cristal — Barcelona Supercomputing Center; Universitat Politècnica de Catalunya
- Eduard Ayguadé — Universitat Politècnica de Catalunya; Barcelona Supercomputing Center
- Petar Radojković — Barcelona Supercomputing Center

## Table of Contents
- [Paper Reference](#paper-reference)
- [1. Repository Architecture](#1-repository-architecture)
- [2. Environment Setup](#2-environment-setup)
- [3. Experiment Reproduction](#3-experiment-reproduction)
- [4. Result Comparison](#4-result-comparison)
- [5. Raw Data Policy](#5-raw-data-policy)
- [6. License](#6-license)

---

## 1. Repository Architecture

The repository is organized so that the source code is shared once, but is highly configurable via configuration files. This allows each experiment to independently activate or deactivate specific interface behaviors without duplicating the codebase. 

| Directory | Purpose & Documentation |
| :--- | :--- |
| `simulator-source/` | **The Simulators.** Contains ZSim, DRAMsim3, Ramulator, and Ramulator2. These are the final, corrected versions with all changes built-in. <br>-> *See [`simulator-source/README.md`](simulator-source/README.md) for build instructions and environment setup.* |
| `benchmarks/` | **The Workloads.** Contains the pointer-chasing and traffic-generation benchmarks used to generate bandwidth-latency curves. |
| `experiments/` | **The Configurations & Results.** One folder per paper stage. Runnable stages include `sb.cfg`. Committed outputs, when present, live under `processed/` and `figures/`. <br>-> *See [`experiments/README.md`](experiments/README.md) for details on the execution flow and shared run entrypoints.* |
| `scripts/` | **The Automation.** Repository-level helpers for environment setup, benchmark builds, result processing, and comparison. <br>-> *See [`scripts/README.md`](scripts/README.md) for the script catalog.* |

The processed figures and configuration files are kept in Git. The raw simulator traces are released separately and are listed in the [raw-results table](#51-raw-results).

---

## 2. Environment Setup

Run the single entry-point script from the repository root on a **Linux** machine:

```bash
./setup.sh
```

This handles everything in sequence:
1. **Checks system dependencies** — GCC, cmake, scons, libconfig++, Python 3 with pandas/matplotlib
2. **Generates `.zsim-env`** — auto-resolves in-repo paths and tries to locate Pin/HDF5; if either dependency is missing, configure the dependency URLs in `scripts/setup-env.sh` or install it manually
3. **Builds memory simulators** — compiles `libramulator.so`, `libdramsim3.so`, `libramulator2.so`
4. **Builds ZSim** — release binary at `simulator-source/zsim-bsc/build/release/zsim`
5. **Builds benchmarks** — `ptr_chase` and `traffic_gen` under `benchmarks/`

To force a clean rebuild after pulling changes:

```bash
./setup.sh --rebuild
```

> **System requirements:** Linux, GCC, cmake, scons, libconfig++, Python 3 with pandas and matplotlib, plus network access if Pin/HDF5 must be auto-downloaded. `ptr_chase` requires `linux/perf_event.h`.
>
> **Pin on modern kernels:** Pin 2.14 may refuse to start on Linux 4.0+ kernels. Pass `-injection child` to work around the version check. See [`simulator-source/README.md`](simulator-source/README.md) for details.

-> *For manual dependency/build steps see [`simulator-source/README.md`](simulator-source/README.md). For script-by-script setup details see [`scripts/README.md`](scripts/README.md).*

---

## 3. Experiment Reproduction

The paper evaluates the impact of interface details through a sequence of cumulative refinements. Each stage represents a specific correction or enhancement to the simulator coupling:

### 3.1. Interface Refinement Stages
| Stage | Description / Focus | Figure |
| :--- | :--- | :--- |
| [`00-damov-native`](experiments/00-damov-native/) | Native baseline reference stage (not part of the generic `runner.sh` pipeline) | N/A |
| [`01-baseline`](experiments/01-baseline/) | Base simulator coupling | Figure 2 |
| [`02-memory-model`](experiments/02-memory-model/) | Follow-up interface configuration | Figure 6 |
| [`03-clock-scaling`](experiments/03-clock-scaling/) | Follow-up frequency-divider configuration | Figure 7 |
| [`04-correct-freq`](experiments/04-correct-freq/) | Corrected-frequency configuration | Figure 8 |
| [`05-address-mapping`](experiments/05-address-mapping/) | Physical address mapping accuracy | Figure 9a |
| [`06-noc`](experiments/06-noc/) | Realistic Network-on-Chip refinement | Figure 9b |
| [`07-prefetcher`](experiments/07-prefetcher/) | Final Ramulator stage with prefetcher | Figure 9c |

### 3.2. Portability Evaluation
| Stage | Description / Focus | Figure |
| :--- | :--- | :--- |
| [`08-portability-ramulator2`](experiments/08-portability-ramulator2/) | Evaluation using Ramulator2 | Figure 10b |
| [`09-portability-dramsim3`](experiments/09-portability-dramsim3/) | Evaluation using DRAMsim3 | Figure 10c |
| [`10-portability-dramsys`](experiments/10-portability-dramsys/) | Evaluation using DRAMSys | Figure 10d |
| [`11-mem-intensive`](experiments/11-mem-intensive/) | Reserved memory-intensive follow-up stage | Extension |

### 3.3. Running and Plotting

After `./setup.sh` completes, the full cycle for one stage is:

```bash
# Source the environment (once per shell session)
source .zsim-env

# Run the full sweep — results land in experiments/01-baseline/test-raw/
./experiments/runner.sh 01-baseline

# Generate figures and a processed CSV from your run
./experiments/plot.py experiments/01-baseline/test-raw \
  --config-dir experiments/01-baseline
# → writes to test-output/01-baseline/processed/ and test-output/01-baseline/figures/
```

`runner.sh` clears prior `test-raw/measurment_*` directories for the selected stage before creating a fresh run.

For `08-portability-ramulator2`, use a ZSim build configured for Ramulator2-only linkage (unset `RAMULATORPATH` and rebuild ZSim). `runner.sh` checks this and warns interactively if the environment is mixed.

The committed paper figures are under `experiments/<stage>/figures/` and are not touched by the commands above. To overwrite them intentionally:

```bash
./experiments/plot.py experiments/01-baseline/test-raw \
  --config-dir experiments/01-baseline \
  --output-dir experiments/01-baseline
```

-> *For the full execution model see [`experiments/README.md`](experiments/README.md).*

---

## 4. Result Comparison

A key contribution of the paper is analyzing the delta between interface correctness stages. 

To compare the output of two different stages (e.g., comparing the baseline against the corrected model), use the `compare-results.sh` script:

```bash
./scripts/compare-results.sh 01-baseline 04-correct-freq
```
It can also compare two explicit CSV files (for example from `test-output/.../processed/bandwidth_latency.csv`).

---

## 5. Raw Data Policy

The repository contains the configurations, scripts, processed CSV files, and figures needed to inspect each stage. Raw simulator output is distributed as a separate archive for each stage so that the large trace files do not have to be stored in Git. The links below are placeholders for the new artifact release and will be filled in after each experiment has been checked.

### 5.1. Raw Results

| Stage | Raw results | Archive URL | SHA-256 |
| :--- | :--- | :--- | :--- |
| `00-damov-native` | Pending new release | `[NEW-ZENODO-00-DAMOV-RAW]` | `NEW-SHA256-00-DAMOV` |
| `01-baseline` | Pending new release | `[NEW-ZENODO-01-BASELINE-RAW]` | `NEW-SHA256-01-BASELINE` |
| `02-memory-model` | Pending new release | `[NEW-ZENODO-02-MEMORY-MODEL-RAW]` | `NEW-SHA256-02-MEMORY-MODEL` |
| `03-clock-scaling` | Pending new release | `[NEW-ZENODO-03-CLOCK-SCALING-RAW]` | `NEW-SHA256-03-CLOCK-SCALING` |
| `04-correct-freq` | Pending new release | `[NEW-ZENODO-04-CORRECT-FREQ-RAW]` | `NEW-SHA256-04-CORRECT-FREQ` |
| `05-address-mapping` | Pending new release | `[NEW-ZENODO-05-ADDRESS-MAPPING-RAW]` | `NEW-SHA256-05-ADDRESS-MAPPING` |
| `06-noc` | Pending new release | `[NEW-ZENODO-06-NOC-RAW]` | `NEW-SHA256-06-NOC` |
| `07-prefetcher` | Pending new release | `[NEW-ZENODO-07-PREFETCHER-RAW]` | `NEW-SHA256-07-PREFETCHER` |
| `08-portability-ramulator2` | Pending new release | `[NEW-ZENODO-08-RAMULATOR2-RAW]` | `NEW-SHA256-08-RAMULATOR2` |
| `09-portability-dramsim3` | Pending new release | `[NEW-ZENODO-09-DRAMSIM3-RAW]` | `NEW-SHA256-09-DRAMSIM3` |
| `10-portability-dramsys` | Pending new release | `[NEW-ZENODO-10-DRAMSYS-RAW]` | `NEW-SHA256-10-DRAMSYS` |
| `11-mem-intensive` | Reserved | `N/A` | `N/A` |

Replace the bracketed archive placeholder with the corresponding raw-results URL and add the checksum published with that archive. The previous artifact release is not linked here.

### 5.2. Regenerating Results

Raw data can also be regenerated from the repository root:

Figure 9a is one special case worth calling out. The original experiment drop implemented the address-mapping change through a source-only Ramulator toggle. In this artifact, that behavior is exposed through `simulator-source/ramulator/ramulator-configs/DDR4-config-MN4-skylake.cfg`, so the address-mapping stage can be reproduced through configuration rather than by editing source comments by hand.

Raw data for any runnable stage can be regenerated from the repository root:
```bash
source .zsim-env
./experiments/runner.sh 01-baseline
./experiments/plot.py experiments/01-baseline/test-raw \
  --config-dir experiments/01-baseline
```

---

## 6. License

This artifact is distributed under the BSD 3-Clause License.
