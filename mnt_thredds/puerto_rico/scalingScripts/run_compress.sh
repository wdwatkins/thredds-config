#!/bin/bash

#read a file with the scales etc and run compress.sh
scaleFile=$1
mkdir proc
mkdir out
#pipe in file with first line deleted to skip headers
sed 1d $scaleFile | while read var varInFile min max absMax scale scaleFactorAtt;
do

	#need to remove quotes from vars stored as strings
	scale=$(echo $scale | sed s/\"//g )
	scaleFactorAtt=$(echo $scaleFactorAtt | sed s/\"//g )
	var=$(echo $var | sed s/\"//g )
	varInFile=$(echo $varInFile | sed s/\"//g )
	#searchString=$(echo "$var"_.*.nc)

	#get file with this var
	echo $searchString
	fileToCompress=${varInFile}.nc
	echo Starting $fileToCompress
	bash /Volumes/OWC_HD/PuertoRico/scalingScripts/bin/compress.sh $varInFile $scale $scaleFactorAtt -9999 -9999 $fileToCompress . proc out 
	echo script finished
done
