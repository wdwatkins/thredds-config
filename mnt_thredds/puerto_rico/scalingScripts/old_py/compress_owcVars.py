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
    inputs = [["CICELO_d02_WRF_EXTRACT_CESM","CICELO_d02_WRF_EXTRACT_CESM","1000","0.001","foo","foo"],
["CICELO_d02_WRF_EXTRACT_CNRM","CICELO_d02_WRF_EXTRACT_CNRM","1000","0.001","foo","foo"],
["CICELO_d03_WRF_EXTRACT_CESM","CICELO_d03_WRF_EXTRACT_CESM","100","0.01","foo","foo"],
["CICELO_d03_WRF_EXTRACT_CNRM","CICELO_d03_WRF_EXTRACT_CNRM","100","0.01","foo","foo"],
["CLDFLO_d02_WRF_EXTRACT_CESM","CLDFLO_d02_WRF_EXTRACT_CESM","10000","0.0001","foo","foo"],
["CLDFLO_d02_WRF_EXTRACT_CNRM","CLDFLO_d02_WRF_EXTRACT_CNRM","10000","0.0001","foo","foo"],
["CLDFLO_d03_WRF_EXTRACT_CESM","CLDFLO_d03_WRF_EXTRACT_CESM","10000","0.0001","foo","foo"],
["CLDFLO_d03_WRF_EXTRACT_CNRM","CLDFLO_d03_WRF_EXTRACT_CNRM","10000","0.0001","foo","foo"],
["CLDFRA700_d02_WRF_EXTRACT_CESM","CLDFRA700_d02_WRF_EXTRACT_CESM","10000","0.0001","foo","foo"],
["CLDFRA700_d02_WRF_EXTRACT_CNRM","CLDFRA700_d02_WRF_EXTRACT_CNRM","10000","0.0001","foo","foo"],
["CLDFRA700_d03_WRF_EXTRACT_CESM","CLDFRA700_d03_WRF_EXTRACT_CESM","10000","0.0001","foo","foo"],
["CLDFRA700_d03_WRF_EXTRACT_CNRM","CLDFRA700_d03_WRF_EXTRACT_CNRM","10000","0.0001","foo","foo"],
["CLDFRA850_d02_WRF_EXTRACT_CESM","CLDFRA850_d02_WRF_EXTRACT_CESM","10000","0.0001","foo","foo"],
["CLDFRA850_d02_WRF_EXTRACT_CNRM","CLDFRA850_d02_WRF_EXTRACT_CNRM","10000","0.0001","foo","foo"],
["CLDFRA850_d03_WRF_EXTRACT_CESM","CLDFRA850_d03_WRF_EXTRACT_CESM","10000","0.0001","foo","foo"],
["CLDFRA850_d03_WRF_EXTRACT_CNRM","CLDFRA850_d03_WRF_EXTRACT_CNRM","10000","0.0001","foo","foo"],
["CLIQLO_d02_WRF_EXTRACT_CESM","CLIQLO_d02_WRF_EXTRACT_CESM","10","0.1","foo","foo"],
["CLIQLO_d02_WRF_EXTRACT_CNRM","CLIQLO_d02_WRF_EXTRACT_CNRM","10","0.1","foo","foo"],
["HFX_d02_WRF_EXTRACT_CESM","HFX_d02_WRF_EXTRACT_CESM","10","0.1","foo","foo"],
["HFX_d02_WRF_EXTRACT_CNRM","HFX_d02_WRF_EXTRACT_CNRM","10","0.1","foo","foo"],
["HFX_d03_WRF_EXTRACT_CESM","HFX_d03_WRF_EXTRACT_CESM","10","0.1","foo","foo"],
["HFX_d03_WRF_EXTRACT_CNRM","HFX_d03_WRF_EXTRACT_CNRM","10","0.1","foo","foo"],
["LH_d02_WRF_EXTRACT_CESM","LH_d02_WRF_EXTRACT_CESM","10","0.1","foo","foo"],
["LH_d02_WRF_EXTRACT_CNRM","LH_d02_WRF_EXTRACT_CNRM","10","0.1","foo","foo"],
["LH_d03_WRF_EXTRACT_CESM","LH_d03_WRF_EXTRACT_CESM","10","0.1","foo","foo"],
["LH_d03_WRF_EXTRACT_CNRM","LH_d03_WRF_EXTRACT_CNRM","10","0.1","foo","foo"],
["LWDNBC_d02_WRF_EXTRACT_CESM","LWDNBC_d02_WRF_EXTRACT_CESM","10","0.1","foo","foo"],
["LWDNBC_d02_WRF_EXTRACT_CNRM","LWDNBC_d02_WRF_EXTRACT_CNRM","10","0.1","foo","foo"],
["LWDNBC_d03_WRF_EXTRACT_CESM","LWDNBC_d03_WRF_EXTRACT_CESM","10","0.1","foo","foo"],
["LWDNB_d02_WRF_EXTRACT_CESM","LWDNB_d02_WRF_EXTRACT_CESM","10","0.1","foo","foo"],
["LWDNB_d02_WRF_EXTRACT_CNRM","LWDNB_d02_WRF_EXTRACT_CNRM","10","0.1","foo","foo"],
["LWDNB_d03_WRF_EXTRACT_CESM","LWDNB_d03_WRF_EXTRACT_CESM","10","0.1","foo","foo"],
["LWDNB_d03_WRF_EXTRACT_CNRM","LWDNB_d03_WRF_EXTRACT_CNRM","10","0.1","foo","foo"],
["LWDNT_d02_WRF_EXTRACT_CESM","LWDNT_d02_WRF_EXTRACT_CESM","1000","0.001","foo","foo"],
["LWDNT_d02_WRF_EXTRACT_CNRM","LWDNT_d02_WRF_EXTRACT_CNRM","1000","0.001","foo","foo"],
["LWDNT_d03_WRF_EXTRACT_CESM","LWDNT_d03_WRF_EXTRACT_CESM","1000","0.001","foo","foo"],
["LWDNT_d03_WRF_EXTRACT_CNRM","LWDNT_d03_WRF_EXTRACT_CNRM","1000","0.001","foo","foo"],
["LWUPB_d02_WRF_EXTRACT_CESM","LWUPB_d02_WRF_EXTRACT_CESM","10","0.1","foo","foo"],
["LWUPB_d02_WRF_EXTRACT_CNRM","LWUPB_d02_WRF_EXTRACT_CNRM","10","0.1","foo","foo"],
["LWUPB_d03_WRF_EXTRACT_CESM","LWUPB_d03_WRF_EXTRACT_CESM","10","0.1","foo","foo"],
["LWUPB_d03_WRF_EXTRACT_CNRM","LWUPB_d03_WRF_EXTRACT_CNRM","10","0.1","foo","foo"],
["LWUPTC_d02_WRF_EXTRACT_CESM","LWUPTC_d02_WRF_EXTRACT_CESM","10","0.1","foo","foo"],
["LWUPTC_d02_WRF_EXTRACT_CNRM","LWUPTC_d02_WRF_EXTRACT_CNRM","10","0.1","foo","foo"],
["LWUPTC_d03_WRF_EXTRACT_CESM","LWUPTC_d03_WRF_EXTRACT_CESM","10","0.1","foo","foo"],
["LWUPTC_d03_WRF_EXTRACT_CNRM","LWUPTC_d03_WRF_EXTRACT_CNRM","10","0.1","foo","foo"],
["LWUPT_d02_WRF_EXTRACT_CESM","LWUPT_d02_WRF_EXTRACT_CESM","10","0.1","foo","foo"],
["LWUPT_d02_WRF_EXTRACT_CNRM","LWUPT_d02_WRF_EXTRACT_CNRM","10","0.1","foo","foo"],
["LWUPT_d03_WRF_EXTRACT_CESM","LWUPT_d03_WRF_EXTRACT_CESM","10","0.1","foo","foo"],
["LWUPT_d03_WRF_EXTRACT_CNRM","LWUPT_d03_WRF_EXTRACT_CNRM","10","0.1","foo","foo"],
["PBLH_d02_WRF_EXTRACT_CESM","PBLH_d02_WRF_EXTRACT_CESM","10","0.1","foo","foo"],
["PBLH_d02_WRF_EXTRACT_CNRM","PBLH_d02_WRF_EXTRACT_CNRM","10","0.1","foo","foo"],
["PBLH_d03_WRF_EXTRACT_CESM","PBLH_d03_WRF_EXTRACT_CESM","10","0.1","foo","foo"],
["PSFC_d02_WRF_EXTRACT_CESM","PSFC_d02_WRF_EXTRACT_CESM","10","0.1","foo","foo"],
["PSFC_d02_WRF_EXTRACT_CNRM","PSFC_d02_WRF_EXTRACT_CNRM","10","0.1","foo","foo"],
["PSFC_d03_WRF_EXTRACT_CESM","PSFC_d03_WRF_EXTRACT_CESM","10","0.1","foo","foo"],
["PSFC_d03_WRF_EXTRACT_CNRM","PSFC_d03_WRF_EXTRACT_CNRM","10","0.1","foo","foo"],
["PWAT_d02_WRF_EXTRACT_CESM","PWAT_d02_WRF_EXTRACT_CESM","100","0.01","foo","foo"],
["PWAT_d02_WRF_EXTRACT_CNRM","PWAT_d02_WRF_EXTRACT_CNRM","100","0.01","foo","foo"],
["PWAT_d03_WRF_EXTRACT_CESM","PWAT_d03_WRF_EXTRACT_CESM","100","0.01","foo","foo"],
["PWAT_d03_WRF_EXTRACT_CNRM","PWAT_d03_WRF_EXTRACT_CNRM","100","0.01","foo","foo"],
["Q2_d02_WRF_EXTRACT_CESM","Q2_d02_WRF_EXTRACT_CESM","100000","0.00001","foo","foo"],
["Q2_d02_WRF_EXTRACT_CNRM","Q2_d02_WRF_EXTRACT_CNRM","100000","0.00001","foo","foo"],
["Q2_d03_WRF_EXTRACT_CESM","Q2_d03_WRF_EXTRACT_CESM","100000","0.00001","foo","foo"],
["Q2_d03_WRF_EXTRACT_CNRM","Q2_d03_WRF_EXTRACT_CNRM","100000","0.00001","foo","foo"],
["Q700_d02_WRF_EXTRACT_CESM","Q700_d02_WRF_EXTRACT_CESM","1000000","0.000001","foo","foo"],
["Q700_d02_WRF_EXTRACT_CNRM","Q700_d02_WRF_EXTRACT_CNRM","1000000","0.000001","foo","foo"],
["Q700_d03_WRF_EXTRACT_CESM","Q700_d03_WRF_EXTRACT_CESM","1000000","0.000001","foo","foo"],
["Q700_d03_WRF_EXTRACT_CNRM","Q700_d03_WRF_EXTRACT_CNRM","1000000","0.000001","foo","foo"],
["Q850_d02_WRF_EXTRACT_CESM","Q850_d02_WRF_EXTRACT_CESM","1000000","0.000001","foo","foo"],
["Q850_d02_WRF_EXTRACT_CNRM","Q850_d02_WRF_EXTRACT_CNRM","1000000","0.000001","foo","foo"],
["Q850_d03_WRF_EXTRACT_CESM","Q850_d03_WRF_EXTRACT_CESM","1000000","0.000001","foo","foo"],
["Q850_d03_WRF_EXTRACT_CNRM","Q850_d03_WRF_EXTRACT_CNRM","1000000","0.000001","foo","foo"],
["QLML_d02_WRF_EXTRACT_CESM","QLML_d02_WRF_EXTRACT_CESM","1000000","0.000001","foo","foo"],
["QLML_d02_WRF_EXTRACT_CNRM","QLML_d02_WRF_EXTRACT_CNRM","1000000","0.000001","foo","foo"],
["QLML_d03_WRF_EXTRACT_CESM","QLML_d03_WRF_EXTRACT_CESM","1000000","0.000001","foo","foo"],
["QLML_d03_WRF_EXTRACT_CNRM","QLML_d03_WRF_EXTRACT_CNRM","1000000","0.000001","foo","foo"],
["RC_d02_WRF_EXTRACT_CESM","RC_d02_WRF_EXTRACT_CESM","1000","0.001","foo","foo"],
["RC_d02_WRF_EXTRACT_CNRM","RC_d02_WRF_EXTRACT_CNRM","1000","0.001","foo","foo"],
["RC_d03_WRF_EXTRACT_CESM","RC_d03_WRF_EXTRACT_CESM","1000","0.001","foo","foo"],
["RC_d03_WRF_EXTRACT_CNRM","RC_d03_WRF_EXTRACT_CNRM","1000","0.001","foo","foo"],
["RN_d02_WRF_EXTRACT_CESM","RN_d02_WRF_EXTRACT_CESM","100","0.01","foo","foo"],
["RN_d02_WRF_EXTRACT_CNRM","RN_d02_WRF_EXTRACT_CNRM","100","0.01","foo","foo"],
["RN_d03_WRF_EXTRACT_CESM","RN_d03_WRF_EXTRACT_CESM","100","0.01","foo","foo"],
["RN_d03_WRF_EXTRACT_CNRM","RN_d03_WRF_EXTRACT_CNRM","100","0.01","foo","foo"],
["SLP_d02_WRF_EXTRACT_CESM","SLP_d02_WRF_EXTRACT_CESM","10","0.1","foo","foo"],
["SLP_d02_WRF_EXTRACT_CNRM","SLP_d02_WRF_EXTRACT_CNRM","10","0.1","foo","foo"],
["SLP_d03_WRF_EXTRACT_CESM","SLP_d03_WRF_EXTRACT_CESM","10","0.1","foo","foo"],
["SLP_d03_WRF_EXTRACT_CNRM","SLP_d03_WRF_EXTRACT_CNRM","10","0.1","foo","foo"],
["SMBOT_d02_WRF_EXTRACT_CESM","SMBOT_d02_WRF_EXTRACT_CESM","10000","0.0001","foo","foo"],
["SMBOT_d02_WRF_EXTRACT_CNRM","SMBOT_d02_WRF_EXTRACT_CNRM","10000","0.0001","foo","foo"],
["SMBOT_d03_WRF_EXTRACT_CESM","SMBOT_d03_WRF_EXTRACT_CESM","10000","0.0001","foo","foo"],
["SMBOT_d03_WRF_EXTRACT_CNRM","SMBOT_d03_WRF_EXTRACT_CNRM","10000","0.0001","foo","foo"],
["SMTOP_d02_WRF_EXTRACT_CESM","SMTOP_d02_WRF_EXTRACT_CESM","10000","0.0001","foo","foo"],
["SMTOP_d02_WRF_EXTRACT_CNRM","SMTOP_d02_WRF_EXTRACT_CNRM","10000","0.0001","foo","foo"],
["SMTOP_d03_WRF_EXTRACT_CESM","SMTOP_d03_WRF_EXTRACT_CESM","10000","0.0001","foo","foo"],
["SMTOP_d03_WRF_EXTRACT_CNRM","SMTOP_d03_WRF_EXTRACT_CNRM","10000","0.0001","foo","foo"],
["STBOT_d02_WRF_EXTRACT_CESM","STBOT_d02_WRF_EXTRACT_CESM","100","0.01","foo","foo"],
["STBOT_d02_WRF_EXTRACT_CNRM","STBOT_d02_WRF_EXTRACT_CNRM","100","0.01","foo","foo"],
["STBOT_d03_WRF_EXTRACT_CESM","STBOT_d03_WRF_EXTRACT_CESM","100","0.01","foo","foo"],
["STBOT_d03_WRF_EXTRACT_CNRM","STBOT_d03_WRF_EXTRACT_CNRM","100","0.01","foo","foo"],
["STTOP_d02_WRF_EXTRACT_CESM","STTOP_d02_WRF_EXTRACT_CESM","100","0.01","foo","foo"],
["STTOP_d02_WRF_EXTRACT_CNRM","STTOP_d02_WRF_EXTRACT_CNRM","100","0.01","foo","foo"],
["STTOP_d03_WRF_EXTRACT_CESM","STTOP_d03_WRF_EXTRACT_CESM","100","0.01","foo","foo"],
["STTOP_d03_WRF_EXTRACT_CNRM","STTOP_d03_WRF_EXTRACT_CNRM","100","0.01","foo","foo"],
["SWDNBC_d02_WRF_EXTRACT_CESM","SWDNBC_d02_WRF_EXTRACT_CESM","10","0.1","foo","foo"],
["SWDNBC_d02_WRF_EXTRACT_CNRM","SWDNBC_d02_WRF_EXTRACT_CNRM","10","0.1","foo","foo"],
["SWDNBC_d03_WRF_EXTRACT_CESM","SWDNBC_d03_WRF_EXTRACT_CESM","10","0.1","foo","foo"],
["SWDNBC_d03_WRF_EXTRACT_CNRM","SWDNBC_d03_WRF_EXTRACT_CNRM","10","0.1","foo","foo"],
["SWDNB_d02_WRF_EXTRACT_CESM","SWDNB_d02_WRF_EXTRACT_CESM","10","0.1","foo","foo"],
["SWDNB_d02_WRF_EXTRACT_CNRM","SWDNB_d02_WRF_EXTRACT_CNRM","10","0.1","foo","foo"],
["SWDNB_d03_WRF_EXTRACT_CESM","SWDNB_d03_WRF_EXTRACT_CESM","10","0.1","foo","foo"],
["SWDNB_d03_WRF_EXTRACT_CNRM","SWDNB_d03_WRF_EXTRACT_CNRM","10","0.1","foo","foo"],
["SWDNT_d02_WRF_EXTRACT_CESM","SWDNT_d02_WRF_EXTRACT_CESM","10","0.1","foo","foo"],
["SWDNT_d02_WRF_EXTRACT_CNRM","SWDNT_d02_WRF_EXTRACT_CNRM","10","0.1","foo","foo"],
["SWDNT_d03_WRF_EXTRACT_CESM","SWDNT_d03_WRF_EXTRACT_CESM","10","0.1","foo","foo"],
["SWDNT_d03_WRF_EXTRACT_CNRM","SWDNT_d03_WRF_EXTRACT_CNRM","10","0.1","foo","foo"],
["SWUPBC_d02_WRF_EXTRACT_CESM","SWUPBC_d02_WRF_EXTRACT_CESM","100","0.01","foo","foo"],
["SWUPBC_d02_WRF_EXTRACT_CNRM","SWUPBC_d02_WRF_EXTRACT_CNRM","100","0.01","foo","foo"],
["SWUPBC_d03_WRF_EXTRACT_CESM","SWUPBC_d03_WRF_EXTRACT_CESM","100","0.01","foo","foo"],
["SWUPBC_d03_WRF_EXTRACT_CNRM","SWUPBC_d03_WRF_EXTRACT_CNRM","100","0.01","foo","foo"],
["SWUPB_d02_WRF_EXTRACT_CESM","SWUPB_d02_WRF_EXTRACT_CESM","100","0.01","foo","foo"],
["SWUPB_d02_WRF_EXTRACT_CNRM","SWUPB_d02_WRF_EXTRACT_CNRM","100","0.01","foo","foo"],
["SWUPB_d03_WRF_EXTRACT_CESM","SWUPB_d03_WRF_EXTRACT_CESM","100","0.01","foo","foo"],
["SWUPB_d03_WRF_EXTRACT_CNRM","SWUPB_d03_WRF_EXTRACT_CNRM","100","0.01","foo","foo"],
["SWUPTC_d02_WRF_EXTRACT_CESM","SWUPTC_d02_WRF_EXTRACT_CESM","100","0.01","foo","foo"],
["SWUPTC_d02_WRF_EXTRACT_CNRM","SWUPTC_d02_WRF_EXTRACT_CNRM","100","0.01","foo","foo"],
["SWUPTC_d03_WRF_EXTRACT_CESM","SWUPTC_d03_WRF_EXTRACT_CESM","100","0.01","foo","foo"],
["SWUPTC_d03_WRF_EXTRACT_CNRM","SWUPTC_d03_WRF_EXTRACT_CNRM","10","0.1","foo","foo"],
["SWUPT_d02_WRF_EXTRACT_CESM","SWUPT_d02_WRF_EXTRACT_CESM","10","0.1","foo","foo"],
["SWUPT_d02_WRF_EXTRACT_CNRM","SWUPT_d02_WRF_EXTRACT_CNRM","10","0.1","foo","foo"],
["SWUPT_d03_WRF_EXTRACT_CESM","SWUPT_d03_WRF_EXTRACT_CESM","10","0.1","foo","foo"],
["SWUPT_d03_WRF_EXTRACT_CNRM","SWUPT_d03_WRF_EXTRACT_CNRM","10","0.1","foo","foo"],
["T2_d02_WRF_EXTRACT_CESM","T2_d02_WRF_EXTRACT_CESM","100","0.01","foo","foo"],
["T2_d02_WRF_EXTRACT_CNRM","T2_d02_WRF_EXTRACT_CNRM","100","0.01","foo","foo"],
["T2_d03_WRF_EXTRACT_CESM","T2_d03_WRF_EXTRACT_CESM","100","0.01","foo","foo"],
["T2_d03_WRF_EXTRACT_CNRM","T2_d03_WRF_EXTRACT_CNRM","100","0.01","foo","foo"],
["T700_d02_WRF_EXTRACT_CESM","T700_d02_WRF_EXTRACT_CESM","100","0.01","foo","foo"],
["T700_d02_WRF_EXTRACT_CNRM","T700_d02_WRF_EXTRACT_CNRM","100","0.01","foo","foo"],
["T700_d03_WRF_EXTRACT_CESM","T700_d03_WRF_EXTRACT_CESM","100","0.01","foo","foo"],
["T700_d03_WRF_EXTRACT_CNRM","T700_d03_WRF_EXTRACT_CNRM","100","0.01","foo","foo"],
["T850_d02_WRF_EXTRACT_CESM","T850_d02_WRF_EXTRACT_CESM","100","0.01","foo","foo"],
["T850_d02_WRF_EXTRACT_CNRM","T850_d02_WRF_EXTRACT_CNRM","100","0.01","foo","foo"],
["T850_d03_WRF_EXTRACT_CESM","T850_d03_WRF_EXTRACT_CESM","100","0.01","foo","foo"],
["T850_d03_WRF_EXTRACT_CNRM","T850_d03_WRF_EXTRACT_CNRM","100","0.01","foo","foo"],
["TLML_d02_WRF_EXTRACT_CESM","TLML_d02_WRF_EXTRACT_CESM","100","0.01","foo","foo"],
["TLML_d02_WRF_EXTRACT_CNRM","TLML_d02_WRF_EXTRACT_CNRM","100","0.01","foo","foo"],
["TLML_d03_WRF_EXTRACT_CESM","TLML_d03_WRF_EXTRACT_CESM","100","0.01","foo","foo"],
["TLML_d03_WRF_EXTRACT_CNRM","TLML_d03_WRF_EXTRACT_CNRM","100","0.01","foo","foo"],
["TSK_d02_WRF_EXTRACT_CESM","TSK_d02_WRF_EXTRACT_CESM","10","0.1","foo","foo"],
["TSK_d02_WRF_EXTRACT_CNRM","TSK_d02_WRF_EXTRACT_CNRM","10","0.1","foo","foo"],
["TSK_d03_WRF_EXTRACT_CESM","TSK_d03_WRF_EXTRACT_CESM","10","0.1","foo","foo"],
["TSK_d03_WRF_EXTRACT_CNRM","TSK_d03_WRF_EXTRACT_CNRM","10","0.1","foo","foo"],
["UE10_d02_WRF_EXTRACT_CESM","UE10_d02_WRF_EXTRACT_CESM","1000","0.001","foo","foo"],
["UE10_d02_WRF_EXTRACT_CNRM","UE10_d02_WRF_EXTRACT_CNRM","1000","0.001","foo","foo"],
["UE10_d03_WRF_EXTRACT_CESM","UE10_d03_WRF_EXTRACT_CESM","1000","0.001","foo","foo"],
["UE10_d03_WRF_EXTRACT_CNRM","UE10_d03_WRF_EXTRACT_CNRM","1000","0.001","foo","foo"],
["UE700_d02_WRF_EXTRACT_CESM","UE700_d02_WRF_EXTRACT_CESM","1000","0.001","foo","foo"],
["UE700_d02_WRF_EXTRACT_CNRM","UE700_d02_WRF_EXTRACT_CNRM","1000","0.001","foo","foo"],
["UE700_d03_WRF_EXTRACT_CESM","UE700_d03_WRF_EXTRACT_CESM","1000","0.001","foo","foo"],
["UE700_d03_WRF_EXTRACT_CNRM","UE700_d03_WRF_EXTRACT_CNRM","1000","0.001","foo","foo"],
["UE850_d02_WRF_EXTRACT_CESM","UE850_d02_WRF_EXTRACT_CESM","1000","0.001","foo","foo"],
["UE850_d02_WRF_EXTRACT_CNRM","UE850_d02_WRF_EXTRACT_CNRM","1000","0.001","foo","foo"],
["UE850_d03_WRF_EXTRACT_CESM","UE850_d03_WRF_EXTRACT_CESM","1000","0.001","foo","foo"],
["UE850_d03_WRF_EXTRACT_CNRM","UE850_d03_WRF_EXTRACT_CNRM","1000","0.001","foo","foo"],
["VE10_d02_WRF_EXTRACT_CESM","VE10_d02_WRF_EXTRACT_CESM","1000","0.001","foo","foo"],
["VE10_d02_WRF_EXTRACT_CNRM","VE10_d02_WRF_EXTRACT_CNRM","1000","0.001","foo","foo"],
["VE10_d03_WRF_EXTRACT_CESM","VE10_d03_WRF_EXTRACT_CESM","1000","0.001","foo","foo"],
["VE10_d03_WRF_EXTRACT_CNRM","VE10_d03_WRF_EXTRACT_CNRM","1000","0.001","foo","foo"],
["VE700_d02_WRF_EXTRACT_CESM","VE700_d02_WRF_EXTRACT_CESM","1000","0.001","foo","foo"],
["VE700_d02_WRF_EXTRACT_CNRM","VE700_d02_WRF_EXTRACT_CNRM","1000","0.001","foo","foo"],
["VE700_d03_WRF_EXTRACT_CESM","VE700_d03_WRF_EXTRACT_CESM","1000","0.001","foo","foo"],
["VE700_d03_WRF_EXTRACT_CNRM","VE700_d03_WRF_EXTRACT_CNRM","1000","0.001","foo","foo"],
["VE850_d02_WRF_EXTRACT_CESM","VE850_d02_WRF_EXTRACT_CESM","1000","0.001","foo","foo"],
["VE850_d02_WRF_EXTRACT_CNRM","VE850_d02_WRF_EXTRACT_CNRM","1000","0.001","foo","foo"],
["VE850_d03_WRF_EXTRACT_CESM","VE850_d03_WRF_EXTRACT_CESM","1000","0.001","foo","foo"],
["VE850_d03_WRF_EXTRACT_CNRM","VE850_d03_WRF_EXTRACT_CNRM","100","0.01","foo","foo"],
["W700_d02_WRF_EXTRACT_CESM","W700_d02_WRF_EXTRACT_CESM","1000","0.001","foo","foo"],
["W700_d02_WRF_EXTRACT_CNRM","W700_d02_WRF_EXTRACT_CNRM","1000","0.001","foo","foo"],
["W700_d03_WRF_EXTRACT_CESM","W700_d03_WRF_EXTRACT_CESM","1000","0.001","foo","foo"],
["W700_d03_WRF_EXTRACT_CNRM","W700_d03_WRF_EXTRACT_CNRM","1000","0.001","foo","foo"],
["W850_d02_WRF_EXTRACT_CESM","W850_d02_WRF_EXTRACT_CESM","1000","0.001","foo","foo"],
["W850_d02_WRF_EXTRACT_CNRM","W850_d02_WRF_EXTRACT_CNRM","10000","0.0001","foo","foo"],
["W850_d03_WRF_EXTRACT_CESM","W850_d03_WRF_EXTRACT_CESM","1000","0.001","foo","foo"],
["W850_d03_WRF_EXTRACT_CNRM","W850_d03_WRF_EXTRACT_CNRM","1000","0.001","foo","foo"],
["Z700_d03_WRF_EXTRACT_CESM","Z700_d03_WRF_EXTRACT_CESM","10","0.1","foo","foo"],
["Z700_d03_WRF_EXTRACT_CNRM","Z700_d03_WRF_EXTRACT_CNRM","10","0.1","foo","foo"],
["Z850_d02_WRF_EXTRACT_CESM","Z850_d02_WRF_EXTRACT_CESM","10","0.1","foo","foo"],
["Z850_d02_WRF_EXTRACT_CNRM","Z850_d02_WRF_EXTRACT_CNRM","10","0.1","foo","foo"],
["Z850_d03_WRF_EXTRACT_CESM","Z850_d03_WRF_EXTRACT_CESM","10","0.1","foo","foo"],
["Z850_d03_WRF_EXTRACT_CNRM","Z850_d03_WRF_EXTRACT_CNRM","10","0.1","foo","foo"]]
    for srcfile in srcfiles:
        for input_keys in inputs:
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
