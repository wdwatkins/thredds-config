library(whisker)
library(stringr)

vars <- readLines("./UpperDeschutes_variables.txt")
ncCalls<-list()
for (i in 1:length(vars)) { 
  ncCalls<-paste0("nccopy -k 3 -d 1 -c time/1,UTM_Meters_North/30,UTM_Meters_East/30 -u http://cida-eros-netcdfdev.er.usgs.gov:8080/thredds/dodsC/thredds_workspace/cooper/cooper_union_deschutes.ncml?lon,UTM_Meters_North,lat,UTM_Meters_East,time,", vars, " /mnt/thredds/cooper/data/UpperDeschutes/",vars,".nc\n")
} 
data<-list(ncCalls)
#cat(whisker.render(data), file="UpperDeschutes_nccalls.txt", append=FALSE)
lapply(data, write, "UpperDeschutes_nccalls.txt", append=FALSE, ncolumns=1000)


vars <- readLines("./McKenzie_variables.txt")
ncCalls<-list()
for (i in 1:length(vars)) { 
  ncCalls<-paste0("nccopy -k 3 -d 1 -c time/1,UTM_Meters_North/30,UTM_Meters_East/30 -u http://cida-eros-netcdfdev.er.usgs.gov:8080/thredds/dodsC/thredds_workspace/cooper/cooper_union_mckenzie.ncml?lon,UTM_Meters_North,lat,UTM_Meters_East,time,", vars, " /mnt/thredds/cooper/data/McKenzie/",vars,".nc\n")
} 
data<-list(ncCalls)
#cat(whisker.render(as.character(data)), file="McKenzie_nccalls.txt", append=FALSE)
lapply(data, write, "McKenzie_nccalls.txt", append=FALSE, ncolumns=1000)
