library(whisker)
rm(list=ls())
template <- readLines('../notaro/iso_template.xml')
meta <- yaml::read_yaml('config_meta.yaml')
names(meta)

islands <- c("Hawaii", "Maui")
gcms <- c("Present", "RCP45", "RCP85")
datasets <- list()
i <- 1
for(g in gcms) {
  for(y in year_chunks){
    y_underscores <- sub(pattern = "-", replacement = "_", x = y)
    dataset_title <- paste(g,y)
    service_id <- paste("OPeNDAP", g, y_underscores, sep = "_")
    thredds_url <- paste("https://cida.usgs.gov/thredds/dodsC/notaro",
                          g, y_underscores,
                          sep = "_")
    datasets[[i]] <- list(dataset_title = dataset_title,
                          start_time = start_time,
                          end_time = end_time,
                          thredds_url = thredds_url,
                          service_id = service_id)
    i <- i + 1
  }
}
meta$datasets <- datasets
out <- whisker.render(template, meta)
cat(out, file = paste0(meta$sciencebase_id, ".xml"))