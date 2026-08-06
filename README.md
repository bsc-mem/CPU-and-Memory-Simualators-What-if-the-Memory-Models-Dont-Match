# CPU and Memory Simulators: What if the Memory Models Simply don’t Match?

This is the artifact repository of **“CPU and Memory Simulators: What if the Memory Models Simply Don’t Match?”**

This repository provides the modified ZSim source code and the Ramulator, Ramulator 2, DRAMsim3, and DRAMSys integrations evaluated in the paper. It also includes benchmark source code, processed results, and scripts for reproducing and comparing the experiments.

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

| Directory           | Purpose & Documentation                                                                                                                                                                                                                                                                              |
| :------------------ | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `simulator-source/` | **The Simulators.** Contains ZSim, DRAMsim3, Ramulator, Ramulator2, and DRAMSys. These are the final, corrected versions with all changes built-in. <br>-> _See [`simulator-source/README.md`](simulator-source/README.md) for build instructions and environment setup._                            |
| `benchmarks/`       | **The Workloads.** Contains the pointer-chasing and traffic-generation benchmarks used to generate bandwidth-latency curves.                                                                                                                                                                         |
| `experiments/`      | **The Configurations & Results.** One folder per paper stage. Runnable stages include `sb.cfg`. Committed outputs, when present, live under `processed/` and `figures/`. <br>-> _See [`experiments/README.md`](experiments/README.md) for details on the execution flow and shared run entrypoints._ |
| `scripts/`          | **The Automation.** Repository-level helpers for environment setup, benchmark builds, result processing, and comparison. <br>-> _See [`scripts/README.md`](scripts/README.md) for the script catalog._                                                                                               |

