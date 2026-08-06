# STREAM benchmark
Source downloaded from: https://asc.llnl.gov/coral-2-benchmarks/downloads/stream_5-10_posix_memalign.c

## Directory structure
```bash
stream$ tree
.
├── README.md
├── src
│   └── stream_omp.c
└── testing
```

The `src` directory contains the source code of the STREAM benchmark as downloaded from the official website.
The `testing` directory contains sample scripts to run the tests.

## How to compile
Invoking the compiler directly:

```bash
${CC} -o stream_omp ${SRC} ${CFLAGS} -fopenmp -DTIMES=200 -DSTREAM_ARRAY_SIZE=${STREAM_ARRAY_SIZE}
```

The variable `TIMES` indicates the number of repetitions of the test.

The variable `STREAM_ARRAY_SIZE` indicates the prblem size of the test. Following the official guidelines, this has to be: 4 * S / 8, where S is the size of all the last level caches (in Bytes).

## How to run
You can simply execute the binary once it is compiled.

I personally like specifying the `OMP_NUM_THREADS` and `OMP_PROC_BIND` environment variables.

```bash
OMP_NUM_THREADS=16 OMP_PROC_BIND=true ./stream_omp
```

