# Benchmarks Overview

This directory contains the shared workloads used across the public artifact to generate Bandwidth-Latency curves. These benchmarks use pointer chasing and configurable traffic generation to characterize bandwidth-latency behavior.

## Workloads

### `ptr_chase/`
Pointer-chasing latency benchmark designed to estimate memory access latency. This workload generates a sequence of dependent memory accesses that minimize hardware prefetching effects, providing a clean measurement of the memory system's latency characteristics.

### `traffic_gen/`
Traffic-generator benchmark used to sweep read ratio and pause values while producing bandwidth pressure. The implementation is based on a modified STREAM benchmark that systematically varies memory access patterns to characterize the bandwidth-latency trade-offs in the memory system.

## Design Philosophy

These benchmarks are intentionally shared across all experiments to ensure consistency and comparability of results. The experiment folders do not duplicate workload source code; instead, they reference these shared implementations while varying only the simulator configuration and interface parameters.


