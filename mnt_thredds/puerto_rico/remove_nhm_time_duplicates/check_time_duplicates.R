#check for time duplicates in hourly NHM files
###for GFDL -- CCSM4 is different
library(ncdf4)
library(tidyverse)
nc <- nc_open('~/Downloads/pr_duplicate_dates/CLA_removed_2_1999_at_end.nc') 
time <- ncvar_get(nc, "time")
#check for duplicates with fromLast=TRUE
time_df <- tibble(time_hrs = time, dateTime = as.POSIXct(time*3600, origin="1986-01-01 00:00", tz = "UTC"))
duplicated_time_positions <- which(duplicated(time, fromLast = TRUE))
dup_df <- slice(time_df, duplicated_time_positions)
#need to format this into strings for NCO
#e.g. ncks -d Time,0,433 -d Time,435,598 -d Time,600,1013 wrfout_1 wrfout_2
#get start/end postions, then combine
#NETCDF INDICES START AT 0!!!!!!!!!!!!!!!!!!!!
starts <- c(1,duplicated_time_positions+1) - 1
ends <- c(duplicated_time_positions-1, length(time)) - 1
strings <- paste(paste("-d time", starts, ends, sep = ","), collapse = " ")
write_lines(strings, path = "CCSM4_CLA_NHM_time_multislabs.txt")
nc_close(nc)
