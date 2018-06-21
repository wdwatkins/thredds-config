#find scale factors to retain max precision for 16 bit integer
findPrecision16Int <- function(maxAbs){
  scale <- NA
  #see how far can go before exceed 32768
  for(i in 10^seq(from = -4, to = 8)){
    if(maxAbs*i <= 32767){
      scale <- i
    }
  }
  return(scale)
}

findPrecision32Int <- function(min, max){
  scale <- NA
  limit <- 2147483647
  if(limit < (max - min)) {
    warning("Sorry, range is too big")
  }
  
  #center around 0 
  offset <- -mean(c(min, max))
  maxAbs <- max(abs(c(min, max)))
  #see how far can go before exceed 32768
  for(i in 10^seq(from = -4, to = 8)){
    if((maxAbs - offset)*i <= 2147483647){
      scale <- i
    }
  }
  return(list(scale = scale, offset = offset))
}

findPrecision32Int_noOffset <- function(maxAbs){
  scale <- NA
  #see how far can go before exceed 32768
  for(i in 10^seq(from = -4, to = 8)){
    if(maxAbs*i <= 2147483647){
      scale <- i
    }
  }
  return(scale)
}

options(scipen=20)
library(dplyr)
scales <- read.table('/Volumes/RAID0/PR_hourly_redo/output/d03_range.txt', sep = " ",
                     stringsAsFactors = FALSE, col.names = c("varOnly", "varInFile", "min", "max"))
computedFactors <- scales %>% rowwise() %>% 
  mutate(absMax = max(c(min, max)),
         scale = findPrecision16Int(absMax),
         scale.factorAtt = as.character(1/scale),
         scale = as.character(scale))
         #GivenDimensions = gsub(x = GivenDimensions, pattern = ",", repl = "/"))

bigFactors <- filter(computedFactors, scale <= 1 | is.na(scale)) %>%
              rowwise() %>% mutate(scale = findPrecision32Int_noOffset(absMax),
                                   scale.factorAtt = as.character(1/scale),
                                   scale = as.character(scale))
computedFactors_16 <- filter(computedFactors, !varInFile %in% bigFactors$varInFile)

write.table(x = computedFactors_16, file = "scalingScripts/d03_wrf_scales_16.csv", row.names = FALSE,
          quote = TRUE, sep = "\t")
write.table(x = bigFactors, file = "scalingScripts/d03_wrf_scales_32.csv", row.names = FALSE,
            quote = TRUE, sep = "\t")