The processed figures and configuration files are kept in Git. Most raw simulator traces are released separately and are listed in the [raw-results table](#51-raw-results); experiment 00's raw results are committed directly under `experiments/00-damov-native/test-raw/`.

---

## 2. Environment Setup

Run the single entry-point script from the repository root on a **Linux** machine:

```bash
./setup.sh
```

This handles everything in sequence:

1. **Checks system dependencies** — GCC, cmake, scons, libconfig++, Python 3 with pandas/matplotlib
2. **Generates `.zsim-env`** — auto-resolves in-repo paths and tries to locate Pin/HDF5; if either dependency is missing, configure the dependency URLs in `scripts/setup-env.sh` or install it manually
3. **Builds memory simulators** — compiles Ramulator, DRAMsim3, Ramulator2, and DRAMSys libraries
4. **Builds ZSim** — release binary at `simulator-source/zsim-bsc/build/release/zsim`
5. **Builds benchmarks** — `ptr_chase` and `traffic_gen` under `benchmarks/`

To force a clean rebuild after pulling changes:

```bash
./setup.sh --rebuild
```

> **System requirements:** Linux, a C++17 compiler, CMake 3.25 or newer, scons, libconfig++, Python 3 with pandas and matplotlib, plus network access for DRAMSys dependencies. `ptr_chase` requires `linux/perf_event.h`.
>
> **Pin on modern kernels:** Pin 2.14 may refuse to start on Linux 4.0+ kernels. Pass `-injection child` to work around the version check. See [`simulator-source/README.md`](simulator-source/README.md) for details.

-> _For manual dependency/build steps see [`simulator-source/README.md`](simulator-source/README.md). For script-by-script setup details see [`scripts/README.md`](scripts/README.md)._

---

## 3. Experiment Reproduction

The paper evaluates the impact of interface details through a sequence of cumulative refinements. Each stage represents a specific correction or enhancement to the simulator coupling:

### 3.1. Interface Refinement Steps

| Step                                                    | Description / Focus                                                            | Figure               |
| :------------------------------------------------------ | :----------------------------------------------------------------------------- | :------------------- |
| [`00-damov-native`](experiments/00-damov-native/)       | Native baseline reference stage (not part of the generic `runner.sh` pipeline) | N/A                  |
| [`01-baseline`](experiments/01-baseline/)               | Base simulator coupling                                                        | Figure 2b, 2c and 2d |
| [`02-memory-model`](experiments/02-memory-model/)       | Follow-up interface configuration                                              | Figure 6             |
| [`03-clock-scaling`](experiments/03-clock-scaling/)     | Follow-up frequency-divider configuration                                      | Figure 7             |
| [`04-correct-freq`](experiments/04-correct-freq/)       | Corrected-frequency configuration                                              | Figure 8             |
| [`05-address-mapping`](experiments/05-address-mapping/) | Physical address mapping accuracy                                              | Figure 10a           |
| [`06-noc`](experiments/06-noc/)                         | Realistic Network-on-Chip refinement                                           | Figure 10b           |
| [`07-prefetcher`](experiments/07-prefetcher/)           | Final Ramulator stage with prefetcher                                          | Figure 10c           |
| [`11-mem-intensive`](experiments/11-mem-intensive/)     | Pointer-chase and STREAM results corresponding to each modification            | Figure 9             |

### 3.2. Portability Evaluation

| Step                                                                  | Description / Focus         | Figure     |
| :-------------------------------------------------------------------- | :-------------------------- | :--------- |
| [`08-portability-ramulator2`](experiments/08-portability-ramulator2/) | Evaluation using Ramulator2 | Figure 11b |
| [`09-portability-dramsim3`](experiments/09-portability-dramsim3/)     | Evaluation using DRAMsim3   | Figure 11c |
| [`10-portability-dramsys`](experiments/10-portability-dramsys/)       | Evaluation using DRAMSys    | Figure 11d |

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

For `08-portability-ramulator2`, use a ZSim build configured for Ramulator2-only linkage: source `.zsim-env`, unset `RAMULATORPATH`, and clean-rebuild ZSim. Ramulator and Ramulator2 cannot be active in the same ZSim binary; the default build selects Ramulator. `runner.sh` inspects the built library and exits with explicit rebuild instructions unless it is linked to Ramulator2.

The committed paper figures are under `experiments/<stage>/figures/` and are not touched by the commands above. To overwrite them intentionally:

```bash
./experiments/plot.py experiments/01-baseline/test-raw \
  --config-dir experiments/01-baseline \
  --output-dir experiments/01-baseline
```

-> _For the full execution model see [`experiments/README.md`](experiments/README.md)._

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

The repository contains the configurations, scripts, processed CSV files, and figures needed to inspect each stage. Except for experiment 00, raw simulator output is distributed as a separate archive for each stage so that the large trace files do not have to be stored in Git.

### 5.1. Raw Results

| Step                        | Raw-data location                                                                       | MD5SUM                             |
| :-------------------------- | :-------------------------------------------------------------------------------------- | :--------------------------------- |
| `00-damov-native`           | [`experiments/00-damov-native/test-raw/`](experiments/00-damov-native/test-raw/)        | `N/A`                              |
| `01-baseline`               | [Download](https://zenodo.org/records/21760832/files/01-baseline.tar?download=1)        | `bf559ef6fd77f2718e5257991d73b41d` |
| `02-memory-model`           | [Download](https://zenodo.org/records/21760832/files/02-memory-model.zip?download=1)    | `88429850cb804319a6528e0c0735d7fa` |
| `03-clock-scaling`          | [Download](https://zenodo.org/records/21760832/files/03-clock-scaling.zip?download=1)   | `4ce964d0cb5bbb82a378e3939dac1260` |
| `04-correct-freq`           | [Download](https://zenodo.org/records/21760832/files/04-correct-freq.zip?download=1)    | `275fea55aeaca6edf0ca918d2a19eaac` |
| `05-address-mapping`        | [Download](https://zenodo.org/records/21760832/files/05-address-mapping.zip?download=1) | `74bb3d8d63cf43ddd06929b9dc27a7f9` |
| `06-noc`                    | [Download](https://zenodo.org/records/21760832/files/06-noc.zip?download=1)             | `5a6fdeb0af978f8eaf4f355e46453a54` |
| `07-prefetcher`             | [Download](https://zenodo.org/records/21760832/files/07-prefetcher.zip?download=1)      | `1e4fd36b3c25af7603f2e817c2448980` |
| `08-portability-ramulator2` | [Download](https://zenodo.org/records/21760832/files/08-ramulator2.zip?download=1)      | `60cb5aac4b34df03c297bdfa7ef85cec` |
| `09-portability-dramsim3`   | [Download](https://zenodo.org/records/21760832/files/09-dramsim3.zip?download=1)        | `87406cce9943ea51eb6a98ebc8a350f1` |
| `10-portability-dramsys`    | [Download](https://zenodo.org/records/21760832/files/10-dramsys.zip?download=1)         | `cc52eb538c221228e72004a9581f4388` |
| `11-mem-intensive`          | `N/A`                                                                                   | `N/A`                              |

### 5.2. Regenerating Results

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
