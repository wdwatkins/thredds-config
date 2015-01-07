year = 1960
day = 1
main_count = 0
day_index=""
while year < 2100:
    if year%400 == 0:
        count=1
        while count < 367:
            if count != 60:
                day_index=day_index+str(day)+' '
                main_count+=1
            count+=1
            day+=1
    elif year%100 == 1:
        count=1
        while count <366:
            day_index=day_index+str(day)+' '
            count+=1
            day+=1
            main_count+=1
    elif year%4 == 1:
        count=1
        while count < 367:
            if count != 60:
                day_index=day_index+str(day)+' '
                main_count+=1
            count+=1
            day+=1
    else:
        count=1
        while count < 366:
            day_index=day_index+str(day)+' '
            count+=1
            day+=1
            main_count+=1
    year+=1
    print year
f=open('./ls.txt')
lines=f.readlines()
f.close()
c=open('./union_conus_pr.ncml','w')
d=open('./union_conus_t.ncml','w')
a=open('./union_alaska.ncml','w')
c.write('<?xml version="1.0" encoding="UTF-8"?>\n<netcdf xmlns="http://www.unidata.ucar.edu/namespaces/netcdf/ncml-2.2">\n  <variable name="time">\n    <values>'+day_index+'</values>\n  </variable>\n <aggregation type="union">\n')
d.write('<?xml version="1.0" encoding="UTF-8"?>\n<netcdf xmlns="http://www.unidata.ucar.edu/namespaces/netcdf/ncml-2.2">\n  <variable name="time">\n    <values>'+day_index+'</values>\n  </variable>\n <aggregation type="union">\n')
a.write('<?xml version="1.0" encoding="UTF-8"?>\n<netcdf xmlns="http://www.unidata.ucar.edu/namespaces/netcdf/ncml-2.2">\n  <aggregation type="union">\n')
for line in lines:
    if '.nc' in line and '.nc.gz' not in line:
        new_name = line[0:-1-13].replace('.','-')
        if 'pr' in new_name:
            orgName = 'pr' 
            c.write('       <netcdf location="../documentation_and_files/files/'+line[0:-1]+'">\n         <variable orgName="'+orgName+'" name="'+new_name+'" />\n        </netcdf>\n')
        if 'tmin' in new_name:
            orgName = 'tmin' 
            d.write('       <netcdf location="../documentation_and_files/files/'+line[0:-1]+'">\n         <variable orgName="'+orgName+'" name="'+new_name+'" />\n        </netcdf>\n')
        if 'tmax' in new_name:
            orgName = 'tmax' 
            d.write('       <netcdf location="../documentation_and_files/files/'+line[0:-1]+'">\n         <variable orgName="'+orgName+'" name="'+new_name+'" />\n        </netcdf>\n')
        if 'Alas' in line:
            a.write('       <netcdf location="../documentation_and_files/files/'+line[0:-1]+'">\n         <variable orgName="'+orgName+'" name="'+new_name+'" />\n        </netcdf>\n')
            

c.write('   </aggregation>\n</netcdf>')
d.write('   </aggregation>\n</netcdf>')
a.write('   </aggregation>\n</netcdf>')
c.close()
d.close()
a.close()