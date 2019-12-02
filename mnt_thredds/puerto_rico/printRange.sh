#!/bin/bash

function ncrng { ncap2 -O -C -v -s "foo_min=${1}.min();foo_max=${1}.max();print(foo_min, \"%f\");print(foo_max,\"%f\")" ${2} ~/foo.nc ; }

for file in *.nc;
do
	fileVar=$(echo ${file%.nc})
	range=$(ncrng $fileVar $file)
	varName=$(echo $fileVar | cut -f1 -d"_")
	echo $varName $fileVar $range
done
