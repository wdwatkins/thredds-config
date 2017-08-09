file_keys={'huss':'specific_humidity','pr':'precipitation_amount','rsds':'surface_downwelling_shortwave_flux_in_air','tasmax':'air_temperature','tasmin':'air_temperature','was':'wind_speed'}

d=open('./union.ncml','a')
d.write('<?xml version="1.0" encoding="UTF-8"?>\n<netcdf xmlns="http://www.unidata.ucar.edu/namespaces/netcdf/ncml-2.2">\n <aggregation type="union">\n')
for key in file_keys.keys():
    f=open('./ls.txt')
    lines=f.readlines()
    f.close()
    for line in lines:
        if key in line and 'SRESA2' in line:
            name=line[0:-1]
            var_name=line[0:-1-(36+len(key))]+'_'+file_keys[key]
            print var_name
            d.write(' <netcdf location="'+name+'">\n <variable orgName="'+file_keys[key]+'" name="'+var_name+'" />\n </netcdf>\n')

d.write(' </aggregation>\n</netcdf>')
d.close()


d=open('./union_20C3M.ncml','a')
d.write('<?xml version="1.0" encoding="UTF-8"?>\n<netcdf xmlns="http://www.unidata.ucar.edu/namespaces/netcdf/ncml-2.2">\n <aggregation type="union">\n')
for key in file_keys.keys():
    f=open('./ls.txt')
    lines=f.readlines()
    f.close()
    for line in lines:
        if key in line and '20C3M' in line:
            name=line[0:-1]
            var_name=line[0:-1-(36+len(key))]+'_'+file_keys[key]
            print var_name
            d.write(' <netcdf location="'+name+'">\n <variable orgName="'+file_keys[key]+'" name="'+var_name+'" />\n </netcdf>\n')

d.write(' </aggregation>\n</netcdf>')
d.close()
