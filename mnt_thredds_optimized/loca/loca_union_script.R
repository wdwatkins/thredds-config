library(stringr)
library(whisker)

templatefun<-function(models,rcps,vars,files,outname,searchstring) {
  count<-0
  joinList<-list()
  for (i in 1:length(models)) { # First level loop over 20 models
    for (j in 1:length(rcps)) { # Second level loop over 3 time periods
      varList<-list()
      for (l in 1:length(vars)) { # Third level loop over 10 variables
        joinFileList<-list()
        for(k in 1:length(files)) { # Fourth level loop over all files to ensure files exist.
          if(grepl(pattern = paste0(vars[l], "_day_", models[i], "_", rcps[j], "_r1i1p1_", ".*",searchstring), x = files[k])) {
            joinFileList<-append(joinFileList,list(list(fileName=paste0('../',files[k]))))
            count<-count+1
          }
        }
        if(length(joinFileList)>0) { # Create join ncml
          joinVarName<-paste0(vars[l], "_", models[i], "_r1i1p1_", rcps[j])
          joinFileName<-paste0('ncml_joins/',joinVarName,'.ncml')
          joinList<-append(joinList,list(list(joinName=joinFileName,orgName=vars[l], name=joinVarName)))
          joinData<-list(joinFiles=joinFileList)
          template<-readLines("./loca_template_join.ncml")
          cat(whisker.render(template, joinData), file=joinFileName, append=FALSE)
        }
      }
    }
  }
  data<-list(joins=joinList)
  template<-readLines("./loca_template.ncml")
  cat(whisker.render(template, data), file=paste0(outname), append=FALSE)
  return(paste('Put',count,'files into ncml file',outname))}

files <- read.csv("./loca_files.csv",stringsAsFactors = FALSE)$x
vars <- readLines("./loca_vars.txt")
models <- readLines("./loca_models.txt")
rcps<-c("rcp45","rcp85")
templatefun(models,rcps,vars,files,'loca_future_daily.ncml',"LOCA_2016-04-02.16th.nc")
rcps<-c("historical")
templatefun(models,rcps,vars,files,'loca_historical_daily.ncml',"LOCA_2016-04-02.16th.nc")
