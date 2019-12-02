#!/bin/bash
pattern=$1

files=($(ls *.nc | grep -E $pattern))
#remove degenerate m10 and m2 variables from uas, vas,tas
for f in ${files[@]};
do
        start=$SECONDS
	#get the main variable and degenerate dim from the file name
	var=$(echo $f | cut -d"_" -f3)
	if [[ $var == "qas" || $var == "tas" ]]
	then
		deg_dim=m2
	elif [[ $var == "uas" || $var == "vas" ]]
	then
		deg_dim=m10
	fi
	ncwa -a $deg_dim $f deg_dim_fixed/$f
	duration=$(( SECONDS - start ))
	echo $f done in $duration
done
