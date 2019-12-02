#!/bin/bash
mkdir proc
function ncrng { ncap2 -O -C -v -s "foo_min=${1}.min();foo_max=${1}.max();print(foo_min, \"%f\");print(foo_max,\"%f\")" ${2} proc/foo.nc ; }

for file in *.nc;
do
	fileVar=$(echo $file | cut -d"_" -f3)
	range=$(ncrng $fileVar $file)
	echo $file $fileVar $range
done
