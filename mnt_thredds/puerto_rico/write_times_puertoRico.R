library(ncdf4)

#load monthly
monthly <- nc_open("http://localhost:8080/thredds/dodsC/testAll/TB12RAID/PuertoRico/ncml_joins/d01_monthly_CESM.ncml")

times <- as.Date(ncvar_get(monthly, "Times"))
jul_time <- as.numeric(julian(times, origin = times[1]))
nc_close(monthly)

nc_time_dim <- ncdim_def('Time','',1:length(jul_time),create_dimvar=FALSE)
nc_time_var <- ncvar_def('time_int', paste('days since', times[1]), nc_time_dim, -999, prec='integer')
nc_file<-nc_create('times_monthly.nc',list(nc_time_var))
var<-ncvar_put(nc_file,nc_time_var,jul_time)
nc_close(nc_file)

#wrfex <- monthly <- nc_open("http://localhost:8080/thredds/dodsC/testAll/TB12RAID/PuertoRico/ncml_joins/d01_WRF_EXTRACT_CESM.ncml")
hist <- seq(as.POSIXct("1985-01-01 00:00:00"), as.POSIXct("2005-12-31 23:00:00"), by = "hours")
future <- seq(as.POSIXct("2040-01-01 00:00:00"), as.POSIXct("2060-12-31 23:00:00"), by = "hours")
allDates <- c(hist, future)
hourDates <- as.numeric(difftime(allDates, as.POSIXct("1985-01-01 00:00:00"), units = "hour"))
wrf_nc_time_dim <- ncdim_def('Time','',1:length(hourDates),create_dimvar=FALSE)
wrf_nc_time_var <- ncvar_def('time_int', 'hours since 1985-01-01 00:00:00', wrf_nc_time_dim, -999, prec='integer')
wrf_nc_file<-nc_create('times_WRF_EXTRACT_CNRM.nc',list(wrf_nc_time_var))
wrf_var<-ncvar_put(wrf_nc_file,wrf_nc_time_var,hourDates)
nc_close(wrf_nc_file)

#now same thing for CESM 365 day calendar
library(PCICt)
startTime365 <- as.PCICt("1985-01-01 00:00:00", cal = "365")
hist365 <- seq(startTime365, as.PCICt("2005-12-31 23:00:00", cal = "365"), 
            by = "hours")
future365 <- seq(as.PCICt("2040-01-01 00:00:00", cal = "365"), 
              as.PCICt("2060-12-31 23:00:00", cal = "365"), by  = "hours")
allDates365 <- as.PCICt(c(hist365, future365), cal = "365")
hourDates365 <- as.numeric(allDates365 - startTime365)/60^2
wrf_nc_time_dim_365 <- ncdim_def('Time','',1:length(hourDates365),create_dimvar=TRUE,
                             calendar = "noleap")
wrf_nc_time_var_365 <- ncvar_def('time_int', 'hours since 1985-01-01 00:00:00', 
                                 wrf_nc_time_dim_365, -999, prec='integer')
wrf_nc_file_365 <- nc_create('times_WRF_EXTRACT_CESM.nc',list(wrf_nc_time_var_365))
wrf_var_365 <- ncvar_put(wrf_nc_file_365, wrf_nc_time_var_365, hourDates365)
nc_close(wrf_nc_file_365)

