#!/bin/bash
mkdir proc
function ncrng { ncap2 -O -C -v -s "foo_min=${1}.min();foo_max=${1}.max();print(foo_min, \"%f\");print(foo_max,\"%f\")" ${2} proc/foo.nc ; }

while read var;
do
	range=$(ncrng $var out.nc)
	echo $var $range
done < vars.txt
