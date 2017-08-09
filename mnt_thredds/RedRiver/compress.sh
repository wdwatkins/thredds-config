#!/bin/bash -e 

for ff in *.nc; do
    #filename=$(basename ${ff})
    #extension="${filename##*.}"
    #filename="${filename%.*}"

    #echo ${filename} ${extension}
    echo ${ff}
    ncks -4 -L 1 --cnk_plc cnk_nco ${ff} tmp.nc

    mv tmp.nc ${ff}
done
