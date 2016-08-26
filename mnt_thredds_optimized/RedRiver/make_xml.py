#!/usr/bin/env python

import glob
from collections import OrderedDict

#models = ['historical', 'CCSM4', 'MIROC5', 'MPI-ESM-LR']
models = ['historical']
#models = ['CCSM4', 'MIROC5', 'MPI-ESM-LR']
#scenarios = ['historical', 'rcp26', 'rcp45', 'rcp85']
#scenarios = ['rcp26', 'rcp45', 'rcp85']
scenarios = ['historical']
stats = ['BCQM', 'CDFt', 'EDQM']

variables = OrderedDict([('pr', 'RRprp1'), ('tasmin', 'RRtnp1'), ('tasmax', 'RRtxp1'),
                         ('pr_qcmask', 'RRprp1'), ('tasmin_qcmask', 'RRtnp1'), ('tasmax_qcmask', 'RRtxp1')])

# Sample filenames
# pr_day_RRprp1-BCQM-A10aaL01K00_historical_r6i1p1_RR_19610101-20051231.nc
# pr_day_RRprp1-BCQM-A32aaL01K00_rcp26_r1i1p1_RR_20060101-20991231.nc (from MPI-ESM-LR)
# pr_       day_RRprp1-BCQM-A12aaL01K00_rcp26_r6i1p1_RR_20060101-20991231.nc (from CCSM4)
# pr_qcmask_day_RRprp1-BCQM-A12aaL01K00_rcp26_r6i1p1_RR_20060101-20991231.nc (from CCSM4)

# livneh historical
# pr_day_livneh_historical_r0i0p1_SCCSC0p1_19610101-20111231.nc
# tasmax_day_livneh_historical_r0i0p1_SCCSC0p1_19610101-20111231.nc
# tasmin_day_livneh_historical_r0i0p1_SCCSC0p1_19610101-20111231.nc

# Parts of the ncml xml file
xml_head = '<?xml version="1.0" encoding="UTF-8"?>\n<netcdf xmlns="http://www.unidata.ucar.edu/namespaces/netcdf/ncml-2.2">\n       <attribute name="title" type="String" value="Statistically downscaled estimates of precipitation and temperature for the Red River basin (South Central U.S.A)"/>\n    <aggregation type="union">\n'
xml_entry_pr = '        <netcdf location="{2}" enhance="true">\n                <variable orgName="{3}" name="{3}-{4}_{0}_{1}"/>\n                <remove name="i_offset" type="variable"/>\n                <remove name="j_offset" type="variable"/>\n        </netcdf>\n'
xml_entry_tas = '        <netcdf location="{2}" enhance="true">\n                <variable orgName="{3}" name="{3}-{4}_{0}_{1}"/>\n                <remove name="coordinates" type="attribute"/>\n                <remove name="i_offset" type="variable"/>\n                <remove name="j_offset" type="variable"/>\n                <remove name="height" type="variable"/>\n        </netcdf>\n'
xml_entry_livneh = '        <netcdf location="{2}" enhance="true">\n                <variable orgName="{3}" name="{3}-{0}_{1}"/>\n                <remove name="i_offset" type="variable"/>\n                <remove name="j_offset" type="variable"/>\n        </netcdf>\n'
xml_foot = '    </aggregation>\n</netcdf>\n'

outfile = open('crap.xml', 'w')
outfile.write(xml_head)

for key, val in variables.iteritems():
    for ss in scenarios:
        for stat in stats:
            for mm in models:
                if mm != 'historical':
                    flist = [el for el in glob.glob('{0}/{1}/{2}_day_{3}-{4}-*_{1}_*_RR_*.nc'.format(mm, ss, key, val, stat))]
                    if len(flist) == 0:
                        continue
#                         print 'flist is empty', flist
                    elif len(flist) > 1:
                        print 'flist has multiple files for {0} {1} {2} {3} {4}'.format(mm, ss, stat, key, val)
                    else:
                        # Create xml entry
                        if key in ['pr',  'pr_qcmask', 'tasmin_qcmask', 'tasmax_qcmask']:
                            outfile.write(xml_entry_pr.format(mm, ss, flist[0], key, stat))
                        else:
                            outfile.write(xml_entry_tas.format(mm, ss, flist[0], key, stat))
                        print flist
                else:
                    # process the livneh historical datasets
                    flist = [el for el in glob.glob('{0}/{1}_day_livneh_*.nc'.format(mm, key))]
                    if len(flist) == 1:
                        # Create the xml entry
                        outfile.write(xml_entry_livneh.format(mm, 'livneh', flist[0], key))
                        print flist
outfile.write(xml_foot)
outfile.close()
