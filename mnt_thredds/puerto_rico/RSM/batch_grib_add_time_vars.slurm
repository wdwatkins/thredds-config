#!/bin/bash
#SBATCH --job-name=grib_add_times     # name that you chose
#SBATCH -p normal             # the partition you want to use, for this case prod is best
#SBATCH -A cida                 # your account
#SBATCH -o shellLog/slurm-%A_%a.out
#SBATCH --time=00:60:00        # time at which the process will be cancelled if unfinished
#SBATCH --mail-type=ALL
#SBATCH --mail-user=wwatkins@usgs.gov
#SBATCH --export=ALL
#SBATCH --array=20,24%7        # process IDs 
#SBATCH -n 1
set -x
module load tools/netcdf-4.3.2-gnu
module load tools/nco-4.4.4-gnu
cd /cxfs/projects/usgs/water/iidd/data-sci/pr_grib/CCSM4
year_folders=($(ls))
current_year_folder=${year_folders[${SLURM_ARRAY_TASK_ID}]}
current_year=$(echo $current_year_folder | cut -f1 -d_)
time_origin=$(echo hours since "$current_year"-01-01 00:00:00) 
#var_rename_statement=$(cat ~/thredds-config/mnt_thredds/puerto_rico/RSM/vars_rename_statement.txt)
mkdir -p withTime/"$current_year_folder"
mkdir -p withTimeRecord/"$current_year_folder"
for f in "$current_year_folder"/*.nc;
do
	#check for ave*h or _10
	#if either, remove those
  #need to generate rename statement on the fly?
	ncdump -h $f | grep float | cut -d"(" -f1 | cut -d" " -f2 | grep  -E 'ave|_10' > "$current_year_folder"/vars_to_rename.txt
	num_vars_rename=$(cat "$current_year_folder"/vars_to_rename.txt | wc -l)
	if [[ $num_vars_rename -eq 41 ]]
	then #do variable renaming
	  cat "$current_year_folder"/vars_to_rename.txt | rev | cut -d_ -f2- | rev > "$current_year_folder"/renamed_vars.txt 
		var_rename_statement=$(paste "$current_year_folder"/vars_to_rename.txt "$current_year_folder"/renamed_vars.txt | awk '{print "-v",$1","$2}' | sed 's/\\//g' | tr '\n' ' ')
		ncrename $var_rename_statement $f
	elif [[ $num_vars_rename -eq 0 ]]
	then #skip to after this
		:
	else #ERROR
		echo "Unexpected number of float variables to rename; failing" 1>&2
		exit 1 
	fi
	
	#add time dim/var, with needed attributes
	hour_val=$(basename $f | cut -d. -f1 | sed s/r_pgb//g)
	
	#add attributes
	#ncecat then ncrcat
	ncap2 -s "hour=${hour_val};" -s ' defdim("time",1);time[time]=hour; time@long_name="Time"; time@calendar="standard"; time@_CoordinateAxisType="Time"; time@standard_name="time"' -O $f withTime/$f
	ncecat -utime withTime/$f withTimeRecord/$f
	ncatted -a units,time,o,c,"$time_origin" withTimeRecord/$f
  #pad hour in file name with leading zeros so the files will order correctly
	padded_hour=$(printf "%04d" $hour_val)
	final_dir=$(dirname withTimeRecord/$f)
	final_name=$(echo r_pgb"$padded_hour".nc)
	mv withTimeRecord/$f $final_dir/$final_name
	echo $f
done
mkdir -p final_cat
ncrcat $final_dir/* final_cat/"grib_ccsm4_"$current_year".nc"


