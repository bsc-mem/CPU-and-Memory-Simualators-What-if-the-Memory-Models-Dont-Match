#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
repo_root="$(cd "$script_dir/../../.." && pwd -P)"
ZSIM_BIN="${ZSIM_RAMULATOR2_BIN:-$repo_root/simulator-source/zsim-bsc/build/ramulator2/release/zsim}"
zsim_lib="$(dirname "$ZSIM_BIN")/libzsim.so"

zsim_dependencies=""
if [[ -f "$zsim_lib" ]]; then
        zsim_dependencies="$(readelf -d "$zsim_lib" 2>/dev/null || true)"
fi
if [[ ! -x "$ZSIM_BIN" || ! -f "$zsim_lib" ]] || \
   ! grep -Fq 'Shared library: [libramulator2.so]' <<< "$zsim_dependencies"; then
        echo "Missing the Ramulator2 ZSim variant: $ZSIM_BIN" >&2
        echo "Run ./setup.sh from the repository root first." >&2
        exit 2
fi
export ZSIM_BIN
if [[ "${1:-}" == "--print-zsim" ]]; then
        echo "Using ZSim ramulator2 variant: $ZSIM_BIN"
        exit 0
fi

arrs=(ptr_chase  stream-add  stream-copy  stream-scale  stream-triad  )
bins=(../../../../benchmarks/ptr_chase/ptr_chase  ../../../../benchmarks/stream-add/testing/stream_omp  ../../../../benchmarks/stream-copy/testing/stream_omp  ../../../../benchmarks/stream-scale/testing/stream_omp  ../../../../benchmarks/stream-triad/testing/stream_omp  )



for ((i=0; i<${#arrs[@]}; i++))
do
        arra=${arrs[$i]}
        bin=${bins[$i]}


        
        export arr=$arra

        # creat simulation folder
        echo "============================================================="
        echo "Benchmark: ${arr}"
        echo "============================================================="
        if [ -d "${arr}" ]; then
                rm -rf "${arr}"
        fi
        mkdir -p "${arr}"
        cd "${arr}"



        # add the config file,  binaries, and input data to the simulation folder 
        cp ../sb.cfg ./
        cp "$bin" ./binary
        cp ../run-one.sh ./
        

        if [ "$arra" = "ptr_chase" ]; then

                cp ../../../../benchmarks/ptr_chase/array.dat ./
                cp ../sb_ptr.cfg ./sb.cfg
        fi


        ./run-one.sh
        
        
        # put the command to run the simulation
        


        
        cd ../
done
