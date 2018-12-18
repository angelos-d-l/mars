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
 export NCARG_ROOT=/home/angelos.d.lampiris/ncl
    NCARG_ROOT=/home/angelos.d.lampiris/ncl
     PATH=/home/angelos.d.lampiris/ncl/bin:$PATH
     export NCARG_ROOT
     export PATH

ulimit -s unlimited
# export LD_LIBRARY_PATH=/home/angelos/net/lib:${LD_LIBRARY_PATH}

horizon=36
cd /home/angelos.d.lampiris/uems/uems/runs/bench
. ../../etc/EMS.profile
ems_prep --dset gfsp25pt  --length ${horizon} --cycle ${cyclec}  --sfc sportsstpt   --date 20${cy}${cm}${cd}



ems_run --debug wrfm
sed -i '/ nproc_y                    = 16/c\ nproc_y                    = 30' namelist.input
time /home/angelos.d.lampiris/uems/uems/util/mpich2/bin/mpiexec.gforker  -n 30  /home/angelos.d.lampiris/uems/uems/bin/wrfm_arw.exe
mv wrfout_d01_* wrfprd/

ems_post --grads


shopt -s extglob


cd /home/angelos.d.lampiris/work

rm -f *

ln -sf /home/angelos.d.lampiris/uems/uems/runs/bench/emsprd/grads/* .
mv *.ctl in.ctl
if [ ! -f ./in.ctl ]; then
    exit 0
fi

cp /home/angelos.d.lampiris/scripts/gr_fw/* .

SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
a=1
for f in *.gs
do
  echo "$f"&
grads -blcx $f &

done
wait

rm -f /home/angelos.d.lampiris/er_img/*

mv *.png /home/angelos.d.lampiris/er_img/

rm *.gs

###DO pre
cp -f /home/angelos.d.lampiris/scripts/gr_comp3/* .

grads  -a 1.2029  -bcx rain.gs

mv pre*.png /home/angelos.d.lampiris/er_img/

rm *.gs

cp -f /home/angelos.d.lampiris/scripts/gr_ath/* .

SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
a=1
for f in *.gs
do
  echo "$f"&
grads -blcx $f &

done
wait

mv *.png /home/angelos.d.lampiris/er_img/



# DISTANT DIRECTORY
TARGETFOLDER='/plots3'

#LOCAL DIRECTORY
SOURCEFOLDER='/home/angelos.d.lampiris/er_img/'

HOST='files.antimeteo.gr'
USER='angelos'
PASS='al578899!'

lftp -f "
set ftp:ssl-allow no
open $HOST
user $USER $PASS
lcd $SOURCEFOLDER
mirror --delete-first --transfer-all --parallel=100 --reverse  --verbose $SOURCEFOLDER $TARGETFOLDER
bye
"
sudo shutdown -h now



exit 0
