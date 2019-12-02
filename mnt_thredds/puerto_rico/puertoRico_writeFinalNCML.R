library(whisker)
library(tools)

domains <- c("d01","d02","d03")
tempRes <- c("wrfextr")
models <- c("CESM", "CNRM")
joinTemplate<-readLines("./puertoRico_finalUnion.ncml")
allFiles <- list.files('/Volumes/RAID0/PR_hourly_redo/output/out')

for(d in domains) {
  #get domain files
  domainFiles <- grep(pattern = d, allFiles, value = TRUE)
  domainFiles <- grep(pattern = "ncml", x = domainFiles, value = TRUE, invert = TRUE)
  
  for(t in tempRes) {
    #narrow to monthly/hourly
    tempResFiles <- grep(pattern = t, domainFiles, value = TRUE)
    for(m in models){
      model_files <- grep(pattern = m, tempResFiles, value = TRUE)
      vars <- file_path_sans_ext(model_files)
      scan_location <- file.path(t,d)
      scan_suffix <- paste0(m, ".nc")
      #render
      joinName <- paste(d, t, m, sep = "_")
      cat(whisker.render(joinTemplate), 
          file=paste0("ncml_final/",joinName,".ncml"), append=FALSE)  
      }
    }
}
