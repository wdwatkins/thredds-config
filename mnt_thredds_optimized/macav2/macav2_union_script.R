library(stringr)
library(whisker)

templatefun<-function(models,rcps,vars,files,long_vars,outname,searchstring) {
  count<-0
  joinList<-list()
  nccopy_file<-file(paste0(outname,'.sh'),"w")
  for (i in 1:length(models)) { # First level loop over 20 models
    for (j in 1:length(rcps)) { # Second level loop over 3 time periods
      for (r in c("r1i1p1","r6i1p1")) {
        varList<-list()
        for (l in 1:length(vars)) { # Third level loop over 10 variables
          joinFileList<-list()
          for(k in 1:length(files)) { # Fourth level loop over all files to ensure files exist.
            if(grepl(pattern = paste0(vars[l], "_", models[i], "_",r,"_", rcps[j], ".*",searchstring,".*"), x = files[k])) {
              joinFileList<-append(joinFileList,list(list(fileName=paste0('../',files[k]))))
              count<-count+1
            }
          }
          if(length(joinFileList)>0) { # Create join ncml
            joinVarName<-paste0(vars[l], "_", models[i],  "_",r,"_", rcps[j])
            joinFileName<-paste0('ncml_joins/',joinVarName, "_", searchstring,'.ncml')
            joinList<-append(joinList,list(list(joinName=joinFileName,orgName=long_vars[vars[l]], name=joinVarName)))
            joinData<-list(joinFiles=joinFileList)
            template<-readLines("./macav2_template_join.ncml")
            cat(whisker.render(template, joinData), file=joinFileName, append=FALSE)
            varstring<-joinVarName
            nccopy_outName<-paste0(outname,vars[l],'_',models[i],'_', r, '_', rcps[j])
            nccopy_base<-"nccopy -k nc7 -m 100M -d 1 -c time/1,lat/44,lon/107 -u "
            nccopy_url<-"http://localhost:8080/thredds/dodsC/thredds/macav2/"
            nccopy_dataset<-paste0(outname,'?')
            nccopy_line<-paste0(nccopy_base,nccopy_url,nccopy_dataset,varstring,
                                ',lat,lon,time,crs ',
                                nccopy_outName,'.nc')
            writeLines(paste('echo',nccopy_outName),nccopy_file)
            writeLines(nccopy_line,nccopy_file)
          }
        }
      }
    }
  }
  close(nccopy_file)
  data<-list(joins=joinList)
  template<-readLines("./macav2_template.ncml")
  cat(whisker.render(template, data), file=paste0('./',outname), append=FALSE)
  return(paste('Put',count,'files into ncml file',outname))}

files <- read.csv("./macav2_files.csv",stringsAsFactors = FALSE)$x
vars <- readLines("./macav2_vars.txt")
long_vars <- list(pr="precipitation",
                  huss="specific_humidity",
                  rhsmax="relative_humidity",
                  rhsmin="relative_humidity",
                  rsds="surface_downwelling_shortwave_flux_in_air",
                  tasmax="air_temperature",
                  tasmin="air_temperature",
                  uas="eastward_wind",
                  vas="northward_wind",
                  was="wind_speed")
models <- readLines("./macav2_models.txt")
rcps<-c("rcp45","rcp85")
templatefun(models,rcps,vars,files,long_vars,'macav2_future_daily.ncml',"daily")
templatefun(models,rcps,vars,files,long_vars,'macav2_future_monthly.ncml',"monthly")
rcps<-c("historical")
templatefun(models,rcps,vars,files,long_vars,'macav2_historical_daily.ncml',"daily")
templatefun(models,rcps,vars,files,long_vars,'macav2_historical_monthly.ncml',"monthly")

