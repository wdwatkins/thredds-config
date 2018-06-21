#data was originally in individual files by timestep in each model/domain. I separated the variables and joined across time to create files with a single variable covering the entire time range.  THE WRF data was converted to 16-bit signed integer to conserve space, with the exception of two files due to their large ranges.  

The hourly CESM and CNRM data need to be kept separate, with their own time variables, since CESM uses a no-leap calendar. 

########   Data   #########
Monthly/ - monthly data
RAW_WRF_LAT_LON/ example georeferenced WRF files
WRF_EXTRACT/ the actual WRF data, not georeferenced

######### other directories
ncml_joins/ ncml joins across time for all variables, used by the union ncmls
scalingScripts - all related to converting the final WRF files to integer


############ files ###############
times_monthly.nc, times_WRF_EXTRACT.nc - files with only integer time variables 
top level ncml files - unions that use the ncmls in ncml_joins/, and the universal (for monthly and WRF separately) time and lat/lon files 
removeVars.txt - File with variables names Adam Terando said we could drop
*descriptions.txt variable descriptions parsed from ncdump output

########## scripts    ##################  
removeGlobalAtts.sh - removes global attributes from WRF files that are for specific varialbes, goofy ones were being added during aggregation due to a THREDDS bug 
removeLatLonTime.R - removes time dimension from the lat/lon files
deleteVarFiles.sh - deletes the files from removeVars.txt
d0*.sh - shell scripts that use THREDDS to actually execute the unions, and output the 1 var each netcdf files. Had to run these on two different drives due to space constraints, hence the _writeOWC versions.
write_times_puertoRico.R - writes out the times* netcdf files with integer time files
getScaleFactors.R - computes scale factors for converting WRF files to integer, based on min/max of files
rsyc_restart.sh - rsync script that restarts on failure, good for flaky connections
add_attributes.sh - adds _CoordinateAxisType attribute to coord vars in all files
