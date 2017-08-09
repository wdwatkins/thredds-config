# Join existing: 12 time period/GCMs for wus.
file_keys=["SD_A1B_2040s_comp","SD_A1B_2040s_echam5","SD_A1B_2040s_hadgem1","SD_A1B_2040s_miroc_3.2","SD_A1B_2040s_pcm1","SD_A1B_2080s_comp","SD_A1B_2080s_echam5","SD_A1B_2080s_hadgem1","SD_A1B_2080s_miroc_3.2","SD_A1B_2080s_pcm1","historical"]

ncml='<?xml version="1.0"?>\n<netcdf xmlns="http://www.unidata.ucar.edu/namespaces/netcdf/ncml-2.2">\n <aggregation dimName="TIME" type="joinExisting" timeUnitsChange="true">\n <scan location="{0}" regExp="{1}.*" subdirs="false"/>\n </aggregation>\n</netcdf>'
for key in file_keys:
    name=key+'.ncml' # create name for join file.
    f=open('./joins/'+name,'w')
    f.write(ncml.format("../wus_16d/", key))
    f.close()

# Join existing: 3 time periods for wrf
file_keys=["WRF_1980s_echam5","WRF_A1B_2020s_echam5","WRF_A1B_2050s_echam5"]

ncml='<?xml version="1.0"?>\n<netcdf xmlns="http://www.unidata.ucar.edu/namespaces/netcdf/ncml-2.2">\n <aggregation dimName="TIME" type="joinExisting" timeUnitsChange="true">\n <scan location="{0}" regExp="{1}.*" subdirs="false"/>\n </aggregation>\n</netcdf>'
for key in file_keys:
    name=key+'.ncml' # create name for join file.
    f=open('./joins/'+name,'w')
    f.write(ncml.format("../wrf_16d/", key))
    f.close()
