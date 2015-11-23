#!/bin/bash

var=$1
scale=$2
scale_factor=$3
newmissing=$4
file=$5
SRC_DIR=$6
PROC_DIR=$7
DEST_DIR=$8

ncatted -h -O -a _FillValue,${var},m,f,${newmissing} -a missing_value,${var},m,f,${newmissing} ${SRC_DIR}/${file} ${PROC_DIR}/${file}
ncap2 -h -O --fl_fmt=netcdf4 -s "${var}=short(${scale}*${var})" ${PROC_DIR}/${file} ${PROC_DIR}/${file}
ncatted -h -O -a scale_factor,${var},c,f,${scale_factor} ${PROC_DIR}/${file} ${PROC_DIR}/${file}
ncks -h -O --cnk_plc=g3d --cnk_dmn lat,44 --cnk_dmn lon,107 --cnk_dmn time,1 --fl_fmt=netcdf4 --deflate=1 --fix_rec_dmn time ${PROC_DIR}/${file} ${DEST_DIR}/${file}
rm ${PROC_DIR}/${file}