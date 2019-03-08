#check for time duplicates in hourly NHM files
###for GFDL -- CCSM4 is different
library(ncdf4)
library(tidyverse)
nc <- nc_open('~/Downloads/pr_duplicate_dates/CLA_hrly_ccsm4.nc') 
time <- ncvar_get(nc, "time")
#check for duplicates with fromLast=TRUE
time_df <- tibble(time_hrs = time, dateTime = as.POSIXct(time*3600, origin="1986-01-01 00:00", tz = "UTC"))
duplicated_time_positions <- which(duplicated(time, fromLast = TRUE))

#need to format this into strings for NCO
#e.g. ncks -d Time,0,433 -d Time,435,598 -d Time,600,1013 wrfout_1 wrfout_2
#get start/end postions, then combine
#NETCDF INDICES START AT 0!!!!!!!!!!!!!!!!!!!!

#remove consecutive positions!  CLA has entire duplicated year...
dups_lagged <- lag(duplicated_time_positions)
dup_position_df <- tibble(position = duplicated_time_positions,
                          lagged = dups_lagged,
                          lag_difference = position - lagged) %>% 
  filter(is.na(lag_difference) | lag_difference > 1)
dup_dates_df <- slice(time_df, dup_position_df$position)

starts <- c(1, dup_position_df$position+1) - 1


ends <- c(dup_position_df$position-1, length(time)) - 1
strings <- paste(paste("-d time", starts, ends, sep = ","), collapse = " ")
write_lines(strings, path = "CCSM4_CLA_NHM_time_multislabs.txt")
nc_close(nc)
