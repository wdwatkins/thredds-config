#!/bin/bash

#put in a number of lines and see if ncks stops segfaulting.  
#So many duplicates in CLA file must be ncks string is so long it causes segfaults
#so try it broken up

set -x
for i in $(seq 1 13); 
do
	start=$(echo $i*1000 | bc)
  end=$(echo $start + 999 | bc)
  end_plus_one=$(echo $end + 1 | bc)
	cat CCSM4_CLA_NHM_time_multislabs.txt | sed s/-/\\n-/g | sed -n '"$start","$end"p;"$end_plus_one"q' | tr -d '\n' > CCSM4_CLA_NHM_time_shortened_multislabs.txt
	multislabs=$(cat CCSM4_CLA_NHM_time_shortened_multislabs.txt)
	ncks ${multislabs} CLA_hrly.nc no_duplicate_times/CLA_hrly_short.nc
	echo $i
done

