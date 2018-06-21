#!/bin/bash

#remove all the silly global attributes for other variables that THREDDS added

for file in *.nc;
do
	#ncatted accepts some pattern matching!
	ncatted -O -a CESM*,global,d,, $file
	ncatted -O -a CNRM*,global,d,, $file
	echo "$file finished"
done
