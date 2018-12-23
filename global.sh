#!/bin/bash

cd  /mirror/uems/nuems2/uems/runs/g2
. ../../etc/EMS.profile
#rm grib/*
ems_prep --dset gfsp50  --length 360

ems_run
ems_post --grads


cd emsprd/grads/
mv *.ctl in.ctl
if [ ! -f ./in.ctl ]; then
    exit 0
fi
cp /home/angelos/gr_gl/* .
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
a=1
for f in *.gs
do
  echo "$f"&
grads -blcx $f &

done
wait

rm -f /mirror/ssd/global/*

mv *.png /mirror/ssd/global/
