ncdump -h $1 | grep float | grep ave24h | cut -f2 -d" " | awk '{gsub("_ave24h\\(g1_lat_0,", ""); print $0}' ORS='*,' > vars_24h.txt 
