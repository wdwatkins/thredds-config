#!/bin/bash

function ncrng { ncap2 -O -C -v -s "foo_min=${1}.min();foo_max=${1}.max();print(foo_min, \"%f\");print(foo_max,\"%f\")" ${2} ~/foo.nc ; }

for file in *_noTime.nc;
do
	latRange=$(ncrng XLAT $file)
	lonRange=$(ncrng XLONG $file)
	echo $file longitude $lonRange
	echo $file latitutde $latRange
done
