template <- readLines('attribute_template.txt')
vars <- scan('/Volumes/RAID0/red_river/compress/var.txt', what = "character")

out <- whisker::whisker.render(template = template)
cat(out, file = "var_atts.ncml")
