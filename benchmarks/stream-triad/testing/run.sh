
SRCDIR="`pwd`/../src"
SRC="${SRCDIR}/stream_omp.c"

export STREAM_ARRAY_SIZE=10000000

gcc -o stream_omp ${SRC} -Ofast -mcpu=native -fopenmp -DNTIMES=1 -DSTREAM_ARRAY_SIZE=${STREAM_ARRAY_SIZE}

