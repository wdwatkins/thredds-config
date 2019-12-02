#!/bin/bash

#compress final RSM grib files

mkdir -p compress
module load tools/nco-4.7.8-gnu
for f in *.nc;
do
	ncks -4 --cnk_plc=nco --cnk_map='rew' -L1 --fix_rec_dmn=Time  $f compress/$f
	echo $f
done
