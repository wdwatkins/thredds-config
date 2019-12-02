
#add calendar attributes to CESM files
#ran separately
#for f in *CESM.nc; do echo $f; ncatted -a calendar,'time_int',c,c,'noleap' $f; done 

for f in *.nc;
do
	ncatted -a _CoordinateAxisType,'time_int',c,c,'Time' $f;
	ncatted -a _CoordinateAxisType,'XLONG',c,c,'Lon' $f;
	ncatted -a _CoordinateAxisType,'XLAT',c,c,'Lat' $f;
	echo $f
done

