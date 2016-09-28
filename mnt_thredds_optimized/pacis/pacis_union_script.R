library(stringr)
library(whisker)

templatefun<-function(regions,rcps,vars,files,outname) {
  count<-0
  for (i in 1:length(regions)) {
    fileList<-list()
    for (j in 1:length(rcps)) {
      for (l in 1:length(vars)) {
        VarName<-paste0(vars[l], "_", rcps[j])
        FileName<-paste0(regions[i],'/processed_hourly/',regions[i],'_hourly_',rcps[j],'_',vars[l],'_1990-2009.nc')
        fileList<-append(fileList,list(list(fileName=FileName,orgName=vars[l], name=VarName)))
        count<-count+1
      }
    }
    data<-list(files=fileList)
    template<-readLines("./pacis_template.ncml")
    cat(whisker.render(template, data), file=paste0(regions[i],outname), append=FALSE)
  }
  return(paste('Put',count,'files into ncml file',outname))
}

files <- read.csv("./pacis_files.csv",stringsAsFactors = FALSE)$x
vars <- readLines("./pacis_vars.txt")
rcps<-c("present", "rcp45","rcp85")
regions<-c("samoa","guam","kauai","oahu")
templatefun(regions,rcps,vars,files,'pacis.ncml')
