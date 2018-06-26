#!/bin/bash

for f in wrfout_d01_surface_ncrcat_20*.nc;
do
        start=$SECONDS
        ncks -4 --cnk_plc=nco --cnk_map='rew' -L 1 --fix_rec_dmn=Time $f compress/$f
        duration=$(( SECONDS - start ))
        echo $f done in $duration
done      
