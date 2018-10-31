#!/bin/bash
# copy data to eros, with auto restart

fromHere=$1
toThere=$2

while [ 1 ]
do
    rsync -avz --partial --rsync-path='sudo -u tomcat rsync' --bwlimit=200000 $fromHere $toThere #--partial is same as -P
    if [ "$?" = "0" ] ; then
        echo "rsync completed normally"
        exit
    else #non-zero exit code
        echo "Rsync failure. Backing off and retrying..."
        sleep 180
    fi
done
