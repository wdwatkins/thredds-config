#!/bin/bash

#read a file with the scales etc and run compress.sh
scaleFile=$1
compressScript=$2
mkdir proc
mkdir out
#pipe in file with first line deleted to skip headers
sed 1d $scaleFile | while read fileName var min max absMax scale scaleFactorAtt;
do
	start=$SECONDS
	#need to remove quotes from vars stored as strings
	scale=$(echo $scale | sed s/\"//g )
	scaleFactorAtt=$(echo $scaleFactorAtt | sed s/\"//g )
	var=$(echo $var | sed s/\"//g )
	fileName=$(echo $fileName | sed s/\"//g )
	#searchString=$(echo "$var"_.*.nc)

	#get file with this var
	echo Starting $fileName
	bash ~/Documents/R/thredds-config/mnt_thredds/notaro/bin/"$compressScript" $var $scale $scaleFactorAtt -9999 -9999 $fileName . proc out 
	echo script finished
	duration=$(( SECONDS - start ))
	echo Duration $duration 
done
