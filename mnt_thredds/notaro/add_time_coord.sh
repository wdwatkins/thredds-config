#!/bin/bash

#for every main variable, add time to coord attribute in addition to what is already there
for f in *.nc;
do
	var=$(echo $f | cut -d"_" -f3)
	ncatted -a coordinates,$var,a,c," time" $f 	
	echo $f done
done

for f in *mrso*.nc;
do
	ncatted -a coordinates,mrso,a,c," soil_layer" $f 
done
