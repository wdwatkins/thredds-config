Processing steps

1. compressed naively, removed unneeded dims from lat/lon file
  - compress*.sh
  
2. Added coordinate attributes
  - set_coordinate_atts.sh
  
3. Added integer time variable to each file
  - write_times_each_year.R generates separate netcdf files with the time 
  var
  - add_time_var.sh adds the new time vars into the existing files, renames the existing character time variable.  The character time variable isn't CF compliant, and the joins across time wouldn't work.  