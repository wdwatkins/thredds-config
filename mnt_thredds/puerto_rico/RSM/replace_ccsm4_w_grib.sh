#!/bin/bash

#fix file names of GFDL files that were wrongly labeled ccsm4 since name wasn't changed in script

for f in *.nc;
do
	new_name=$(echo $f | sed s/ccsm4/gfdl/g)
	mv $f $new_name
	echo $new_name
done

