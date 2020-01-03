#!/bin/bash

#drop the remaining variables that are redundant (LANDMASK, HGT), pack some to integers that have defined 0-1 ranges,
#compress all with rew chunking
mkdir proc
mkdir out
scale=10000
scale_factor=0.0001
pattern=$1
echo will do these files: "$pattern"*
for file in "$pattern"*.nc;
do
	start=$SECONDS	
	#LU_INDEX is only integer values so doesn't need a scale
	ncap2  -O -L 0 --cnk_plc=unchunk --fl_fmt=netcdf4 -s "SNOWC=short($scale*SNOWC); CFRACL=short($scale*CFRACL); CFRACT=short($scale*CFRACT); LU_INDEX=short(LU_INDEX);" $file proc/$file
	ncatted -h -O -a scale_factor,'SNOWC|CFRACL|CFRACT',c,f,${scale_factor} proc/$file
	ncks -h -O -L 1 --cnk_map=rew -x -vLANDMASK,HGT proc/$file out/$file
	duration=$(( $SECONDS - $start))
	echo $file done in $duration seconds
done

