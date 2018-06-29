library(ncdf4)
library(lubridate)
offset <- 0
for(year in 1980:2015){
  if(!leap_year(year)) {
    n = 365*24
  } else { n = 366*24}
  vals <- 0:(n-1) + offset
  offset <- offset + n
  wrf_nc_time_dim <- ncdim_def('Time', '', 1:length(vals), create_dimvar = FALSE)
  origin <- "1980-01-01 00:00:00"
  wrf_nc_time_var <-
    ncvar_def('Time',
              paste('hours since', origin),
              wrf_nc_time_dim,
              -999,
              prec = 'integer')
  wrf_nc_file <-
    nc_create(paste0("/Volumes/RAID0/red_river/times_", year, ".nc"), list(wrf_nc_time_var))
  wrf_var <- ncvar_put(wrf_nc_file, wrf_nc_time_var, vals)
  nc_close(wrf_nc_file)
}
