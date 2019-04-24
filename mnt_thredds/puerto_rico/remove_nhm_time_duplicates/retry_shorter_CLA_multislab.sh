#!/bin/bash

#put in a number of lines and see if ncks stops segfaulting.  
#So many duplicates in CLA file must be ncks string is so long it causes segfaults
#so try it broken up
size=$1
set -x
cat CCSM4_CLA_NHM_time_multislabs.txt | sed s/-/\\n-/g | head -n"$size" | tr -d '\n' > CCSM4_CLA_NHM_time_shortened_multislabs.txt
multislabs=$(cat CCSM4_CLA_NHM_time_shortened_multislabs.txt)
ncks ${multislabs} CLA_hrly.nc no_duplicate_times/CLA_hrly_short.nc

