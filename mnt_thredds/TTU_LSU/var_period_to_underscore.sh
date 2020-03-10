#!/bin/bash

for ncfile in *.nc;
do
  varnames=($(ncdump -h ${ncfile} | grep float | cut -d" " -f2 | cut -d"(" -f1 | grep "\."))
  varnames_underscore=($(echo "${varnames[@]}" | sed s/\\./_/g))
  if [ ${#varnames[@]} -ne ${#varnames_underscore[@]} ]
  then
    echo "variable name array lengths don't match!"
    exit 1
  fi
  final_index=$(echo ${#varnames[@]} - 1 | bc)
  for i in $(seq 0 ${final_index})
  do
    ncrename -v${varnames[${i}]},${varnames_underscore[${i}]} ${ncfile}
  done
  echo $ncfile done
done
