rm(list=ls())
meta <- yaml::read_yaml('metadata/config_meta.yaml')
meta <- meta[!unlist(lapply(meta, is.null))]
ncml_template <- readLines('../notaro/thredds_config_ncml_template.ncml')
catalog_template <- readLines('../notaro/catalog_dataset_template.xml')
iso_template <- readLines('../notaro/iso_template.xml')
meta[['lat_size']] <- meta$lat_max - meta$lat_min
meta[['lon_size']] <- meta$lon_max - meta$lon_min
meta[['data_type']] <- "Grid"
islands <- c("Hawaii", "Maui")
gcms <- c("Present", "RCP45", "RCP85")

datasets <- list()
i <- 1
for(g in gcms) {
  for(island in islands){
    meta[['location']] <- paste0('/mnt/thredds/hawaii_2018/', g, "_", 
                                tolower(island), '.ncml')
    out <- whisker::whisker.render(ncml_template, meta)
    ncml_path <- paste0("~/Documents/nonR/thredds-config/content/thredds/metadata/hawaii_2018/",
                             island, "_", g,".ncml")
    cat(out, file=ncml_path)
    #add to meta for catalog.xml section
    dataset_url_path <-  tolower(paste("hawaii", island, g, sep = "_"))
    if(g == "Present") {g_name <- "Present Day"} else { g_name <- g}
    dataset_name <-  paste(island, g_name)
    service_id <- paste("OPeNDAP", island, g, sep = "_")
    thredds_url <- paste("https://cida-test.er.usgs.gov/thredds/dodsC/hawaii",
                         tolower(island), tolower(g), sep = "_")
    datasets[[i]] <- list(
      dataset_name = dataset_name,
      dataset_title = dataset_name,
      dataset_url_path = dataset_url_path,
      dataset_id = file.path("cida.usgs.gov", dataset_url_path),
      dataset_meta_location = file.path("metadata/hawaii_2018", basename(ncml_path)),
      start_time = meta$start_time,
      end_time = meta$end_time,
      thredds_url = thredds_url,
      service_id = service_id,
      data_type = "Grid")
    i <- i + 1
  }
}
meta[['datasets']] <- datasets
catalog_out <- whisker::whisker.render(catalog_template, meta)
cat(catalog_out, file = "hawaii_catalog_section.xml")
iso_out <- whisker::whisker.render(iso_template, meta)
cat(iso_out, file = paste0(meta$sciencebase_id, ".xml"))
