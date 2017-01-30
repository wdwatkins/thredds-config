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
  }
  if(t == "WRF_EXTRACT") {
    vars <- scan('wrfEx_vars.txt', what = "character")
  }
  
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
    }
    joins[[j]] <- list(joinName = matchingJoins[j], pairs = pairs)
  }
  
  cat(whisker.render(template = unionTemplate, list(joins = joins)), file = paste0(t, ".ncml"))
}


