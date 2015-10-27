library(whisker)
library(stringr)

vars <- readLines("./UpperDeschutes_variables.txt")
vars <- str_replace(vars,"/","_")
ncCalls<-list()
for (i in 1:length(vars)) { 
  ncCalls<-paste0("nccopy -k 3 -d 1 -c time/1,UTM_Meters_North/30,UTM_Meters_East/30 -u http://cida-eros-netcdfdev.er.usgs.gov:8080/thredds/dodsC/thredds_workspace/cooper/cooper_meta.ncml?lon[0:1:780][0:1:384],UTM_Meters_North[0:1:780],lat[0:1:780][0:1:384],UTM_Meters_East[0:1:384],time[0:1:8394],", vars, " /mnt/cooper/data/UpperDeschutes/",vars,".nc")
} 
data<-list(ncCalls)
cat(whisker.render(data), file="UpperDeschutes_nccalls.txt", append=FALSE)
lapply(data, write, "test.txt", append=FALSE, ncolumns=1000)


vars <- readLines("./McKenzie_variables.txt")
ncCalls<-list()
for (i in 1:length(vars)) { 
  ncCalls<-paste0("nccopy -k 3 -d 1 -c time/1,UTM_Meters_North/30,UTM_Meters_East/30 -u http://cida-eros-netcdfdev.er.usgs.gov:8080/thredds/dodsC/thredds_workspace/cooper/cooper_meta.ncml?lon[0:1:780][0:1:384],UTM_Meters_North[0:1:780],lat[0:1:780][0:1:384],UTM_Meters_East[0:1:384],time[0:1:8394],", vars, " /mnt/cooper/data/McKenzie/",vars,"/")
} 
data<-list(ncCalls)
cat(whisker.render(as.character(data)), file="McKenzie_nccalls.txt", append=FALSE)
