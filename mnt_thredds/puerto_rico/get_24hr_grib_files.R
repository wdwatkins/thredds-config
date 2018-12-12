library(dplyr)
all_files <- list.files('~/Downloads/example_files/', full.names = TRUE)
file_hours <- tools::file_path_sans_ext(all_files) %>% 
  gsub(pattern = "r_pgb", replacement = "", x = .) %>% 
  basename()
is_24hr <- (file_hours %% 24) == 0
