#add remove statements for all WRF global attributes 
#(in all caps)

#David Watkins December 2016

library(ncdf4)
library(xml2)

urls <- c("https://cida.usgs.gov/thredds/dodsC/samoa",
          "https://cida.usgs.gov/thredds/dodsC/guam",
          "https://cida.usgs.gov/thredds/dodsC/kauai",
          "https://cida.usgs.gov/thredds/dodsC/oahu")

for(u in urls) {
  #get name of data set
  name <- sub('.*\\/', '', u) 
  
  nc <- nc_open(u)
  gAtts <- gAtts <- ncatt_get(nc,0)
  attNames <- names(gAtts)
  
  #get all uppercase names
  attNames <- attNames[attNames == toupper(attNames)]
  
  #generate lines
  lines <- paste0("<remove type=\"attribute\" name=\"", attNames, "\"/>")
  write.table(lines, file=paste0(name, ".removes"), quote = FALSE, row.names = FALSE, col.names = FALSE)
 
  #add to corresponding ncml?
  #need to figure out xml2 add nodes
  nc_close(nc)
  
}