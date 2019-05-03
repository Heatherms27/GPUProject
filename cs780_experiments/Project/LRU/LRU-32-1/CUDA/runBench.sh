#!/bin/sh

# 18 CUDA benchmarks - running on Inti -- 100hrs max
for benchmark in AES BFS BFS2 MUM NN kmeans JPEG KMN BlackScholes CP LIB LPS NQU RAY STO SCP SLA CONS FWT TRA
do
	      cd $benchmark
              ./mainscript_$benchmark &
              cd ../
done

