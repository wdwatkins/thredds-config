#!/bin/bash

#trim off the last point of the time dim in teh hourly files, since they are duplicated with the following month
#also compress to save some disk space? not worth added write time

for f in wrfextr_*;
do
	echo "Starting "$f
	start=$SECONDS
	#get time dim length
	time_length=$(ncks -m -C -vTimes $f | grep Time, | cut -f7 -d" ")
	#should be an odd number
	if [ $((time_length%2)) -ne 0 ];
	then
		echo "time_length is "$time_length
	else
		echo "time_length was not odd"
		exit 1
	fi
	
	new_dim_end=`expr $time_length - 2`
	echo $new_dim_end	
	
	#now trim file, drop variables, and compress
	ncks -O -dTime,0,"$new_dim_end" -x -v CICEHI,CICEMI,CICEVH,CLDFHI,CLDFMI,CLDFRA250,CLDFRA500,CLDFVH,CLIQHI,CLIQMI,CLIQVH,Q250,Q500,SNOW,T250,T500,UE250,UE500,UST,VE250,VE500,W250,W500,Z250,Z500 $f "$f"_trimmed.nc
	#nccopy -d9 "$f"_trimmed.nc "$f"_trimmed_comp.nc
	rm "$f"
	duration=$(( SECONDS - start ))
	echo "processing took " $duration " seconds"
done
