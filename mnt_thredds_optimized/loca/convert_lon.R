lon<-read.csv('lon.csv')
lon<-as.numeric(lon$X234.03125)
lon<-lon-360
lon_one_two<-array(dim=c(length(lon),2))
bounds_diff<-lon[2]-lon[1]
lon_bnds.1<-lon-bounds_diff/2
lon_bnds.2<-lon+bounds_diff/2
lon_one_two[,1]<-lon_bnds.1
lon_one_two[,2]<-lon_bnds.2
write.csv(x = lon, file = 'new_lon.csv', row.names = FALSE)
write.csv(x = lon_one_two, file = 'lon_1_2.csv', row.names = FALSE)
# Then hand edit these files into the format for ncml variables.