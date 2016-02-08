library(rgdal)
setwd('~/temp/stage4/')
xy<-read.csv('xy.csv', header=FALSE)
x<-as.numeric(xy[1,])
y<-as.numeric(xy[2,])
y<-y[which(!is.na(y))]
xy2<-matrix(nrow=length(x)*length(y), ncol=2)
counter=1
for(i in 1:length(x)) {
	for(j in 1:length(y)) {
		xy2[counter,]<-c(x[i],y[j])
		counter<-counter+1
	}
}
# Stated Projection:
# grid_mapping_name: stereographic
# longitude_of_projection_origin: -105.00000762939453
# latitude_of_projection_origin: 90.0
# scale_factor_at_projection_origin: 0.9330127018922193
# earth_radius: 6371229.0
# Unproject with the following rgdal command.
xyPoints<-project(xy2,
									proj="+proj=stere +lat_0=90 +lat_ts=60 +lon_0=-105 +k=0.9330127018922193 +x_0=0 +y_0=0 +a=6371229.0 +b=6371229.0 +units=km +no_defs",
									inv=TRUE)
# xyPoints<-SpatialPoints(xyPoints,proj4string=CRS("+init=epsg:4326"))
# Reformat for ncml
lon<-matrix(nrow=length(x), ncol=length(y))
lat<-matrix(nrow=length(x), ncol=length(y))
counter=1
for(i in 1:length(x)) {
	for(j in 1:length(y)) {
		lon[i,j]<-xyPoints[counter,1]
		lat[i,j]<-xyPoints[counter,2]
		counter<-counter+1
	}
}
write.table(x = lat, file = 'lat.csv',row.names = FALSE, col.names = FALSE, sep=' ')
write.table(x = lon, file = 'lon.csv',row.names = FALSE, col.names = FALSE, sep=' ')

