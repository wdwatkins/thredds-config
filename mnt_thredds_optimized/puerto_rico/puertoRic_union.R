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
  
  for(t in tempRes) {
    #narrow to monthly/hourly
    tempResFiles <- domainFiles[grepl(pattern = t, domainFiles)]
    
    #narrow to model
    for(m in models) {
      modelFiles <- tempResFiles[grepl(pattern = m, tempResFiles)]
    
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
    vars <- scan('monthlyVars.txt', what = "character")
    shellFile <- "monthly.sh"
  }
  if(t == "WRF_EXTRACT") {
    vars <- scan('wrfEx_vars.txt', what = "character")
    shellFile <- "WRF_EX.sh"
  }
  file.remove(shellFile) #will be appending later
  
  #get list structure right for whisker
  #use iterateList!!
  globalVars <- scan('global_vars.txt', what = "character")
  globalVars <- iteratelist(globalVars, value = "var")
  
  #find matching joins
  matchingJoins <- list.files("./ncml_joins", pattern = t, full.names = TRUE)
  pairs <- list()
  joins <- list()
  for(j in 1:length(matchingJoins)) {
    for(v in 1:length(vars)) {
      pairs[[v]] <- list(origName = vars[v], 
                         newName = paste(vars[v], 
                        file_path_sans_ext(basename(matchingJoins[j])),
                        sep = "_"))
      
      #write line of shell script
      #one variable/file for now
      #can the URL reference a specific variable inside a join?
      command <- "nccopy -k nc7 -d 1 -c time/1,lat/40,lon/40 -u"
      baseURL <- paste0("http://localhost:8080/thredds/dodsC/thredds/puertoRico/",
                        file = paste0(t, ".ncml"))
      appendURL <-  paste0("?", vars[v],"_",
                           file_path_sans_ext(basename(matchingJoins[j])),
                           ",Time,west_east,south_north")
      outFile <- paste(vars[v],basename(matchingJoins[j]), sep = "_")
      outFile <- gsub(pattern = "ncml", replacement = "nc", x = outFile)
      allURL <- paste0(baseURL, appendURL)
      scriptLine <- paste(command, allURL, outFile, "\n")
      cat(scriptLine, file = shellFile, append = TRUE)
    }
    joins[[j]] <- list(joinName = matchingJoins[j], pairs = pairs)
  }
  
  cat(whisker.render(template = unionTemplate, list(joins = joins, 
                                                    globalVars = globalVars)), 
                                                    file = paste0(t, ".ncml"))
}


