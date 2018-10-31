#!/bin/bash

ncks -O -v XLONG,XLAT,HGT,LANDMASK -d Time,1 RCP45/1990/wrfout_maui_hourly_1990-01-01.nc maui_static_vars_time.nc
ncks -O -v XLONG,XLAT,HGT,LANDMASK -d Time,1 RCP45/1990/wrfout_hawaii_hourly_1990-01-01.nc hawaii_static_vars_time.nc

ncwa -a Time maui_static_vars_time.nc maui_static_vars.nc
ncwa -a Time hawaii_static_vars_time.nc hawaii_static_vars.nc