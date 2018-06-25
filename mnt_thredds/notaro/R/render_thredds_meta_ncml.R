meta <- yaml::read_yaml('config_meta.yaml')
template <- readLines('thredds_config_ncml_template.ncml')

meta[['location']] <- '/mnt/thredds/notaro_2018/join_union_CNRM_1980_1990.ncml'
meta <- meta[!unlist(lapply(meta, is.null))]

out <- whisker::whisker.render(template, meta)
cat(out, file = "thredds_config/notaro_2018_CNRM_1980.ncml")
file.copy(from = "thredds_config/notaro_2018_CNRM_1980.ncml", 
          "~/Documents/nonR/thredds-config/content/thredds/metadata/notaro_2018/notaro_2018_CNRM_1980.ncml")

#now catalog.xml section
catalog_template <- readLines('../../content/thredds/catalog_dataset_template.xml')
meta[['lat_size']] <- meta$lat_max - meta$lat_min
meta[['lon_size']] <- meta$lon_max - meta$lon_min
meta[['datasets']] <- list(
  dataset_name = "CNRM 1980-1999",
  dataset_url_path = "notaro_CNRM_1980_1999",
  dataset_id = "cida.usgs.gov/notaro_CNRM_1980_1999",
  dataset_meta_location = "metadata/notaro_2018/notaro_2018_CNRM_1980.ncml")
catalog_out <- whisker::whisker.render(catalog_template, meta)
cat(catalog_out, file = "notaro_catalog_section.xml")
