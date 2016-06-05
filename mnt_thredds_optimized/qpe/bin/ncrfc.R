library(maptools)
library(rgdal)
library(ncdf4)
nc<-nc_open('http://cida.usgs.gov/thredds/rfc_qpe/dodsC/RFC/QPE/KMSR')
lat<-ncvar_get(nc,varid='lat')
lon<-ncvar_get(nc,varid='lon')
shape_out<-matrix(nrow=nrow(lat)*ncol(lat), ncol = 4)
counter=1
for(i in 1:nrow(lat)) {
  for(j in 1:ncol(lat)) {
    shape_out[counter,1]<-lon[i,j]
    shape_out[counter,2]<-lat[i,j]
    shape_out[counter,3]<-i-1
    shape_out[counter,4]<-j-1
    counter<-counter+1
  }
}
coordin<-data.frame(shape_out[,1:2])
dataf<-as.data.frame(shape_out[,3:4])
names(dataf)<-c('x','y')
projec<-CRS("+proj=longlat +datum=NAD83")
points_shape<-SpatialPointsDataFrame(coordin,dataf,proj4string = projec)
writePointsShape(points_shape,'ncrfc_cell_points')
