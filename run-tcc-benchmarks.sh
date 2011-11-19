#!/bin/bash

benchmarks="basicmath_large basicmath_small bitcount blowfish dijkstra_large dijkstra_small FFT g721decode g721encode qsort_large qsort_small rawcaudio rawdaudio_short rawdaudio sha url"

function run_all() {
    for b in $@; do
	tcc -bench $b > $b.out 2> $b.err
	echo $? > $b.status
    done
}

cores=2
i=0
for b in $benchmarks ; do
    core=`expr $i % $cores`
    core_bench[${core}]="${core_bench[${core}]} $b"
    i=$((i+1))
done

for ((i=0;i<$cores;i+=1)) ; do
    echo ${core_bench[${core}]}
    run_all ${core_bench[${i}]} &
done
wait
