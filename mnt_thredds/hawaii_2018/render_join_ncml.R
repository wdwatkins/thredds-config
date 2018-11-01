scenarios <- c("RCP45", "RCP85", "PRESENTDAY")
islands <- c("maui","hawaii")
template <- readLines('join_template.ncml')
for(scenario in scenarios) {
  for(island in islands) {
    out <- whisker::whisker.render(template)
    cat(out, file = file.path("/Volumes/RAID0/hawaii/upload",
                              paste0(scenario, "_", island, ".ncml")))
  }
}