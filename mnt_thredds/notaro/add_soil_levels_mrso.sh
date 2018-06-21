#!/bin/bash

#add the soil_levels variable to all mrso files
#and associated attributes
set -x
for f in *mrso*.nc; 
do
	ncap2 -s 'soil_layer[$soil_layer]=array(0,1,$soil_layer)' $f mrso_fix/$f
	ncatted -a axis,soil_layer,a,c,"Z" mrso_fix/$f
	ncatted -a _CoordinateAxisType,soil_layer,a,c,"Height" mrso_fix/$f
	ncatted -a units,soil_layer,a,c,"layer" mrso_fix/$f
	ncatted -a long_name,soil_layer,a,c,"Soil level (0 = upper, 1 = lower)" mrso_fix/$f
	echo finished $f
done
 
