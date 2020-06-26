#!/bin/bash
#SBATCH -A iidd
#SBATCH -c 1
#SBATCH -p normal
#SBATCH --time=08:00:00
#SBATCH --array=5-297%4
#SBATCH –mail-user=wwatkins@usgs.gov
#SBATCH --mail-type=ALL
#SBATCH --mem-per-cpu=32GB
#SBATCH -o wooten_compress.out
#SBATCH --export=ALL
#SBATCH --job-name=compress_wooten_files

module load legacy 
module load tools/nco-4.7.8-gnu

#read appropriate line from files.txt, assign to $f
file=$(sed "${SLURM_ARRAY_TASK_ID}q;d" all_files.txt)
echo $file
file_basename=$(basename $file) 
start=$SECONDS
ncks -4 --cnk_plc=nco --cnk_map='rew' -L1 --fix_rec_dmn=time  $file compress/$file_basename
duration=$(( SECONDS - start ))
echo $file_basename done in $duration

