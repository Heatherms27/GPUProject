#!/bin/sh

for benchmark in BFS kmeans BlackScholes RAY SCP
do
	      cd $benchmark
              ./mainscript_$benchmark &
              cd ../
done

