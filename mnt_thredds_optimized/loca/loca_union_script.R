library(stringr)
library(whisker)

templatefun<-function(models,rcps,vars,files,outname,searchstring) {
  runs<-c('_r1i1p1_','_r2i1p1_','_r6i1p1_','_r8i1p1_','_r6i1p3_')
  count<-0
  joinList<-list()
  nccopy_file<-file(paste0(outname,'.sh'),"w")
  ncatted_file<-file("ncatted_loca.nc","w")
  for (i in 1:length(models)) { # First level loop over 20 models
    for (j in 1:length(rcps)) { # Second level loop over 3 time periods
      varList<-list()
      varstring<-NA
      for (l in 1:length(vars)) { # Third level loop over 10 variables
        for (r in 1: length(runs)) {
          joinFileList<-list()
          for(k in 1:length(files)) { # Fourth level loop over all files to ensure files exist.
            if(grepl(pattern = paste0(vars[l], "_day_", models[i], "_", rcps[j], runs[r], ".*",searchstring), x = files[k])) {
              joinFileList<-append(joinFileList,list(list(fileName=paste0('../',files[k]))))
              count<-count+1
            }
          }
          if(length(joinFileList)>0) { # Create join ncml
            joinVarName<-paste0(vars[l], "_", models[i], runs[r], rcps[j])
            joinFileName<-paste0('ncml_joins/',joinVarName,'.ncml')
            joinList<-append(joinList,list(list(joinName=joinFileName,orgName=vars[l], name=joinVarName)))
            joinData<-list(joinFiles=joinFileList)
            template<-readLines("./loca_template_join.ncml")
            cat(whisker.render(template, joinData), file=joinFileName, append=FALSE)
            if(is.na(varstring)) {
              varstring<-joinVarName
              nccopy_outName<-paste0(models[i], runs[r], rcps[j])
            } else {
              varstring<-paste0(varstring,',',joinVarName)
            }
          }
        } 
      }
      nccopy_base<-"nccopy -k nc7 -d 1 -c time/1,lat/40,lon/40 -u "
      nccopy_url<-"http://localhost:8080/thredds/dodsC/thredds/loca/"
      nccopy_dataset<-paste0(outname,'?')
      nccopy_line<-paste0(nccopy_base,nccopy_url,nccopy_dataset,varstring,
                          ',lat,lon,time,lat_bnds,lon_bnds,time_bnds ',
                          nccopy_outName,'.nc')
      writeLines(nccopy_line,nccopy_file)
    }
  }
  close(nccopy_file)
  data<-list(joins=joinList)
  template<-readLines("./loca_template.ncml")
  cat(whisker.render(template, data), file=paste0(outname), append=FALSE)
  return(paste('Put',count,'files into ncml file',outname))
}

files <- read.csv("./loca_files.csv",stringsAsFactors = FALSE)$x
vars <- readLines("./loca_vars.txt")
models <- readLines("./loca_models.txt")
rcps<-c("rcp45","rcp85")
templatefun(models,rcps,vars,files,'loca_future_daily.ncml',"LOCA_2016-04-02.16th.nc")
rcps<-c("historical")
templatefun(models,rcps,vars,files,'loca_historical_daily.ncml',"LOCA_2016-04-02.16th.nc")
