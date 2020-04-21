#!/bin/bash

mkdir -p compressed
for f in *.nc;
do
  ncks -4 --cnk_plc=nco --cnk_map='rew' -L 1 $f compressed/$f
  echo $f
done

