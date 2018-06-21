#!/usr/bin/python

'''*******************************************************************************************************
Program: compress.py

Synopsis:
A python script that kicks off a compression script for the macav2metdata dataset. Compressions are
completed using the following conversions:

Note: This script relies on a bash script, compress.sh in a bin folder that is in the execution directory.
Seems to need to run in a clean directory, or else directory creation starts recursing?
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
    if os.access(dest, os.F_OK):
	pass
    else:
	os.mkdir(dest)
    if os.access(PROC_DIR, os.F_OK):
	pass
    else:
	os.mkdir(PROC_DIR)

    for dirname, dirnames, filenames in os.walk(src):
        for filename in filenames:
            # print dest+dirname[len(src):len(dirname)]+'/'+filename
           srcfiles.append([dirname, filename])
           files=files+1

    files_to_process = len(srcfiles)
    processes = []
    pause_time=10
    file_processing = 1
    #['file matching string', 'variable name', 'scaler', 'netCDF scale_factor attribute', 'new noData value', 'unscaled new noData value']
    inputs = [["CLIQLO_d03_WRF_EXTRACT_CESM","CLIQLO_d03_WRF_EXTRACT_CESM","100000","0.00001","foo","foo"],
["CLIQLO_d03_WRF_EXTRACT_CNRM","CLIQLO_d03_WRF_EXTRACT_CNRM","100000","0.00001","foo","foo"],
["Z700_d02_WRF_EXTRACT_CESM","Z700_d02_WRF_EXTRACT_CESM","100000","0.00001","foo","foo"],
["Z700_d02_WRF_EXTRACT_CNRM","Z700_d02_WRF_EXTRACT_CNRM","100000","0.00001","foo","foo"]] 
#[["LWDNBC_d03_WRF_EXTRACT_CNRM","LWDNBC_d03_WRF_EXTRACT_CNRM","1","1","foo","foo"]]


    for srcfile in srcfiles:
        for input_keys in inputs:
	    print srcfile[1]
            if input_keys[0] in srcfile[1]:
                var=input_keys[1]
                scale=input_keys[2]
                scale_factor=input_keys[3]
                missing=input_keys[4]
                unsMissing=input_keys[5]
                command=shlex.split('/Volumes/TB12RAID/PuertoRico/scalingScripts/bin/compress_32bit.sh '+var+' '+scale+' '+scale_factor+' '+missing+' '+unsMissing+' '+srcfile[1]+' '+srcfile[0]+' '+PROC_DIR+srcfile[0][len(src):len(srcfile[0])]+' '+dest+srcfile[0][len(src):len(srcfile[0])])
                print str(file_processing)+ ' of ' + str(files_to_process)
                file_processing+=1
                print command
                processes.append(subprocess.Popen(command))
                if len(processes) < max_processes:
                    time.sleep(pause_time)
                while len(processes) >= max_processes:
                    time.sleep(pause_time*2)
                    processes = [proc for proc in processes if proc.poll() is None]
    
    while len(processes) > 0:
        time.sleep(pause_time)
        processes = [proc for proc in processes if proc.poll() is None]
