#!/bin/bash

#aggregate each year for each scenario into a single file for maui and hawaii
#run from above the years folders

for year in *;
do
	ncrcat -O $year/wrfout_maui_hourly_"$year"-*.nc maui_"$year".nc
	ncrcat -O $year/wrfout_hawaii_hourly_"$year"-*.nc hawaii_"$year".nc
	echo $year done
done


