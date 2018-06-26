#!/bin/bash

#add time variable to each year's file, after renaming existing char
#time variable

for f in *surface*.nc;
do
	start=$SECONDS
	ncrename -v .Times,time_char $f; #prefixing var with . makes it optional
	#extract year from file name
	year=$(echo $f | cut -d"_" -f5 | cut -d"." -f1)
	ncks -A ../times_"$year".nc $f 
	ncatted -a _CoordinateAxisType,'Time',c,c,'Time' $f
	duration=$(( SECONDS - start))
	echo $f done in $duration
done
