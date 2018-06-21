library(ncdf4)

for(d in c("d01", "d02", "d03")) {
  
  #pull out a single time step from the lat lon files
  nc <- nc_open(paste0('lat_lon/',d,'_lon_lat.nc'))
  xlat <- ncvar_get(nc, 'XLAT')
  xlon <- ncvar_get(nc, 'XLONG')
  
  new_xlat <- xlat[,,1]
  new_xlong <- xlon[,,1]
  
  #create new ncdf file with no time dim
  west_east_dim <- ncdim_def('west_east', '',1:nrow(new_xlong), create_dimvar=FALSE)
  south_north_dim <- ncdim_def('south_north', '',1:ncol(new_xlong), 
                               create_dimvar = FALSE)
  
  #creates empty variables
  lat_var <- ncvar_def(name = 'XLAT', units = "degree_north", 
                       dim = list(west_east_dim, south_north_dim), 
                       missval = -999)
  lon_var <- ncvar_def(name = "XLONG", units = "degree_east", 
                       dim = list(west_east_dim, south_north_dim), 
                       missval = -999)
  
  #puts vars in file
  new_file<-nc_create(filename = paste0('lat_lon/',d,'_latlon_noTime.nc'), 
                      vars = list(lat_var, lon_var))
  #fill the vars
  ncvar_put(nc = new_file, varid = lat_var, vals = new_xlat)
  ncvar_put(nc = new_file, varid = lon_var, vals = new_xlong)
  nc_close(new_file)
}