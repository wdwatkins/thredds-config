rm(list=ls())
meta <- yaml::read_yaml('config_meta.yaml')
meta <- meta[!unlist(lapply(meta, is.null))]
ncml_template <- readLines('thredds_config_ncml_template.ncml')
catalog_template <- readLines('catalog_dataset_template.xml')
meta[['lat_size']] <- meta$lat_max - meta$lat_min
meta[['lon_size']] <- meta$lon_max - meta$lon_min

year_chunks <- c("1980-1999", "2040-2059", "2080-2099")
gcms <- c("ACCESS", "CNRM", "GFDL", "IPSL", "MIROC", "MRI")
datasets <- list()
i <- 1
for(g in gcms) {
  for(y in year_chunks){
    y_underscores <- sub(pattern = "-", replacement = "_", x = y)
    meta[['location']] <- paste('/mnt/thredds/notaro_2018/join_union', g, 
                                paste0(y_underscores, '.ncml'), sep = "_")
    out <- whisker::whisker.render(ncml_template, meta)
    first_year <- strsplit(y, "-")[[1]][1]
    ncml_path <- file=paste0("~/Documents/nonR/thredds-config/content/thredds/metadata/notaro_2018/",
                             "notaro_2018_", g, "_", y_underscores, ".ncml")
    cat(out, file=ncml_path)
    #add to meta for catalog.xml section
    datasets[[i]] <- list(
      dataset_name = paste(g, y),
      dataset_url_path = paste("notaro", g, y_underscores, sep = "_"),
      dataset_id = file.path("cida.usgs.gov", dataset_url_path),
      dataset_meta_location = file.path("metadata/notaro_2018", basename(ncml_path)))
    i <- i + 1
  }
}
meta[[datasets]] <- datasets

catalog_out <- whisker::whisker.render(catalog_template, meta)
cat(catalog_out, file = "notaro_catalog_section.xml")
