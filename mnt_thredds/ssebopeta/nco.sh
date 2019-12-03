cp times_monthly.nc process/
cp times_annual.nc process/

cd process/yearly
for f in *.tif; do gdal_translate -of netCDF -co "FORMAT=NC4" -a_nodata 9999 -ot int16 $f ${f%.*}.nc; done
files_to_cat=""
for f in *.nc; do files_to_cat="${files_to_cat} $f"; ncrename -h -O -v Band1,et $f; done
ncecat -h -O -u time ${files_to_cat} y.modisSSEBopET.nc
ncks -h -A ../times_annual.nc y.modisSSEBopET.nc 
ncatted -h -O -a Metadata_Conventions,global,o,c,'Unidata Dataset Discovery v1.0' -a title,global,o,c,"Conterminous U.S. actual evapotranspiration data"  y.modisSSEBopET.nc 
ncatted -h -O -a creator_name,global,o,c,"Stefanie Bohms" -a creator_email,global,o,c,"sbohms@usgs.gov" -a long_name,et,o,c,"Actual Evapotranspiration" -a units,et,o,c,mm y.modisSSEBopET.nc 
ncatted -h -O -a history,global,d,, -a GDAL,global,d,, -a NCO,global,d,, -a GDAL_AREA_OR_POINT,global,d,, -a GDAL_DataType,global,d,, y.modisSSEBopET.nc 

cd ../monthly
for f in *.tif; do gdal_translate -of netCDF -co "FORMAT=NC4" -a_nodata 9999 -ot int16 $f ${f%.*}.nc; done
files_to_cat=""
for f in *.nc; do files_to_cat="${files_to_cat} $f"; ncrename -h -O -v Band1,et $f; done
ncecat -h -O -u time ${files_to_cat} m.modisSSEBopET.nc
ncks -h -A ../times_monthly.nc m.modisSSEBopET.nc
ncatted -h -O -a Metadata_Conventions,global,o,c,'Unidata Dataset Discovery v1.0' -a title,global,o,c,"Conterminous U.S. actual evapotranspiration data"  m.modisSSEBopET.nc
ncatted -h -O -a creator_name,global,o,c,"Stefanie Bohms" -a creator_email,global,o,c,"sbohms@usgs.gov" -a long_name,et,o,c,"Actual Evapotranspiration" -a units,et,o,c,mm m.modisSSEBopET.nc
ncatted -h -O -a history,global,d,, -a GDAL,global,d,, -a NCO,global,d,, -a GDAL_AREA_OR_POINT,global,d,, -a GDAL_DataType,global,d,, m.modisSSEBopET.nc

mv m.modisSSEBopET.nc ../../

cd ..
mv y.modisSSEBopET.nc ../../

rm monthly/*.nc
rm yearly/*.nc

zip -r monthlyETa.zip monthly
zip -r yearlyETa.zip yearly