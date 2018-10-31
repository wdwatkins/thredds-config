library(ncdf4)
library(magrittr)
library(tools)
library(lubridate)
files <- list.files('/Volumes/RAID0/hawaii/RCP45', 
                    full.names = TRUE, pattern = "wrfout_maui", 
                    recursive = TRUE)
origin <- as.POSIXct("1990-01-01 00:00:00")
for(f in files) {
  day_start_hour <- basename(f) %>% file_path_sans_ext() %>% 
    gsub(pattern = "wrfout_maui_hourly_", replacement = "") %>% as.POSIXct()
  day_end_hour <- day_start_hour + 23*60*60
  day_hour_seq <- seq(day_start_hour, day_end_hour, by = "hour")
  day_hour_ints <- as.integer(difftime(day_hour_seq, origin, units = "hour"))
  wrf_nc_time_dim <- ncdim_def('Time', '', seq_along(day_hour_ints), create_dimvar = FALSE)
  wrf_nc_time_var <- 
    ncvar_def('XTIME',
              paste('hours since', origin), wrf_nc_time_dim,
              -999,
              prec = 'integer')
  time_nc_file <- nc_create(paste0("/Volumes/RAID0/hawaii/times/times_", day_start_hour, ".nc"), 
                            list(wrf_nc_time_var))
  ncvar_put(time_nc_file, wrf_nc_time_var, day_hour_ints)
  ncatt_put(time_nc_file, 'XTIME', "_CoordinateAxisType", "Time")
  nc_close(time_nc_file)
}