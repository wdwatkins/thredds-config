library(whisker)
library(stringr)
files <- list.files('/Volumes/RAID0/notaro/USGS/', pattern = ".nc$")

gcms <- str_extract(pattern = "_(.*?)_", string = files) %>% 
  gsub(pattern = "_", replacement = "") %>% unique()
template <- readLines('notaro_template_join.ncml')
for(g in gcms) {
  gcm_files <- grep(pattern = g, x = files, value = TRUE)
  for(year_block in c("1980|1990","2040|2050","2080|2090")) {
    gcm_year_block_files  <- grep(pattern = year_block, x = gcm_files, value = TRUE)
    vars <- gsub(pattern =paste0("REGCM4_", g, "_"), 
                 x = gcm_year_block_files, replacement = "") %>% 
    str_extract(pattern = "^.*_") %>% 
      gsub(pattern = "_", replacement = "") %>% unique()
    
    joins <- list()
    for(i in seq_along(vars)){
      v <- paste0("_", vars[i], "_")
      var_files <- grep(pattern = v, x = gcm_year_block_files, value = TRUE)
      joins[[i]] <- list(files = var_files)
    }
    #render
    out <- whisker.render(template = template, data = list(joins=joins)) 
    cat(out, file = paste0("join_union_", g, "_", sub("\\|", "_", year_block),".ncml"))
  }
  
}