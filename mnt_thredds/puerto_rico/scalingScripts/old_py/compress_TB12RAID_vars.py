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
    print "sourcefiles"
    #print srcfiles
    processes = []
    pause_time=10
    file_processing = 1
    #['file matching string', 'variable name', 'scaler', 'netCDF scale_factor attribute', 'new noData value', 'unscaled new noData value']
    inputs = [["CDD_d01_monthly_CESM","CDD_d01_monthly_CESM","10","0.1","foo","foo"],
["CDD_d01_monthly_CNRM","CDD_d01_monthly_CNRM","10","0.1","foo","foo"],
["CDD_d02_monthly_CESM","CDD_d02_monthly_CESM","10","0.1","foo","foo"],
["CDD_d02_monthly_CNRM","CDD_d02_monthly_CNRM","10","0.1","foo","foo"],
["CDD_d03_monthly_CESM","CDD_d03_monthly_CESM","10","0.1","foo","foo"],
["CDD_d03_monthly_CNRM","CDD_d03_monthly_CNRM","10","0.1","foo","foo"],
["CICELO_d01_WRF_EXTRACT_CESM","CICELO_d01_WRF_EXTRACT_CESM","100","0.01","foo","foo"],
["CICELO_d01_WRF_EXTRACT_CNRM","CICELO_d01_WRF_EXTRACT_CNRM","100","0.01","foo","foo"],
["CLDFLO_d01_WRF_EXTRACT_CESM","CLDFLO_d01_WRF_EXTRACT_CESM","10000","0.0001","foo","foo"],
["CLDFLO_d01_WRF_EXTRACT_CNRM","CLDFLO_d01_WRF_EXTRACT_CNRM","10000","0.0001","foo","foo"],
["CLDFRA700_d01_WRF_EXTRACT_CESM","CLDFRA700_d01_WRF_EXTRACT_CESM","10000","0.0001","foo","foo"],
["CLDFRA700_d01_WRF_EXTRACT_CNRM","CLDFRA700_d01_WRF_EXTRACT_CNRM","10000","0.0001","foo","foo"],
["CLDFRA850_d01_WRF_EXTRACT_CESM","CLDFRA850_d01_WRF_EXTRACT_CESM","10000","0.0001","foo","foo"],
["CLDFRA850_d01_WRF_EXTRACT_CNRM","CLDFRA850_d01_WRF_EXTRACT_CNRM","10000","0.0001","foo","foo"],
["CLIQLO_d01_WRF_EXTRACT_CESM","CLIQLO_d01_WRF_EXTRACT_CESM","10","0.1","foo","foo"],
["CLIQLO_d01_WRF_EXTRACT_CNRM","CLIQLO_d01_WRF_EXTRACT_CNRM","10","0.1","foo","foo"],
["DP01_d01_monthly_CESM","DP01_d01_monthly_CESM","1000","0.001","foo","foo"],
["DP01_d01_monthly_CNRM","DP01_d01_monthly_CNRM","1000","0.001","foo","foo"],
["DP01_d02_monthly_CESM","DP01_d02_monthly_CESM","1000","0.001","foo","foo"],
["DP01_d02_monthly_CNRM","DP01_d02_monthly_CNRM","1000","0.001","foo","foo"],
["DP01_d03_monthly_CESM","DP01_d03_monthly_CESM","1000","0.001","foo","foo"],
["DP01_d03_monthly_CNRM","DP01_d03_monthly_CNRM","1000","0.001","foo","foo"],
["DP05_d01_monthly_CESM","DP05_d01_monthly_CESM","1000","0.001","foo","foo"],
["DP05_d01_monthly_CNRM","DP05_d01_monthly_CNRM","1000","0.001","foo","foo"],
["DP05_d02_monthly_CESM","DP05_d02_monthly_CESM","1000","0.001","foo","foo"],
["DP05_d02_monthly_CNRM","DP05_d02_monthly_CNRM","1000","0.001","foo","foo"],
["DP05_d03_monthly_CESM","DP05_d03_monthly_CESM","1000","0.001","foo","foo"],
["DP05_d03_monthly_CNRM","DP05_d03_monthly_CNRM","1000","0.001","foo","foo"],
["DP10_d01_monthly_CESM","DP10_d01_monthly_CESM","1000","0.001","foo","foo"],
["DP10_d01_monthly_CNRM","DP10_d01_monthly_CNRM","1000","0.001","foo","foo"],
["DP10_d02_monthly_CESM","DP10_d02_monthly_CESM","1000","0.001","foo","foo"],
["DP10_d02_monthly_CNRM","DP10_d02_monthly_CNRM","1000","0.001","foo","foo"],
["DP10_d03_monthly_CESM","DP10_d03_monthly_CESM","1000","0.001","foo","foo"],
["DP10_d03_monthly_CNRM","DP10_d03_monthly_CNRM","1000","0.001","foo","foo"],
["DT00_d01_monthly_CESM","DT00_d01_monthly_CESM","100000000","0.00000001","foo","foo"],
["DT00_d01_monthly_CNRM","DT00_d01_monthly_CNRM","100000000","0.00000001","foo","foo"],
["DT00_d02_monthly_CESM","DT00_d02_monthly_CESM","100000000","0.00000001","foo","foo"],
["DT00_d02_monthly_CNRM","DT00_d02_monthly_CNRM","100000000","0.00000001","foo","foo"],
["DT00_d03_monthly_CESM","DT00_d03_monthly_CESM","100000000","0.00000001","foo","foo"],
["DT00_d03_monthly_CNRM","DT00_d03_monthly_CNRM","100000000","0.00000001","foo","foo"],
["DT32_d01_monthly_CESM","DT32_d01_monthly_CESM","1000","0.001","foo","foo"],
["DT32_d01_monthly_CNRM","DT32_d01_monthly_CNRM","1000","0.001","foo","foo"],
["DT32_d02_monthly_CESM","DT32_d02_monthly_CESM","100000000","0.00000001","foo","foo"],
["DT32_d02_monthly_CNRM","DT32_d02_monthly_CNRM","100000000","0.00000001","foo","foo"],
["DT32_d03_monthly_CESM","DT32_d03_monthly_CESM","100000000","0.00000001","foo","foo"],
["DT32_d03_monthly_CNRM","DT32_d03_monthly_CNRM","100000000","0.00000001","foo","foo"],
["DT90_d01_monthly_CESM","DT90_d01_monthly_CESM","1000","0.001","foo","foo"],
["DT90_d01_monthly_CNRM","DT90_d01_monthly_CNRM","1000","0.001","foo","foo"],
["DT90_d02_monthly_CESM","DT90_d02_monthly_CESM","1000","0.001","foo","foo"],
["DT90_d02_monthly_CNRM","DT90_d02_monthly_CNRM","1000","0.001","foo","foo"],
["DT90_d03_monthly_CESM","DT90_d03_monthly_CESM","1000","0.001","foo","foo"],
["DT90_d03_monthly_CNRM","DT90_d03_monthly_CNRM","1000","0.001","foo","foo"],
["DX32_d01_monthly_CESM","DX32_d01_monthly_CESM","10000","0.0001","foo","foo"],
["DX32_d01_monthly_CNRM","DX32_d01_monthly_CNRM","100000000","0.00000001","foo","foo"],
["DX32_d02_monthly_CESM","DX32_d02_monthly_CESM","100000000","0.00000001","foo","foo"],
["DX32_d02_monthly_CNRM","DX32_d02_monthly_CNRM","100000000","0.00000001","foo","foo"],
["DX32_d03_monthly_CESM","DX32_d03_monthly_CESM","100000000","0.00000001","foo","foo"],
["DX32_d03_monthly_CNRM","DX32_d03_monthly_CNRM","100000000","0.00000001","foo","foo"],
["HDD_d01_monthly_CESM","HDD_d01_monthly_CESM","10","0.1","foo","foo"],
["HDD_d01_monthly_CNRM","HDD_d01_monthly_CNRM","10","0.1","foo","foo"],
["HDD_d02_monthly_CESM","HDD_d02_monthly_CESM","100","0.01","foo","foo"],
["HDD_d02_monthly_CNRM","HDD_d02_monthly_CNRM","100","0.01","foo","foo"],
["HDD_d03_monthly_CESM","HDD_d03_monthly_CESM","100","0.01","foo","foo"],
["HDD_d03_monthly_CNRM","HDD_d03_monthly_CNRM","100","0.01","foo","foo"],
["HFX_d01_WRF_EXTRACT_CESM","HFX_d01_WRF_EXTRACT_CESM","10","0.1","foo","foo"],
["HFX_d01_WRF_EXTRACT_CNRM","HFX_d01_WRF_EXTRACT_CNRM","10","0.1","foo","foo"],
["KECOLAVG_d01_monthly_CESM","KECOLAVG_d01_monthly_CESM","100","0.01","foo","foo"],
["KECOLAVG_d01_monthly_CNRM","KECOLAVG_d01_monthly_CNRM","100","0.01","foo","foo"],
["KECOLAVG_d02_monthly_CESM","KECOLAVG_d02_monthly_CESM","100","0.01","foo","foo"],
["KECOLAVG_d02_monthly_CNRM","KECOLAVG_d02_monthly_CNRM","100","0.01","foo","foo"],
["KECOLAVG_d03_monthly_CESM","KECOLAVG_d03_monthly_CESM","1000","0.001","foo","foo"],
["KECOLAVG_d03_monthly_CNRM","KECOLAVG_d03_monthly_CNRM","1000","0.001","foo","foo"],
["LH_d01_WRF_EXTRACT_CESM","LH_d01_WRF_EXTRACT_CESM","10","0.1","foo","foo"],
["LH_d01_WRF_EXTRACT_CNRM","LH_d01_WRF_EXTRACT_CNRM","10","0.1","foo","foo"],
["LWDNBC_d01_WRF_EXTRACT_CESM","LWDNBC_d01_WRF_EXTRACT_CESM","10","0.1","foo","foo"],
["LWDNBC_d01_WRF_EXTRACT_CNRM","LWDNBC_d01_WRF_EXTRACT_CNRM","10","0.1","foo","foo"],
["LWDNB_d01_WRF_EXTRACT_CESM","LWDNB_d01_WRF_EXTRACT_CESM","10","0.1","foo","foo"],
["LWDNB_d01_WRF_EXTRACT_CNRM","LWDNB_d01_WRF_EXTRACT_CNRM","10","0.1","foo","foo"],
["LWDNT_d01_WRF_EXTRACT_CESM","LWDNT_d01_WRF_EXTRACT_CESM","1000","0.001","foo","foo"],
["LWDNT_d01_WRF_EXTRACT_CNRM","LWDNT_d01_WRF_EXTRACT_CNRM","1000","0.001","foo","foo"],
["LWUPB_d01_WRF_EXTRACT_CESM","LWUPB_d01_WRF_EXTRACT_CESM","10","0.1","foo","foo"],
["LWUPB_d01_WRF_EXTRACT_CNRM","LWUPB_d01_WRF_EXTRACT_CNRM","10","0.1","foo","foo"],
["LWUPTC_d01_WRF_EXTRACT_CESM","LWUPTC_d01_WRF_EXTRACT_CESM","10","0.1","foo","foo"],
["LWUPTC_d01_WRF_EXTRACT_CNRM","LWUPTC_d01_WRF_EXTRACT_CNRM","10","0.1","foo","foo"],
["LWUPT_d01_WRF_EXTRACT_CESM","LWUPT_d01_WRF_EXTRACT_CESM","10","0.1","foo","foo"],
["LWUPT_d01_WRF_EXTRACT_CNRM","LWUPT_d01_WRF_EXTRACT_CNRM","10","0.1","foo","foo"],
["MDRN_d01_monthly_CESM","MDRN_d01_monthly_CESM","1000","0.001","foo","foo"],
["MDRN_d01_monthly_CNRM","MDRN_d01_monthly_CNRM","1000","0.001","foo","foo"],
["MDRN_d02_monthly_CESM","MDRN_d02_monthly_CESM","1000","0.001","foo","foo"],
["MDRN_d02_monthly_CNRM","MDRN_d02_monthly_CNRM","1000","0.001","foo","foo"],
["MDRN_d03_monthly_CESM","MDRN_d03_monthly_CESM","1000","0.001","foo","foo"],
["MDRN_d03_monthly_CNRM","MDRN_d03_monthly_CNRM","1000","0.001","foo","foo"],
["PBLH_d01_WRF_EXTRACT_CESM","PBLH_d01_WRF_EXTRACT_CESM","1","1","foo","foo"],
["PBLH_d01_WRF_EXTRACT_CNRM","PBLH_d01_WRF_EXTRACT_CNRM","1","1","foo","foo"],
["PRECIP_d01_monthly_CESM","PRECIP_d01_monthly_CESM","1","1","foo","foo"],
["PRECIP_d01_monthly_CNRM","PRECIP_d01_monthly_CNRM","1","1","foo","foo"],
["PRECIP_d02_monthly_CESM","PRECIP_d02_monthly_CESM","10","0.1","foo","foo"],
["PRECIP_d02_monthly_CNRM","PRECIP_d02_monthly_CNRM","10","0.1","foo","foo"],
["PRECIP_d03_monthly_CESM","PRECIP_d03_monthly_CESM","10","0.1","foo","foo"],
["PRECIP_d03_monthly_CNRM","PRECIP_d03_monthly_CNRM","10","0.1","foo","foo"],
["PSFC_d01_WRF_EXTRACT_CESM","PSFC_d01_WRF_EXTRACT_CESM","10","0.1","foo","foo"],
["PSFC_d01_WRF_EXTRACT_CNRM","PSFC_d01_WRF_EXTRACT_CNRM","10","0.1","foo","foo"],
["PWATAVG_d01_monthly_CESM","PWATAVG_d01_monthly_CESM","100","0.01","foo","foo"],
["PWATAVG_d01_monthly_CNRM","PWATAVG_d01_monthly_CNRM","100","0.01","foo","foo"],
["PWATAVG_d02_monthly_CESM","PWATAVG_d02_monthly_CESM","100","0.01","foo","foo"],
["PWATAVG_d02_monthly_CNRM","PWATAVG_d02_monthly_CNRM","100","0.01","foo","foo"],
["PWATAVG_d03_monthly_CESM","PWATAVG_d03_monthly_CESM","100","0.01","foo","foo"],
["PWATAVG_d03_monthly_CNRM","PWATAVG_d03_monthly_CNRM","100","0.01","foo","foo"],
["PWAT_d01_WRF_EXTRACT_CESM","PWAT_d01_WRF_EXTRACT_CESM","100","0.01","foo","foo"],
["PWAT_d01_WRF_EXTRACT_CNRM","PWAT_d01_WRF_EXTRACT_CNRM","100","0.01","foo","foo"],
["Q2_d01_WRF_EXTRACT_CESM","Q2_d01_WRF_EXTRACT_CESM","100000","0.00001","foo","foo"],
["Q2_d01_WRF_EXTRACT_CNRM","Q2_d01_WRF_EXTRACT_CNRM","100000","0.00001","foo","foo"],
["Q700AVG_d01_monthly_CESM","Q700AVG_d01_monthly_CESM","1000000","0.000001","foo","foo"],
["Q700AVG_d01_monthly_CNRM","Q700AVG_d01_monthly_CNRM","1000000","0.000001","foo","foo"],
["Q700AVG_d02_monthly_CESM","Q700AVG_d02_monthly_CESM","1000000","0.000001","foo","foo"],
["Q700AVG_d02_monthly_CNRM","Q700AVG_d02_monthly_CNRM","1000000","0.000001","foo","foo"],
["Q700AVG_d03_monthly_CESM","Q700AVG_d03_monthly_CESM","1000000","0.000001","foo","foo"],
["Q700AVG_d03_monthly_CNRM","Q700AVG_d03_monthly_CNRM","1000000","0.000001","foo","foo"],
["Q700_d01_WRF_EXTRACT_CESM","Q700_d01_WRF_EXTRACT_CESM","1000000","0.000001","foo","foo"],
["Q700_d01_WRF_EXTRACT_CNRM","Q700_d01_WRF_EXTRACT_CNRM","1000000","0.000001","foo","foo"],
["Q850_d01_WRF_EXTRACT_CESM","Q850_d01_WRF_EXTRACT_CESM","1000000","0.000001","foo","foo"],
["Q850_d01_WRF_EXTRACT_CNRM","Q850_d01_WRF_EXTRACT_CNRM","1000000","0.000001","foo","foo"],
["QLML_d01_WRF_EXTRACT_CESM","QLML_d01_WRF_EXTRACT_CESM","1000000","0.000001","foo","foo"],
["QLML_d01_WRF_EXTRACT_CNRM","QLML_d01_WRF_EXTRACT_CNRM","1000000","0.000001","foo","foo"],
["RC_d01_WRF_EXTRACT_CESM","RC_d01_WRF_EXTRACT_CESM","1000","0.001","foo","foo"],
["RC_d01_WRF_EXTRACT_CNRM","RC_d01_WRF_EXTRACT_CNRM","100","0.01","foo","foo"],
["RN_d01_WRF_EXTRACT_CESM","RN_d01_WRF_EXTRACT_CESM","100","0.01","foo","foo"],
["RN_d01_WRF_EXTRACT_CNRM","RN_d01_WRF_EXTRACT_CNRM","100","0.01","foo","foo"],
["SLPAVG_d01_monthly_CESM","SLPAVG_d01_monthly_CESM","10","0.1","foo","foo"],
["SLPAVG_d01_monthly_CNRM","SLPAVG_d01_monthly_CNRM","10","0.1","foo","foo"],
["SLPAVG_d02_monthly_CESM","SLPAVG_d02_monthly_CESM","10","0.1","foo","foo"],
["SLPAVG_d02_monthly_CNRM","SLPAVG_d02_monthly_CNRM","10","0.1","foo","foo"],
["SLPAVG_d03_monthly_CESM","SLPAVG_d03_monthly_CESM","10","0.1","foo","foo"],
["SLPAVG_d03_monthly_CNRM","SLPAVG_d03_monthly_CNRM","10","0.1","foo","foo"],
["SLP_d01_WRF_EXTRACT_CESM","SLP_d01_WRF_EXTRACT_CESM","10","0.1","foo","foo"],
["SLP_d01_WRF_EXTRACT_CNRM","SLP_d01_WRF_EXTRACT_CNRM","10","0.1","foo","foo"],
["SMBOT_d01_WRF_EXTRACT_CESM","SMBOT_d01_WRF_EXTRACT_CESM","10000","0.0001","foo","foo"],
["SMBOT_d01_WRF_EXTRACT_CNRM","SMBOT_d01_WRF_EXTRACT_CNRM","10000","0.0001","foo","foo"],
["SMTOP_d01_WRF_EXTRACT_CESM","SMTOP_d01_WRF_EXTRACT_CESM","10000","0.0001","foo","foo"],
["SMTOP_d01_WRF_EXTRACT_CNRM","SMTOP_d01_WRF_EXTRACT_CNRM","10000","0.0001","foo","foo"],
["STBOT_d01_WRF_EXTRACT_CESM","STBOT_d01_WRF_EXTRACT_CESM","100","0.01","foo","foo"],
["STBOT_d01_WRF_EXTRACT_CNRM","STBOT_d01_WRF_EXTRACT_CNRM","100","0.01","foo","foo"],
["STTOP_d01_WRF_EXTRACT_CESM","STTOP_d01_WRF_EXTRACT_CESM","100","0.01","foo","foo"],
["STTOP_d01_WRF_EXTRACT_CNRM","STTOP_d01_WRF_EXTRACT_CNRM","10","0.1","foo","foo"],
["SWDNBC_d01_WRF_EXTRACT_CESM","SWDNBC_d01_WRF_EXTRACT_CESM","10","0.1","foo","foo"],
["SWDNBC_d01_WRF_EXTRACT_CNRM","SWDNBC_d01_WRF_EXTRACT_CNRM","10","0.1","foo","foo"],
["SWDNB_d01_WRF_EXTRACT_CESM","SWDNB_d01_WRF_EXTRACT_CESM","10","0.1","foo","foo"],
["SWDNB_d01_WRF_EXTRACT_CNRM","SWDNB_d01_WRF_EXTRACT_CNRM","10","0.1","foo","foo"],
["SWDNT_d01_WRF_EXTRACT_CESM","SWDNT_d01_WRF_EXTRACT_CESM","10","0.1","foo","foo"],
["SWDNT_d01_WRF_EXTRACT_CNRM","SWDNT_d01_WRF_EXTRACT_CNRM","10","0.1","foo","foo"],
["SWUPBC_d01_WRF_EXTRACT_CESM","SWUPBC_d01_WRF_EXTRACT_CESM","10","0.1","foo","foo"],
["SWUPBC_d01_WRF_EXTRACT_CNRM","SWUPBC_d01_WRF_EXTRACT_CNRM","10","0.1","foo","foo"],
["SWUPB_d01_WRF_EXTRACT_CESM","SWUPB_d01_WRF_EXTRACT_CESM","10","0.1","foo","foo"],
["SWUPB_d01_WRF_EXTRACT_CNRM","SWUPB_d01_WRF_EXTRACT_CNRM","10","0.1","foo","foo"],
["SWUPTC_d01_WRF_EXTRACT_CESM","SWUPTC_d01_WRF_EXTRACT_CESM","10","0.1","foo","foo"],
["SWUPTC_d01_WRF_EXTRACT_CNRM","SWUPTC_d01_WRF_EXTRACT_CNRM","10","0.1","foo","foo"],
["SWUPT_d01_WRF_EXTRACT_CESM","SWUPT_d01_WRF_EXTRACT_CESM","10","0.1","foo","foo"],
["SWUPT_d01_WRF_EXTRACT_CNRM","SWUPT_d01_WRF_EXTRACT_CNRM","10","0.1","foo","foo"],
["T2MAXDAVG_d01_monthly_CESM","T2MAXDAVG_d01_monthly_CESM","100","0.01","foo","foo"],
["T2MAXDAVG_d01_monthly_CNRM","T2MAXDAVG_d01_monthly_CNRM","100","0.01","foo","foo"],
["T2MAXDAVG_d02_monthly_CESM","T2MAXDAVG_d02_monthly_CESM","100","0.01","foo","foo"],
["T2MAXDAVG_d02_monthly_CNRM","T2MAXDAVG_d02_monthly_CNRM","100","0.01","foo","foo"],
["T2MAXDAVG_d03_monthly_CESM","T2MAXDAVG_d03_monthly_CESM","100","0.01","foo","foo"],
["T2MAXDAVG_d03_monthly_CNRM","T2MAXDAVG_d03_monthly_CNRM","100","0.01","foo","foo"],
["T2MAX_d01_monthly_CESM","T2MAX_d01_monthly_CESM","100","0.01","foo","foo"],
["T2MAX_d01_monthly_CNRM","T2MAX_d01_monthly_CNRM","100","0.01","foo","foo"],
["T2MAX_d02_monthly_CESM","T2MAX_d02_monthly_CESM","100","0.01","foo","foo"],
["T2MAX_d02_monthly_CNRM","T2MAX_d02_monthly_CNRM","100","0.01","foo","foo"],
["T2MAX_d03_monthly_CESM","T2MAX_d03_monthly_CESM","100","0.01","foo","foo"],
["T2MAX_d03_monthly_CNRM","T2MAX_d03_monthly_CNRM","100","0.01","foo","foo"],
["T2MEAN_d01_monthly_CESM","T2MEAN_d01_monthly_CESM","100","0.01","foo","foo"],
["T2MEAN_d01_monthly_CNRM","T2MEAN_d01_monthly_CNRM","100","0.01","foo","foo"],
["T2MEAN_d02_monthly_CESM","T2MEAN_d02_monthly_CESM","100","0.01","foo","foo"],
["T2MEAN_d02_monthly_CNRM","T2MEAN_d02_monthly_CNRM","100","0.01","foo","foo"],
["T2MEAN_d03_monthly_CESM","T2MEAN_d03_monthly_CESM","100","0.01","foo","foo"],
["T2MEAN_d03_monthly_CNRM","T2MEAN_d03_monthly_CNRM","100","0.01","foo","foo"],
["T2MINDAVG_d01_monthly_CESM","T2MINDAVG_d01_monthly_CESM","100","0.01","foo","foo"],
["T2MINDAVG_d01_monthly_CNRM","T2MINDAVG_d01_monthly_CNRM","100","0.01","foo","foo"],
["T2MINDAVG_d02_monthly_CESM","T2MINDAVG_d02_monthly_CESM","100","0.01","foo","foo"],
["T2MINDAVG_d02_monthly_CNRM","T2MINDAVG_d02_monthly_CNRM","100","0.01","foo","foo"],
["T2MINDAVG_d03_monthly_CESM","T2MINDAVG_d03_monthly_CESM","100","0.01","foo","foo"],
["T2MINDAVG_d03_monthly_CNRM","T2MINDAVG_d03_monthly_CNRM","100","0.01","foo","foo"],
["T2MIN_d01_monthly_CESM","T2MIN_d01_monthly_CESM","100","0.01","foo","foo"],
["T2MIN_d01_monthly_CNRM","T2MIN_d01_monthly_CNRM","100","0.01","foo","foo"],
["T2MIN_d02_monthly_CESM","T2MIN_d02_monthly_CESM","100","0.01","foo","foo"],
["T2MIN_d02_monthly_CNRM","T2MIN_d02_monthly_CNRM","100","0.01","foo","foo"],
["T2MIN_d03_monthly_CESM","T2MIN_d03_monthly_CESM","100","0.01","foo","foo"],
["T2MIN_d03_monthly_CNRM","T2MIN_d03_monthly_CNRM","100","0.01","foo","foo"],
["T2P02_d01_monthly_CESM","T2P02_d01_monthly_CESM","100","0.01","foo","foo"],
["T2P02_d01_monthly_CNRM","T2P02_d01_monthly_CNRM","100","0.01","foo","foo"],
["T2P02_d02_monthly_CESM","T2P02_d02_monthly_CESM","100","0.01","foo","foo"],
["T2P02_d02_monthly_CNRM","T2P02_d02_monthly_CNRM","100","0.01","foo","foo"],
["T2P02_d03_monthly_CESM","T2P02_d03_monthly_CESM","100","0.01","foo","foo"],
["T2P02_d03_monthly_CNRM","T2P02_d03_monthly_CNRM","100","0.01","foo","foo"],
["T2P05_d01_monthly_CESM","T2P05_d01_monthly_CESM","100","0.01","foo","foo"],
["T2P05_d01_monthly_CNRM","T2P05_d01_monthly_CNRM","100","0.01","foo","foo"],
["T2P05_d02_monthly_CESM","T2P05_d02_monthly_CESM","100","0.01","foo","foo"],
["T2P05_d02_monthly_CNRM","T2P05_d02_monthly_CNRM","100","0.01","foo","foo"],
["T2P05_d03_monthly_CESM","T2P05_d03_monthly_CESM","100","0.01","foo","foo"],
["T2P05_d03_monthly_CNRM","T2P05_d03_monthly_CNRM","100","0.01","foo","foo"],
["T2P10_d01_monthly_CESM","T2P10_d01_monthly_CESM","100","0.01","foo","foo"],
["T2P10_d01_monthly_CNRM","T2P10_d01_monthly_CNRM","100","0.01","foo","foo"],
["T2P10_d02_monthly_CESM","T2P10_d02_monthly_CESM","100","0.01","foo","foo"],
["T2P10_d02_monthly_CNRM","T2P10_d02_monthly_CNRM","100","0.01","foo","foo"],
["T2P10_d03_monthly_CESM","T2P10_d03_monthly_CESM","100","0.01","foo","foo"],
["T2P10_d03_monthly_CNRM","T2P10_d03_monthly_CNRM","100","0.01","foo","foo"],
["T2P25_d01_monthly_CESM","T2P25_d01_monthly_CESM","100","0.01","foo","foo"],
["T2P25_d01_monthly_CNRM","T2P25_d01_monthly_CNRM","100","0.01","foo","foo"],
["T2P25_d02_monthly_CESM","T2P25_d02_monthly_CESM","100","0.01","foo","foo"],
["T2P25_d02_monthly_CNRM","T2P25_d02_monthly_CNRM","100","0.01","foo","foo"],
["T2P25_d03_monthly_CESM","T2P25_d03_monthly_CESM","100","0.01","foo","foo"],
["T2P25_d03_monthly_CNRM","T2P25_d03_monthly_CNRM","100","0.01","foo","foo"],
["T2P50_d01_monthly_CESM","T2P50_d01_monthly_CESM","100","0.01","foo","foo"],
["T2P50_d01_monthly_CNRM","T2P50_d01_monthly_CNRM","100","0.01","foo","foo"],
["T2P50_d02_monthly_CESM","T2P50_d02_monthly_CESM","100","0.01","foo","foo"],
["T2P50_d02_monthly_CNRM","T2P50_d02_monthly_CNRM","100","0.01","foo","foo"],
["T2P50_d03_monthly_CESM","T2P50_d03_monthly_CESM","100","0.01","foo","foo"],
["T2P50_d03_monthly_CNRM","T2P50_d03_monthly_CNRM","100","0.01","foo","foo"],
["T2P75_d01_monthly_CESM","T2P75_d01_monthly_CESM","100","0.01","foo","foo"],
["T2P75_d01_monthly_CNRM","T2P75_d01_monthly_CNRM","100","0.01","foo","foo"],
["T2P75_d02_monthly_CESM","T2P75_d02_monthly_CESM","100","0.01","foo","foo"],
["T2P75_d02_monthly_CNRM","T2P75_d02_monthly_CNRM","100","0.01","foo","foo"],
["T2P75_d03_monthly_CESM","T2P75_d03_monthly_CESM","100","0.01","foo","foo"],
["T2P75_d03_monthly_CNRM","T2P75_d03_monthly_CNRM","100","0.01","foo","foo"],
["T2P90_d01_monthly_CESM","T2P90_d01_monthly_CESM","100","0.01","foo","foo"],
["T2P90_d01_monthly_CNRM","T2P90_d01_monthly_CNRM","100","0.01","foo","foo"],
["T2P90_d02_monthly_CESM","T2P90_d02_monthly_CESM","100","0.01","foo","foo"],
["T2P90_d02_monthly_CNRM","T2P90_d02_monthly_CNRM","100","0.01","foo","foo"],
["T2P90_d03_monthly_CESM","T2P90_d03_monthly_CESM","100","0.01","foo","foo"],
["T2P90_d03_monthly_CNRM","T2P90_d03_monthly_CNRM","100","0.01","foo","foo"],
["T2P95_d01_monthly_CESM","T2P95_d01_monthly_CESM","100","0.01","foo","foo"],
["T2P95_d01_monthly_CNRM","T2P95_d01_monthly_CNRM","100","0.01","foo","foo"],
["T2P95_d02_monthly_CESM","T2P95_d02_monthly_CESM","100","0.01","foo","foo"],
["T2P95_d02_monthly_CNRM","T2P95_d02_monthly_CNRM","100","0.01","foo","foo"],
["T2P95_d03_monthly_CESM","T2P95_d03_monthly_CESM","100","0.01","foo","foo"],
["T2P95_d03_monthly_CNRM","T2P95_d03_monthly_CNRM","100","0.01","foo","foo"],
["T2P98_d01_monthly_CESM","T2P98_d01_monthly_CESM","100","0.01","foo","foo"],
["T2P98_d01_monthly_CNRM","T2P98_d01_monthly_CNRM","100","0.01","foo","foo"],
["T2P98_d02_monthly_CESM","T2P98_d02_monthly_CESM","100","0.01","foo","foo"],
["T2P98_d02_monthly_CNRM","T2P98_d02_monthly_CNRM","100","0.01","foo","foo"],
["T2P98_d03_monthly_CESM","T2P98_d03_monthly_CESM","100","0.01","foo","foo"],
["T2P98_d03_monthly_CNRM","T2P98_d03_monthly_CNRM","100","0.01","foo","foo"],
["T2_d01_WRF_EXTRACT_CESM","T2_d01_WRF_EXTRACT_CESM","100","0.01","foo","foo"],
["T2_d01_WRF_EXTRACT_CNRM","T2_d01_WRF_EXTRACT_CNRM","100","0.01","foo","foo"],
["T700AVG_d01_monthly_CESM","T700AVG_d01_monthly_CESM","100","0.01","foo","foo"],
["T700AVG_d01_monthly_CNRM","T700AVG_d01_monthly_CNRM","100","0.01","foo","foo"],
["T700AVG_d02_monthly_CESM","T700AVG_d02_monthly_CESM","100","0.01","foo","foo"],
["T700AVG_d02_monthly_CNRM","T700AVG_d02_monthly_CNRM","100","0.01","foo","foo"],
["T700AVG_d03_monthly_CESM","T700AVG_d03_monthly_CESM","100","0.01","foo","foo"],
["T700AVG_d03_monthly_CNRM","T700AVG_d03_monthly_CNRM","100","0.01","foo","foo"],
["T700_d01_WRF_EXTRACT_CESM","T700_d01_WRF_EXTRACT_CESM","100","0.01","foo","foo"],
["T700_d01_WRF_EXTRACT_CNRM","T700_d01_WRF_EXTRACT_CNRM","100","0.01","foo","foo"],
["T850_d01_WRF_EXTRACT_CESM","T850_d01_WRF_EXTRACT_CESM","100","0.01","foo","foo"],
["T850_d01_WRF_EXTRACT_CNRM","T850_d01_WRF_EXTRACT_CNRM","100","0.01","foo","foo"],
["TLML_d01_WRF_EXTRACT_CESM","TLML_d01_WRF_EXTRACT_CESM","100","0.01","foo","foo"],
["TLML_d01_WRF_EXTRACT_CNRM","TLML_d01_WRF_EXTRACT_CNRM","100","0.01","foo","foo"],
["TSK_d01_WRF_EXTRACT_CESM","TSK_d01_WRF_EXTRACT_CESM","10","0.1","foo","foo"],
["TSK_d01_WRF_EXTRACT_CNRM","TSK_d01_WRF_EXTRACT_CNRM","10","0.1","foo","foo"],
["UE10_d01_WRF_EXTRACT_CESM","UE10_d01_WRF_EXTRACT_CESM","1000","0.001","foo","foo"],
["UE10_d01_WRF_EXTRACT_CNRM","UE10_d01_WRF_EXTRACT_CNRM","1000","0.001","foo","foo"],
["UE700_d01_WRF_EXTRACT_CESM","UE700_d01_WRF_EXTRACT_CESM","100","0.01","foo","foo"],
["UE700_d01_WRF_EXTRACT_CNRM","UE700_d01_WRF_EXTRACT_CNRM","100","0.01","foo","foo"],
["UE850_d01_WRF_EXTRACT_CESM","UE850_d01_WRF_EXTRACT_CESM","100","0.01","foo","foo"],
["UE850_d01_WRF_EXTRACT_CNRM","UE850_d01_WRF_EXTRACT_CNRM","100","0.01","foo","foo"],
["VE10_d01_WRF_EXTRACT_CESM","VE10_d01_WRF_EXTRACT_CESM","1000","0.001","foo","foo"],
["VE10_d01_WRF_EXTRACT_CNRM","VE10_d01_WRF_EXTRACT_CNRM","1000","0.001","foo","foo"],
["VE700_d01_WRF_EXTRACT_CESM","VE700_d01_WRF_EXTRACT_CESM","1000","0.001","foo","foo"],
["VE700_d01_WRF_EXTRACT_CNRM","VE700_d01_WRF_EXTRACT_CNRM","100","0.01","foo","foo"],
["VE850_d01_WRF_EXTRACT_CESM","VE850_d01_WRF_EXTRACT_CESM","100","0.01","foo","foo"],
["VE850_d01_WRF_EXTRACT_CNRM","VE850_d01_WRF_EXTRACT_CNRM","100","0.01","foo","foo"],
["W700_d01_WRF_EXTRACT_CESM","W700_d01_WRF_EXTRACT_CESM","1000","0.001","foo","foo"],
["W700_d01_WRF_EXTRACT_CNRM","W700_d01_WRF_EXTRACT_CNRM","10000","0.0001","foo","foo"],
["W850_d01_WRF_EXTRACT_CESM","W850_d01_WRF_EXTRACT_CESM","10000","0.0001","foo","foo"],
["W850_d01_WRF_EXTRACT_CNRM","W850_d01_WRF_EXTRACT_CNRM","10000","0.0001","foo","foo"],
["WS250AVG_d01_monthly_CESM","WS250AVG_d01_monthly_CESM","100","0.01","foo","foo"],
["WS250AVG_d01_monthly_CNRM","WS250AVG_d01_monthly_CNRM","100","0.01","foo","foo"],
["WS250AVG_d02_monthly_CESM","WS250AVG_d02_monthly_CESM","100","0.01","foo","foo"],
["WS250AVG_d02_monthly_CNRM","WS250AVG_d02_monthly_CNRM","100","0.01","foo","foo"],
["WS250AVG_d03_monthly_CESM","WS250AVG_d03_monthly_CESM","100","0.01","foo","foo"],
["WS250AVG_d03_monthly_CNRM","WS250AVG_d03_monthly_CNRM","100","0.01","foo","foo"],
["WS850AVG_d01_monthly_CESM","WS850AVG_d01_monthly_CESM","1000","0.001","foo","foo"],
["WS850AVG_d01_monthly_CNRM","WS850AVG_d01_monthly_CNRM","1000","0.001","foo","foo"],
["WS850AVG_d02_monthly_CESM","WS850AVG_d02_monthly_CESM","1000","0.001","foo","foo"],
["WS850AVG_d02_monthly_CNRM","WS850AVG_d02_monthly_CNRM","1000","0.001","foo","foo"],
["WS850AVG_d03_monthly_CESM","WS850AVG_d03_monthly_CESM","1000","0.001","foo","foo"],
["WS850AVG_d03_monthly_CNRM","WS850AVG_d03_monthly_CNRM","1000","0.001","foo","foo"],
["Z700_d01_WRF_EXTRACT_CESM","Z700_d01_WRF_EXTRACT_CESM","1","1","foo","foo"],
["Z700_d01_WRF_EXTRACT_CNRM","Z700_d01_WRF_EXTRACT_CNRM","1","1","foo","foo"],
["Z850_d01_WRF_EXTRACT_CESM","Z850_d01_WRF_EXTRACT_CESM","10","0.1","foo","foo"],
["Z850_d01_WRF_EXTRACT_CNRM","Z850_d01_WRF_EXTRACT_CNRM","10","0.1","foo","foo"]]
    for srcfile in srcfiles:
        for input_keys in inputs:
	    print input_keys[0]
	    #print srcfile[1]
            if input_keys[0] in srcfile[1]:
                var=input_keys[1]
                scale=input_keys[2]
                scale_factor=input_keys[3]
                missing=input_keys[4]
                unsMissing=input_keys[5]
                command=shlex.split('/Volumes/TB12RAID/PuertoRico/scalingScripts/bin/compress.sh '+var+' '+scale+' '+scale_factor+' '+missing+' '+unsMissing+' '+srcfile[1]+' '+srcfile[0]+' '+PROC_DIR+srcfile[0][len(src):len(srcfile[0])]+' '+dest+srcfile[0][len(src):len(srcfile[0])])
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
