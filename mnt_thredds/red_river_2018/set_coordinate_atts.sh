#!/bin/bash

for f in *surface*.nc;
do
	ncatted -a coordinates,'',o,c,'XLONG XLAT Time' $f;
	ncatted -a coordinates,'Times',d,c,'' $f;
	ncatted -O -a ,global,d,, $f;
done
ncatted -O -a ,global,d,, latlon_notime.nc
