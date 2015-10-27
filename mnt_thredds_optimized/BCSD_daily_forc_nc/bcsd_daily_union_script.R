library(stringr)
library(whisker)
folders <- readLines("./bcsd_daily_folders.txt")
vars <- readLines("./bcsd_daily_vars.txt")
ncFoldersList<-list()
for (i in 1:length(folders)) {
  varList<-list()
  for (j in 1:length(vars)) {
    varList<-append(varList,list(list(orgName=vars[j], name=paste0(folders[i],"_",vars[j]))))
  }
  ncFoldersList<-append(ncFoldersList,list(list(folder=folders[i],vars=varList)))
}
data<-list(folders=ncFoldersList)
template<-readLines("./join_template.ncml")
cat(whisker.render(template, data), file="bcsd_daily.ncml", append=FALSE)
