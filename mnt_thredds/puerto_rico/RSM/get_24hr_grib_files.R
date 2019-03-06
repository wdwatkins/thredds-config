library(dplyr)
all_files <- list.files('/Volumes/RAID0/PR_FSU_grib/ftp.coaps.fsu.edu/pub/abhardwaj', 
                        recursive = TRUE, full.names = TRUE, pattern = ".nc")
file_hours <- basename(all_files) %>% tools::file_path_sans_ext() %>% 
  gsub(pattern = "r_pgb", replacement = "", x = .) %>% 
  basename() %>% as.numeric()
#dont want zero-hour file either
is_24hr <- ((file_hours %% 24) == 0) & (file_hours != 0)

file_df <- tibble(file = all_files, is_24hr= is_24hr,
                  file_no_path = basename(all_files))
file_df_24hr <- file_df %>% filter(is_24hr)
readr::write_csv(file_df_24hr, path = "files_24hr.csv")
