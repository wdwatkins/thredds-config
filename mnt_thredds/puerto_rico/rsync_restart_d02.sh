#!/bin/bash
# copy data to eros, with auto restart
while [ 1 ]
do
    rsync -avz --partial --rsync-path='sudo -u tomcat rsync' --bwlimit=200000 *d02*.nc wwatkins@cida-eros-thredds3.er.usgs.gov:/mnt/morethredds/PuertoRico/hourly/d02 #--partial is same as -P
    if [ "$?" = "0" ] ; then
        echo "rsync completed normally"
        exit
    else #non-zero exit code
        echo "Rsync failure. Backing off and retrying..."
        sleep 180
    fi
done
