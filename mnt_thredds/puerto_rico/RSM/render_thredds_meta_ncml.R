rm(list=ls())
meta <- yaml::read_yaml('config_meta.yaml')
meta <- meta[!unlist(lapply(meta, is.null))]
ncml_template <- readLines('thredds_config_ncml_template.ncml')
catalog_template <- readLines('catalog_dataset_template.xml')
meta[['lat_size']] <- meta$lat_max - meta$lat_min
meta[['lon_size']] <- meta$lon_max - meta$lon_min

models <- c("NHM", "RSM")
gcms <- c("CCSM4", "GFDL")
datasets <- list()
i <- 1
for(m in models) {
  if(m == "NHM") {
    resolutions <- c("hourly", "daily", "monthly")
    data_ncml_template <- readLines('nhm_data_template.ncml')
  } else if(m == "RSM") {
    resolutions <- c("daily")
    data_ncml_template <- readLines('rsm_data_template.ncml')
  }
  for(res in resolutions) {
    for(g in gcms) {
      if(m == "NHM") {
        lower_ncml <- paste0(g, "_", toupper(res), ".ncml")
      } else if(m == "RSM") {
        lower_ncml <- NULL
      }
      meta[['location']] <- paste0(paste('/mnt/thredds/PuertoRico/FSU/pr', m, 
                                  g, res, sep = "_"), ".ncml")
      out <- whisker::whisker.render(ncml_template, meta)
      ncml_path <- paste0("~/Documents/nonR/thredds-config/content/thredds/metadata/PuertoRico/FSU/",
                          m,"_", g, "_", res,".ncml")
      cat(out, file=ncml_path)
      #add to meta for catalog.xml section
      dataset_url_path <-  paste("puerto_rico", m,g,res, sep = "_")
      datasets[[i]] <- list(
        dataset_name = paste(m,g,res),
        dataset_url_path = dataset_url_path,
        dataset_id = file.path("cida.usgs.gov", dataset_url_path),
        dataset_meta_location = file.path("metadata/PuertoRico/FSU", basename(ncml_path)))
      i <- i + 1
      # write out ncml that goes next to data
      data_path <- paste(file.path(m,g,res), lower_ncml, sep ="/")
      out <- whisker::whisker.render(data_ncml_template, list(data_path=data_path))
      cat(out, file=paste0(paste("pr", m,g,res, sep="_"), ".ncml"))
    }
  }
}
meta[['datasets']] <- datasets
catalog_out <- whisker::whisker.render(catalog_template, meta)
cat(catalog_out, file = "fsu_pr_catalog_section.xml")
