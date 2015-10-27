library(stringr)
library(whisker)
files <- readLines("./bcsd_hydro_files.txt")
var_mods <- str_replace(str_replace(files, "conus_c5.", ""),".monthly.1950-2099.nc","")
vars <- readLines("./bcsd_hydro_vars.txt")
ncFilesList<-list()
for (i in 1:length(files)) {
  varList<-list()
  for (j in 1:length(vars)) {
    varList<-append(varList,list(list(orgName=vars[j], name=paste0(var_mods[i],"_",vars[j]))))
  }
  ncFilesList<-append(ncFilesList,list(list(fileName=files[i],vars=varList)))
}
data<-list(ncFiles=ncFilesList)
template<-readLines("./bcsd_hydro_template.ncml")
cat(whisker.render(template, data), file="bcsd_hydro_union.ncml", append=FALSE)