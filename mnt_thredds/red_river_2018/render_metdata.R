library(whisker)
rm(list=ls())
catalog_template <- readLines('../notaro/catalog_dataset_template.xml')
thredds_ncml_template <- readLines('../notaro/thredds_config_ncml_template.ncml')
sb_iso_template <- readLines('../notaro/iso_template.xml')


meta <- yaml::read_yaml('config_meta.yaml')
meta <- meta[!unlist(lapply(meta, is.null))]
meta[['lat_size']] <- meta$lat_max - meta$lat_min
meta[['lon_size']] <- meta$lon_max - meta$lon_min
meta[['datasets']] <- list(
  dataset_name = meta$title,
  dataset_url_path = 'red_river_2018',
  dataset_id = "cida.usgs.gov/red_river_2018",
  dataset_meta_location = "metadata/red_river_2018/red_river.ncml",
  dataset_title = meta$title,
  start_time = meta$start_time,
  end_time = meta$end_time,
  thredds_url = 'https://cida.usgs.gov/thredds/dodsC/red_river_2018',
  service_id = 'OPeNDAP_1')
meta[['attribute_description']] <- list(ddx_description = meta$attribute_description[[2]],
                                        ddx_url = meta$attribute_description[[1]])

catalog_out <- whisker::whisker.render(catalog_template, meta)
cat(catalog_out, file = "red_river_catalog_section.xml")

ncml_out <- whisker::whisker.render(thredds_ncml_template, meta)
ncml_path <- "~/Documents/nonR/thredds-config/content/thredds/metadata/red_river_2018/red_river.ncml"
cat(ncml_out, file=ncml_path)

iso_out <- whisker::whisker.render(sb_iso_template, meta)
cat(iso_out, file = paste0(meta$sciencebase_id, ".xml"))
