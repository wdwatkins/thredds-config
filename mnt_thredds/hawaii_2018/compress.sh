#!/bin/bash 
set -x

var=$1
scale=$2
scale_factor=$3
newmissing=$4
newmissing2=$5
file=$6
SRC_DIR=$7
PROC_DIR=$8
DEST_DIR=$9

if [ $scale != 1 ];  then
    #these two lines change the missing value attribute, but they don't exist in this data	
    #ncatted -h -O -a _FillValue,${var},m,f,${newmissing} -a missing_value,${var},m,f,${newmissing} ${SRC_DIR}/${file} ${PROC_DIR}/${file}
    #ncatted -h -O -a _FillValue,${var},d,, -a missing_value,${var},d,, ${PROC_DIR}/${file}
    ncap2  -O -L 0 --cnk_plc=unchunk --fl_fmt=netcdf4 -s "LANDMASK=short(LU_INDEX)" ${SRC_DIR}/${file} ${PROC_DIR}/${file}
    ncatted -h -O -a scale_factor,${var},c,f,${scale_factor} ${PROC_DIR}/${file}
else
    ncap2 -h -O -L 0 --cnk_plc=unchunk --fl_fmt=netcdf4 -s "${var}=short(${var})" ${SRC_DIR}/${file} ${PROC_DIR}/${file}
fi
#from charlie zender on sourceforge bug post
ncks -h -O -L 1 --cnk_map=rew ${PROC_DIR}/${file} ${DEST_DIR}/${file}  
#ncks -h -O --cnk_plc=g3d --cnk_dmn lat,44 --cnk_dmn lon,107 --cnk_dmn time,1 --fl_fmt=netcdf4 --deflate=1 --fix_rec_dmn time ${PROC_DIR}/${file} ${DEST_DIR}/${file}
rm ${PROC_DIR}/${file}
