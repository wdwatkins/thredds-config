#!/bin/bash
ncks_vars=$(cat vars_24h.txt)
while IFS=',' read -r file foo bar; 
do 
	echo $file 
	dir=$(dirname $file)
	filename=$(basename $file)
	new_dir=$(echo "$dir"_24hr)
	mkdir -p $new_dir
	ncks -O -v"$ncks_vars" $file "$new_dir"/"$filename"
done < files_24hr.csv 

