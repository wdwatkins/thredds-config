library(whisker)

domains <- c("d01","d02","d03")
models <- c("CNRM", "CESM")
tempRes <- c("monthly", "WRF_EXTRACT")
template<-readLines("./loca_template_join.ncml")
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
      joinFileList <- list(joinFiles = list(fileName = paste0("../", modelFiles)))
    
      #render
      cat(whisker.render(template, joinFileList), 
          file=paste0("ncml_joins/",joinName,".ncml"), append=FALSE)  
    }
  }
}

#create ncml of all joins 
