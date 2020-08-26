#!/bin/bash

#first delete extra two years at end
ncks -dtime,0,350620 CLA_hrly.nc CLA_removed_2_1999_at_end.nc

#time chunks come from check_time_duplicates.R run on CLA_removed_2_1999_at_end.nc (output of above line)
ncks -d time,0,8759 -d time,8761,17520 -d time,17522,35065 -d time,35067,43826 -d time,43828,52587 -d time,52589,70132 -d time,70134,78893 -d time,78895,87654 -d time,87656,105199 -d time,105201,113960 -d time,113962,122721 -d time,122723,140266 -d time,140268,149027 -d time,149029,157788 -d time,157790,184069 -d time,184071,192830 -d time,192832,201591 -d time,201593,219136 -d time,219138,227897 -d time,227899,236658 -d time,236660,254203 -d time,254205,262964 -d time,262966,271725 -d time,271727,289270 -d time,289272,298031 -d time,298033,306792 -d time,306794,324337 -d time,324339,333098 -d time,333100,341859 -d time,341861,350620 CLA_removed_2_1999_at_end.nc no_duplicate_times/CLA_hrly.nc
