library(whisker)
library(dplyr)
rm(list=ls())
catalog_template <- readLines('catalog_dataset_template.xml')
thredds_ncml_template <- readLines('thredds_config_ncml_template.ncml')
sb_iso_template <- readLines('iso_template.xml')

dataset_names <- read.csv('filelist.csv') %>% 
  rename(file = files) %>% 
  mutate(dates = stringr::str_sub(file, -20,-4),
         file_path = file.path('/mnt/thredds/cprep', file)) %>% 
  tidyr::separate(col = dates, into = c("start", "end"), sep = "-") %>% 
  mutate_at(.vars = c("start", "end"), .funs = as.Date, format = "%Y%m%d") 

#render ncml metadata - only location and data type needs to change
datasets <- list()
i <- 1
meta <- yaml::read_yaml('config_meta.yaml')
for(i in seq_along(dataset_names$title)) {
  file <- dataset_names$file[i]
  title <- dataset_names$title[i]
  meta$location <- dataset_names$file_path[i]
  meta$id <- file.path('cida.usgs.gov', file)
  meta$dataset_start_time <- dataset_names$start[i]
  meta$dataset_end_time <- dataset_names$end[i]
  ncml_out <- whisker::whisker.render(thredds_ncml_template, meta)
  ncml_path <- paste0(file.path("~/Documents/nonR/thredds-config/content/thredds/metadata/cprep", 
                                tools::file_path_sans_ext(file)), ".ncml")
  cat(ncml_out, file=ncml_path)
  
  #render catalog.xml section
  #section for each of datasets
  #name, id, path, location changes
  meta[['lat_size']] <- meta$lat_max - meta$lat_min
  meta[['lon_size']] <- meta$lon_max - meta$lon_min
  dataset_url_path <- paste("cprep", file, sep = "_")
  datasets[[i]] <- list(
    dataset_name = title,
    dataset_url_path = dataset_url_path,
    dataset_id = file.path("cida.usgs.gov/cprep", file),
    dataset_meta_location = paste0(file.path("metadata/cprep", tools::file_path_sans_ext(file)), ".ncml"),
    dataset_title = title,
    dataset_start_time = meta$dataset_start_time,
    dataset_end_time = meta$dataset_end_time,
    note = meta$note,
    thredds_url = file.path('https://cida-test.er.usgs.gov/thredds/dodsC/', dataset_url_path),
    service_id = paste('OPeNDAP', i, sep = "_"))
  i <- i + 1
  meta[['attribute_description']] <- list(ddx_description = meta$attribute_description[[2]],
                                          ddx_url = meta$attribute_description[[1]])
}
meta$datasets <- datasets
catalog_out <- whisker::whisker.render(catalog_template, meta)
cat(catalog_out, file = "../../content/thredds/cprep_catalog.xml")

iso_out <- whisker::whisker.render(sb_iso_template, meta)
cat(iso_out, file = paste0(meta$sciencebase_id, ".xml"))
