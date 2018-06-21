meta <- yaml::read_yaml('config_meta.yaml')
template <- readLines('thredds_config_ncml_template.ncml')

meta[['location']] <- '/mnt/morethredds/notaro_2018/join_union_CNRM_1980_1990.ncml'
meta <- meta[!unlist(lapply(meta, is.null))]

out <- whisker::whisker.render(template, meta)
cat(out, file = "thredds_config/notaro_2018_CNRM_1980.cnml")
file.copy(from = "thredds_config/notaro_2018_CNRM_1980.cnml", 
          "~/Documents/R/thredds-config/content/thredds/metadata/notaro_2018/notaro_2018_CNRM_1980.cnml")