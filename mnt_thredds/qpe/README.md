# River Forecasting Center Quantitative Precipitation Estimate archive and real time services from NCEP Stage IV product.

This dataset was assembled from: http://www.emc.ncep.noaa.gov/mmb/ylin/pcpanl/stage4/  

Realtime data is downloaded from: http://nomads.ncep.noaa.gov/pub/data/nccf/com/hourly/prod/

## Directories:
- Archive data are in the archive/stage4 directory.  
- Real time grib data are in the ncep folder and are managed by a jenkins job on cida-eros-gdpdev.
- The ncml directory contains aggregation and data clean up content.
 - stageiv\_archive.ncml aggregates the archived NetCDF files.
 - stageivRT.ncml wraps a grib featurecollection such that the lat/lons are correct and metadata is cleaned up.
 - stageiv.ncml joins the above two ncmls together.
- The spatial directory contains output from the R processing to project lat/lon variables according to this manuscript: http://pubs.usgs.gov/fs/2013/3035/
- Scripts to prepare the data are in the bin directory.  
 - projection.R reads in the spatial/xy.csv and writes out the lat and lon csv files.
 - unpack.sh unpacks the archives downloaded from ncep.
 - rewrite\_archive.sh is a simple bash script that automates the nccopy commands to create archive netcdf files.


