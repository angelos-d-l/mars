#!/bin/bash
#####################################################
#######################CYCLE BLOCK###################
#####################################################


###########CALcULATE CURENT CYCLE
###########
hour=$(date +"%H")
if [ "$hour" -ge 04 -a "$hour" -le 11 ]; then cyclec=00;  fi

if [ "$hour" -ge 11 -a "$hour" -lt 17 ]; then cyclec=06; fi

if [ "$hour" -ge 17 -a "$hour" -le 23 ]; then cyclec=12;  fi


datetod=`date  +%Y%m%d`$cycle
cy=$(date  +%y)
cm=$(date  +%m)
cd=$(date  +%d)

if [ "$hour" -ge 23 -a "$hour" -le 24 ]; then cyclec=18;
cy=$(date  +%y)
cm=$(date  +%m)
cd=$(date  +%d)
fi

if [ "$hour" -ge 00 -a "$hour" -le 04 ]; then cyclec=18;
cy=$(date -d "1 day ago" +%y)
cm=$(date -d "1 day ago" +%m)
cd=$(date -d "1 day ago" +%d)
fi

date=${cy}${cm}${cd}
###########CALcULATE NEXT CYCLE
###########
cyclen=$(date --date="${date} ${cyclec}:00:00 6 hours" +"%H")
ny=$(date --date="${date} ${cyclec}:00:00 6 hours" +%y)
nm=$(date --date="${date} ${cyclec}:00:00 6 hours" +%m)
nd=$(date --date="${date} ${cyclec}:00:00 6 hours" +%d)

###########CALcULATE previous CYCLE
###########
cyclep=$(date --date="${date} ${cyclec}:00:00 6 hours ago" +"%H")
py=$(date --date="${date} ${cyclec}:00:00 6 hours ago" +%y)
pm=$(date --date="${date} ${cyclec}:00:00 6 hours ago" +%m)
pd=$(date --date="${date} ${cyclec}:00:00 6 hours ago" +%d)


echo past cycle 20${py}-${pm}-${pd}-${cyclep}
echo current cycle 20${cy}-${cm}-${cd}-${cyclec}
echo next cycle 20${ny}-${nm}-${nd}-${cyclen}
daten=${ny}${nm}${nd}

#####################################################
#######################CYCLE BLOCK###################
#####################################################
export NCARG_USRRESFILE=/home/angelos/.hluresfile2
export NCARG_ROOT=/home/angelos/ncl
   NCARG_ROOT=/home/angelos/ncl
    PATH=/home/angelos/ncl/bin:$PATH
    export NCARG_ROOT
    export PATH
export KMP_STACKSIZE=500000000
ulimit -s unlimited
export LD_LIBRARY_PATH=/home/angelos/net/lib:${LD_LIBRARY_PATH}

horizon=39

cd  /mirror/uems/nuems2/uems/runs/3dv
. ../../etc/EMS.profile
#rm grib/*

ems_prep --domains 2 --dset gfsp25pt  --length ${horizon} --cycle ${cyclec}     --date 20${cy}${cm}${cd}

#ems_prep --domains 2 --dset gfsp25pt  --length 24 --cycle 00  --date 20190215

ems_run --domains 2 --nodfi


ems_post --grads --domain 2




cd emsprd/grads/
mv *.ctl in.ctl
if [ ! -f ./in.ctl ]; then
    exit 0
fi
cp /home/angelos/gr_fw2/* .
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
a=1
for f in *.gs
do
  echo "$f"&
grads -blcx $f &

done
wait

rm -f /mirror/ssd/nmmd01/*

mv *.png /mirror/ssd/nmmd01/

rm *.gs

###DO pre
cp -f /home/angelos/gr_comp3/* .
grads  -a 1.2029  -bcx rain.gs
mv pre*.png /mirror/ssd/nmmd01/

rm *.gs


cp -f /home/angelos/gr_ath/*.gs .
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
a=1
for f in *.gs
do
  echo "$f"&
grads -blcx $f &

done
wait


mv *.png /mirror/ssd/nmmd01/

cd  /mirror/uems/nuems2/uems/runs/3dv
. ../../etc/EMS.profile


ems_post --grads

cd emsprd/grads/
mv *.ctl in.ctl
if [ ! -f ./in.ctl ]; then
    exit 0
fi
cp /home/angelos/gr_fw2/* .
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
a=1
for f in *.gs
do
  echo "$f"&
grads -blcx $f &

done
wait

rm -f /mirror/ssd/nmmd02/*

mv *.png /mirror/ssd/nmmd02/

rm *.gs

cp /home/angelos/gr_gl2/* .
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
