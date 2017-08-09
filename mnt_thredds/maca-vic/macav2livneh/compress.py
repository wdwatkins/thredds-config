#!/usr/bin/python

'''*******************************************************************************************************
Program: compress.py

Synopsis:
A python script that kicks off a compression script for the macav2Livneh dataset. Compressions are
completed using the following conversions:

#['file matching string', 'variable name', 'scaler', 'netCDF scale_factor attribute', 'new noData value']
[['_pr_','precipitation','10','0.1','-999'], # -3276.8 to 32767 mm/d or mm/month
['_tasmax_','air_temperature','100','0.01','-99.9'], # -327.68 to 327.67 deg C
['_tasmin_','air_temperature','100','0.01','-99.9'], # -327.68 to 327.67 deg C
['_was_','wind_speed','100','0.01','-99.9'], #  -327.68 to 327.67 m/s
['_vas_','northward_wind','100','0.01','-99.9'], #  -327.68 to 327.67 m/s
['_uas_','eastward_wind','100','0.01','-99.9'], #  -327.68 to 327.67 m/s
['_rsds_','surface_downwelling_shortwave_flux_in_air','100','0.01','-99.9'], # -327.68 to 327.67 W/m^2
['_rhsmin_','relative_humidity','100','0.01','-99.9'], # -327.68 to 327.67 %
['_rhsmax_','relative_humidity','100','0.01','-99.9'], # -327.68 to 327.67 %
['_huss_','specific_humidity','1000000','0.000001','-.00999']] # -0.032768 to 0.032767 kg/kg

Note: This script relies on a bash script, compress.sh in a bin folder that is in the execution directory.

Usage: ./compress.py [args]

Arguments:
sourceDir		-	Directory of source files.
procDir		    -	Directory to write temporary processing files to.
dest		    -	Directory to write results to.
maxProcesses	-	The number of concurrent processes to run.

*******************************************************************************************************'''

import os
import subprocess
import time
import shlex
import argparse

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('sourceDir', type=str)
    parser.add_argument('procDir', type=str)
    parser.add_argument('dest', type=str)
    parser.add_argument('maxProcesses', type=int)
    args = parser.parse_args()
    src = args.sourceDir
    PROC_DIR = args.procDir
    dest = args.dest
    max_processes = args.maxProcesses
    dirs=0
    files=0
    srcfiles=[ ]
    for dirname, dirnames, filenames in os.walk(src):
        for subdirname in dirnames:
            srcdir = os.path.join(dirname, subdirname)
            destdir=dest+srcdir[len(src):len(srcdir)]
            procdir=PROC_DIR+srcdir[len(src):len(srcdir)]
            if os.access(destdir,os.F_OK):
                pass
            else:
                os.mkdir(destdir)
                print 'made '+destdir
            if os.access(procdir,os.F_OK):
                pass
            else:
                os.mkdir(procdir)
                print 'made '+procdir
        for filename in filenames:
            print dest+dirname[len(src):len(dirname)]+'/'+filename
            if os.path.isfile(dest+dirname[len(src):len(dirname)]+'/'+filename):
                print 'passed'
            else:
                srcfiles.append([dirname, filename])
                files=files+1

    files_to_process = len(srcfiles)
    processes = []
    pause_time=2
    file_processing = 1
    #['file matching string', 'variable name', 'scaler', 'netCDF scale_factor attribute', 'new noData value']
    inputs = [['_pr_','precipitation','10','0.1','-999'], # -3276.8 to 32767 mm/d or mm/month
              ['_tasmax_','air_temperature','100','0.01','-99.9'], # -327.68 to 327.67 deg C
              ['_tasmin_','air_temperature','100','0.01','-99.9'], # -327.68 to 327.67 deg C
              ['_was_','wind_speed','100','0.01','-99.9'], #  -327.68 to 327.67 m/s
              ['_vas_','northward_wind','100','0.01','-99.9'], #  -327.68 to 327.67 m/s
              ['_uas_','eastward_wind','100','0.01','-99.9'], #  -327.68 to 327.67 m/s
              ['_rsds_','surface_downwelling_shortwave_flux_in_air','100','0.01','-99.9'], # -327.68 to 327.67 W/m^2
              ['_rhsmin_','relative_humidity','100','0.01','-99.9'], # -327.68 to 327.67 %
              ['_rhsmax_','relative_humidity','100','0.01','-99.9'], # -327.68 to 327.67 %
              ['_huss_','specific_humidity','1000000','0.000001','-.00999']] # -0.032768 to 0.032767 kg/kg
    for srcfile in srcfiles:
        for input_keys in inputs:
            if input_keys[0] in srcfile[1]:
                var=input_keys[1]
                scale=input_keys[2]
                scale_factor=input_keys[3]
                missing=input_keys[4]
        command_string='./bin/compress.sh '+var+' '+scale+' '+scale_factor+' '+missing+' '+srcfile[1]+' '+srcfile[0]+' '+PROC_DIR+srcfile[0][len(src):len(srcfile[0])]+' '+dest+srcfile[0][len(src):len(srcfile[0])]
        print command_string
        command=shlex.split(command_string)
        print str(file_processing)+ ' of ' + str(files_to_process)
        file_processing+=1
        processes.append(subprocess.Popen(command))
        if len(processes) < max_processes:
            time.sleep(pause_time)
        while len(processes) >= max_processes:
            time.sleep(pause_time*2)
            processes = [proc for proc in processes if proc.poll() is None]

    while len(processes) > 0:
        time.sleep(pause_time)
        processes = [proc for proc in processes if proc.poll() is None]