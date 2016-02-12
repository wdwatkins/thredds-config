#!/bin/bash
for f in stage4/*
    do tar -xvf "${f}"
    for n in ./ST4*
        do tar -xvf "${n}"
        rm $n
        for g in ./*.Z
            do b=$(basename "${g}" .Z)
            gunzip -c "${g}" > data/"${b}"
            rm "${g}"
        done
        for g2 in ./*.gz
            do b2=$(basename "${g2}" .gz)
            gunzip -c "${g2}" > data/"${b2}"
            rm "${g2}"
        done
        rm *.gif
    done
done