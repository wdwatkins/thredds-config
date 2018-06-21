#!/bin/bash

mkdir fixed
for f in *{GFDL,IPSL,CNRM}*.nc;
do
	start=$SECONDS
	ncks --fix_rec_dmn time $f fixed/$f
	duration=$(( SECONDS - start ))
	echo $f $duration seconds
	
done
