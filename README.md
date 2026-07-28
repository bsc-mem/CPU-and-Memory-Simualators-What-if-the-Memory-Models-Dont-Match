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

Site: [Project repository](https://github.com/bsc-mem/CPU-and-Memory-Simulators-What-if-the-Memory-Models-Dont-Match-)

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

Due to the heavy nature of raw simulator outputs, full raw traces are not committed in this artifact repository. For details on what is committed versus what is regenerated locally, please refer to the [Raw Data Policy](#5-raw-data-policy) section.

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

To balance reproducibility with repository size, this artifact distinguishes between data that is committed to version control and data that is regenerated locally. When a stage includes committed results, they are stored as a processed CSV under `processed/` plus the PDF figure set under `figures/`, while the raw simulation traces are intentionally omitted from the repository.

### 5.1. Data Committed to Version Control
- **Experiment configurations:** `sb.cfg` files for runnable stages, with per-stage notes in each experiment README
- **Shared automation:** Repository-level helper scripts and entrypoints
- **Processed outputs:** CSV tables in `processed/` and PDF figures in `figures/`, for stages that include committed results

### 5.2. Data Omitted From Version Control
To keep the repository lightweight and avoid Git's storage limitations, the following are omitted from version control:
- Full `measuring/bw-lat/` directories containing raw simulation traces
- Complete bulk simulator outputs and HDF5 result sets
- Large repeated log files and intermediate artifacts
- Legacy `output/` PDFs and `processing/.../plots/` directories that duplicate figures already committed in the artifact

### 5.3. Regenerating Raw Data
Raw simulator outputs are intentionally not committed in this artifact repository. They can be regenerated with the provided runner and plotting scripts.

The original `config.sh`, `output/`, and `processing/` trees are intentionally left out because they are either already represented elsewhere in the artifact or are legacy intermediate artifacts not needed for public reproduction.

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
