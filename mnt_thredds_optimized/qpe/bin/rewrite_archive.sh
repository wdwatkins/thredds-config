for i in {0..120} 
	do
	let t=$i*1000
	let t2=$i*1000+999
	command="nccopy -k 3 -d 1 -m 10M -u -c time/1,x/75,y/60 http://localhost:8080/thredds/dodsC/scan/stage4.ncml?time[$t:1:$t2],time_bounds[$t:1:$t2][0:1:1],Total_precipitation_surface_1_Hour_Accumulation[$t:1:$t2][0:1:880][0:1:1120],lat[0:1:1120][0:1:880],lon[0:1:1120][0:1:880] stage4_map_$i.nc" 
	echo $command
	$command
done
