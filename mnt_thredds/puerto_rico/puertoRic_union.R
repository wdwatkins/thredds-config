library(whisker)
library(tools)

domains <- c("d01","d02","d03")
models <- c("CNRM", "CESM")
#tempRes <- c("monthly", "WRF_EXTRACT")
tempRes <- "wrfextr"
joinTemplate<-readLines("./loca_template_join.ncml")
dir.create('ncml_joins')
allFiles <- list.files('/Volumes/RAID0/PR_hourly_redo/orig', pattern = "*.nc",
                       recursive = TRUE, full.names = TRUE)

for(d in domains) {
  #get domain files
  domainFiles <- allFiles[grepl(pattern = d, allFiles)]
  latLonFile <- paste0("lat_lon/", d, "_latlon_noTime.nc")
  
  for(t in tempRes) {
    #narrow to monthly/hourly
    tempResFiles <- domainFiles[grepl(pattern = t, domainFiles)]
    if(t == "wrfextr") {
      timeFile <- "times_WRF_EXTRACT"
    } else {
      timeFile <- paste0("times_", t, ".nc")
    }
    
    #narrow to model
    for(m in models) {
      if(t == "wrfextr") {
        timeFile <- paste0(timeFile, "_",m, ".nc")
      }
      
      modelFiles <- tempResFiles[grepl(pattern = m, tempResFiles)]
      #add in lat/lon, time
      #modelFiles <- c(modelFiles, latLonFile, timeFile)
      
      #now create join ncml
      #create join names
      joinName <- paste(d, t, m, sep = "_")
      #needed to paste here in teh original version, now obsolete
      joinFiles <- modelFiles
      
      #render
      cat(whisker.render(joinTemplate), 
          file=paste0("ncml_joins/",joinName,".ncml"), append=FALSE)  
    }
  }
}


##################################################

unionTemplate <- readLines('puertoRico_rename_template.ncml')
#now do rename variables
for(t in tempRes) {
  if(t == "monthly") {
    vars <- read.table('monthly_table.txt', stringsAsFactors = FALSE)
    timeFile <- "./times_monthly.nc"
  }
  
  
  #get list structure right for whisker
  #use iterateList!!
  globalVars <- scan('global_vars.txt', what = "character")
  globalVars <- iteratelist(globalVars, value = "var")
  
  for(m in models) {
    if(t == "wrfextr") {
      vars <- read.table('wrfex_table.txt', stringsAsFactors = FALSE, sep = "\t")
      timeFile <- paste0("times_WRF_EXTRACT", "_",m, ".nc")
      stopifnot(file.exists(timeFile))
    }
    #spatial domains
    for(d in domains) {
      latlonFile <- paste0("./lat_lon/", d, "_latlon_noTime.nc")
      shellFile <- paste0(d, "_", t, "_",m,".sh")
      file.remove(shellFile) #will be appending later
      pairs <- list()
      joins <- list()
      j <- paste0("ncml_joins/",d, "_", t, "_", m, ".ncml") #join across time 
      for(v in 1:nrow(vars)) {
        pairs[[v]] <- list(origName = vars[v,1], 
                           newName = paste(vars[v,1], d,t,m,sep = "_"),
                           longName = vars[v, 2])
        #d02_wrfextr_CESM
        #write line of shell script
        #one variable/file for now
        #can the URL reference a specific variable inside a join?
        command <- "nccopy -k nc7 -d 1 -c Time/1,west_east/40,south_north/40 -u"
        baseURL <- paste0("http://localhost:8080/thredds/dodsC/testAll/OWC_HD/PuertoRico/",
                          file = paste0(d, "_", t, "_", m,".ncml"))
        appendURL <-  paste0("?",
                             paste(vars[v,1], d,t,m,sep = "_"),
                             ",time_int,XLONG,XLAT")
        outFile <- file.path("/Volumes/RAID0/PR_hourly_redo/output",paste0(paste(vars[v,1], d,t,m,sep = "_"), ".nc"))
        allURL <- paste0(baseURL, appendURL)
        scriptLine <- paste(command, allURL, outFile, "\n")
        cat(scriptLine, file = shellFile, append = TRUE)
      }
      #joins[[j]] <- list(joinName = matchingJoins[j], pairs = pairs)
      cat(whisker.render(template = unionTemplate, list(joinName=j,
                                                        pairs = pairs,
                                                        globalVars = globalVars,
                                                        timeFile = timeFile,
                                                        latlonFile = latlonFile)), 
          file = paste0(d, "_",t,"_", m, ".ncml"))
    }
  }
}

