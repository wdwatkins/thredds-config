scenarios <- c("RCP45", "RCP85", "PRESENTDAY")
islands <- c("maui","hawaii")
template <- readLines('join_template.ncml')
variables <- scan('variables.txt', what = "character")
for(scenario in scenarios) {
  for(island in islands) {
    out <- whisker::whisker.render(template)
    cat(out, file = paste0(scenario, "_", island, ".ncml"))
  }
}