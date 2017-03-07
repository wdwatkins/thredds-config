library(whisker)
library(tools)

domains <- c("d01","d02","d03")
models <- c("CNRM", "CESM")
tempRes <- c("monthly", "WRF_EXTRACT")
joinTemplate<-readLines("./loca_template_join.ncml")
dir.create('ncml_joins')
allFiles <- scan('allFiles_noAll.txt', what = "character")


for(d in domains) {
  #get domain files
  domainFiles <- allFiles[grepl(pattern = d, allFiles)]
  latLonFile <- paste0("RAW_WRF_LAT_LON/wrfout_", d, "_2060-01-01_00:00:00")
  
  for(t in tempRes) {
    #narrow to monthly/hourly
    tempResFiles <- domainFiles[grepl(pattern = t, domainFiles)]
    timeFile <- paste0("times_", t, ".nc")
    #narrow to model
    for(m in models) {
      modelFiles <- tempResFiles[grepl(pattern = m, tempResFiles)]
      #add in lat/lon, time
      #modelFiles <- c(modelFiles, latLonFile, timeFile)
      
      #now create join ncml
      #create join names
      joinName <- paste(d, t, m, sep = "_")
      joinFiles <- paste0("../", modelFiles)
      
      #render
      cat(whisker.render(joinTemplate), 
          file=paste0("ncml_joins/",joinName,".ncml"), append=FALSE)  
    }
  }
}

unionTemplate <- readLines('puertoRico_rename_template.ncml')
#now do rename variables
for(t in tempRes) {
  if(t == "monthly") {
    vars <- read.table('monthly_table.txt', stringsAsFactors = FALSE)
    timeFile <- "./times_monthly.nc"
  }
  if(t == "WRF_EXTRACT") {
    vars <- read.table('wrfex_table.txt', stringsAsFactors = FALSE)
    timeFile <- "./times_WRF_EXTRACT.nc"
  }
  
  #get list structure right for whisker
  #use iterateList!!
  globalVars <- scan('global_vars.txt', what = "character")
  globalVars <- iteratelist(globalVars, value = "var")
  
  #spatial domains
  for(d in domains) {
    latlonFile <- paste0("./lat_lon/", d, "_latlon_noTime.nc")
    #find matching joins
    matchingJoins <- list.files("./ncml_joins", pattern = t, full.names = TRUE)
    matchingJoins <- matchingJoins[grep(d, matchingJoins)]
    shellFile <- paste0(d, "_", t, ".sh")
    file.remove(shellFile) #will be appending later
    pairs <- list()
    joins <- list()
    for(j in 1:length(matchingJoins)) {
      for(v in 1:nrow(vars)) {
        pairs[[v]] <- list(origName = vars[v,1], 
                           newName = paste(vars[v,1], 
                                           file_path_sans_ext(basename(matchingJoins[j])),
                                           sep = "_"),
                           longName = vars[v, 2])
        
        #write line of shell script
        #one variable/file for now
        #can the URL reference a specific variable inside a join?
        command <- "nccopy -k nc7 -d 1 -c Time/1,west_east/40,south_north/40 -u"
        baseURL <- paste0("http://localhost:8080/thredds/dodsC/testAll/TB12RAID/puertoRico/",
                          file = paste0(d, "_", t, ".ncml"))
        appendURL <-  paste0("?", vars[v,1],"_",
                             file_path_sans_ext(basename(matchingJoins[j])),
                             ",time_int,XLONG,XLAT")
        outFile <- file.path("output",paste(vars[v,1],basename(matchingJoins[j]), sep = "_"))
        outFile <- gsub(pattern = "ncml", replacement = "nc", x = outFile)
        allURL <- paste0(baseURL, appendURL)
        scriptLine <- paste(command, allURL, outFile, "\n")
        cat(scriptLine, file = shellFile, append = TRUE)
      }
      joins[[j]] <- list(joinName = matchingJoins[j], pairs = pairs)
    }
    
    cat(whisker.render(template = unionTemplate, list(joins = joins, 
                                                      globalVars = globalVars,
                                                      timeFile = timeFile,
                                                      latlonFile = latlonFile)), 
        file = paste0(d, "_",t, ".ncml"))
    
  }
}

