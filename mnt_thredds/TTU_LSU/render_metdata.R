library(whisker)
library(dplyr)
rm(list=ls())
catalog_template <- readLines('catalog_dataset_template.xml')
thredds_ncml_template <- readLines('thredds_config_ncml_template.ncml')
sb_iso_template <- readLines('iso_template.xml')
dataset_names <- c("RCP45 Gridded Annual Data",
              "RCP85 Gridded Annual Data",
              "RCP45 Time Slices",
              "RCP85 Time Slices",
              "RCP45 Station Data",
              "RCP85 Station Data")

#for each of 6 datasets:
#render ncml metadata - only location and data type needs to change
datasets <- list()
i <- 1
for(ds in dataset_names) {
  meta <- yaml::read_yaml('config_meta.yaml')
  if(grepl(pattern = "station", x = ds, ignore.case = TRUE)) {
    meta$note <- "The NetcdfSubset service does not work with this dataset"   
  } 
  ds_lower <- tolower(ds) %>% gsub(pattern = " ", replacement = "_", x = .) 
  meta$data_type <- ifelse(test = grepl(pattern = 'station', x = ds_lower), 
                           yes = "point", no = "grid")
  meta$location <- file.path(meta$location_parent, ds_lower, "union.ncml")
  #meta$id <- file.path('cida.usgs.gov', ds_lower)
  ncml_out <- whisker::whisker.render(thredds_ncml_template, meta)
  ncml_path <- paste0(file.path("~/Documents/nonR/thredds-config/content/thredds/metadata/TTU_2019", 
                                ds_lower), ".ncml")
  cat(ncml_out, file=ncml_path)
  
  #render catalog.xml section
  #section for each of 6 datasets
  #name, id, path, location changes
  meta[['lat_size']] <- meta$lat_max - meta$lat_min
  meta[['lon_size']] <- meta$lon_max - meta$lon_min
  dataset_url_path <- paste("TTU_2019", ds_lower, sep = "_")
  datasets[[i]] <- list(
    dataset_name = ds,
    dataset_url_path = dataset_url_path,
    dataset_id = file.path("cida.usgs.gov/TTU_2019", ds_lower),
    dataset_meta_location = paste0(file.path("metadata/TTU_2019", ds_lower), ".ncml"),
    dataset_title = ds,
    start_time = meta$start_time,
    end_time = meta$end_time,
    note = meta$note,
    thredds_url = file.path('https://cida-test.er.usgs.gov/thredds/dodsC/', dataset_url_path),
    service_id = paste('OPeNDAP', i, sep = "_"))
  i <- i + 1
  meta[['attribute_description']] <- list(ddx_description = meta$attribute_description[[2]],
                                          ddx_url = meta$attribute_description[[1]])
}
meta$datasets <- datasets
catalog_out <- whisker::whisker.render(catalog_template, meta)
cat(catalog_out, file = "TTU_catalog_section.xml")

#Drop station data for Sciencebase ISO XML, since GDP can't handle it
meta$datasets <- meta$datasets[1:4]
iso_out <- whisker::whisker.render(sb_iso_template, meta)
cat(iso_out, file = paste0(meta$sciencebase_id, ".xml"))




# meta <- yaml::read_yaml('config_meta.yaml')
# meta <- meta[!unlist(lapply(meta, is.null))]
# meta[['lat_size']] <- meta$lat_max - meta$lat_min
# meta[['lon_size']] <- meta$lon_max - meta$lon_min
# meta[['datasets']] <- list(
#   dataset_name = meta$title,
#   dataset_url_path = 'red_river_2018',
#   dataset_id = "cida.usgs.gov/red_river_2018",
#   dataset_meta_location = "metadata/red_river_2018/red_river.ncml",
#   dataset_title = meta$title,
#   start_time = meta$start_time,
#   end_time = meta$end_time,
#   thredds_url = 'https://cida.usgs.gov/thredds/dodsC/red_river_2018',
#   service_id = 'OPeNDAP_1')
# meta[['attribute_description']] <- list(ddx_description = meta$attribute_description[[2]],
#                                         ddx_url = meta$attribute_description[[1]])
# 
# catalog_out <- whisker::whisker.render(catalog_template, meta)
# cat(catalog_out, file = "red_river_catalog_section.xml")
# 
# 
# 
# iso_out <- whisker::whisker.render(sb_iso_template, meta)
# cat(iso_out, file = paste0(meta$sciencebase_id, ".xml"))
