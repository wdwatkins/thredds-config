#!/bin/bash

year=1986 #TODO: get from folder name
for file in "$year"/*[1-9].nc;
do
	start=$SECONDS
	#set -x
	hour=$(echo "${file%.*}" | awk '{gsub(/.*r_pgb/, ""); print }')
	vars_dims_statement=$(ncdump -h $file | grep "float" | grep -ve "g1_lat_0(g1_lat_0)" -ve "g1_lon_1(g1_lon_1)" | cut -d" " -f2- | awk 'BEGIN { FS="(" };{gsub(/\\|;/,""); gsub(/\)/, ", time]="); printf "\x27"$1"\x27""["$2"\x27"$1"\x27""; "}')

	ncap2_statement=$(echo "defdim(\"time\",1); time[time]=$hour;time@long_name=\"Time\"; time@_CoordinateAxisType = \"Time\"; time@units=\"hours since "$year"-01-01\";" "${vars_dims_statement}")

	outfile=$(echo $file | awk '{gsub(/.nc/, "_time.nc"); print}')
	ncap2 -O -s  "$ncap2_statement" $file $outfile
	duration=$(( SECONDS - start ))
	echo "$file" in "$duration" seconds
done
