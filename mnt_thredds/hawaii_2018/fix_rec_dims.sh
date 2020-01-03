#!/bin/bash

mkdir fixed
for f in *.nc;
do
        start=$SECONDS
        ncks --fix_rec_dmn Time $f fixed/$f
        duration=$(( SECONDS - start ))
        echo $f $duration seconds
done