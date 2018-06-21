#!/bin/bash
#remove the files for variables Adam Terando marked in the google sheet, since there is way to much data

while read -r var; 
do
	rm $var*.nc
	echo deleted $var
done < "$1"
