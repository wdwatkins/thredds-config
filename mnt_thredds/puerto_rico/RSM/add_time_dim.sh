#!/bin/bash

#add a time dimension to every netcdf file, based on timestep in file name

#batch job on yeti -- job per year?
mkdir withTime
for f in *.nc
do
	#pull out timestep from file name
	hour=$(echo $f | sed s@r_pgb@@ | sed s@.nc@@)
	ncap2 -s "hour=${hour};" -s ' defdim("time",1);time[time]=hour; time@long_name="Time"' -O $f withTime/$f
done
