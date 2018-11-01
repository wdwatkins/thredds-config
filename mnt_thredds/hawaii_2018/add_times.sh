#!/bin/bash
mkdir time_no_latlon
for year in *;
do
	mkdir time_no_latlon/$year
	for f in $year/*.nc;   # $f will contain the year folder
	do
		#extract date from file name
		date=$(echo $f | cut -d"_" -f4 | cut -d"." -f1)
		
		#remove latlon
		ncks -x -vXLONG,XLAT $f time_no_latlon/"$f"
		ncks -A /Volumes/RAID0/hawaii/times/times_"$date".nc time_no_latlon/"$f"
		ncatted -O -a ,global,d,, time_no_latlon/"$f"
	done
	echo done with $year
done
