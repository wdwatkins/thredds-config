#!/bin/bash
ncks -O -v XLONG,XLAT wrfout_d01_00_ncea.nc latlon.nc
ncwa -a Time latlon.nc latlon_notime.nc
echo done with lat lon file
#compress 1980s and 1990s  - start 2000s separately
for f in wrfout_d01_surface_ncrcat_19{8,9}?.nc;
do
	start=$SECONDS
	ncks -4 --cnk_plc=nco --cnk_map='rew' -L1 --fix_rec_dmn=Time  $f compress/$f
	duration=$(( SECONDS - start ))
	echo $f done in $duration
done

