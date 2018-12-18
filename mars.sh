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
#  export NCARG_ROOT=/home/angelos.d.lampiris/ncl
#     NCARG_ROOT=/home/angelos.d.lampiris/ncl
#      PATH=/home/angelos.d.lampiris/ncl/bin:$PATH
#      export NCARG_ROOT
#      export PATH
# export LD_LIBRARY_PATH=/home/angelos/net/lib:${LD_LIBRARY_PATH}
#. ../../etc/EMS.profile

ulimit -s unlimited
horizon=18
cd /home/angelos.d.lampiris/uems/uems/runs/bench
ems_prep --debug metgrid --dset gfsp25pt  --length ${horizon} --cycle ${cyclec}  --sfc sportsstpt   --date 20${cy}${cm}${cd}

time /home/angelos.d.lampiris/uems/data/scripts/icon_g.sh -c ${cyclec} -h ${horizon} -d 20${cy}${cm}${cd} -f 1

cp /home/angelos.d.lampiris/uems/data/icon_int/ICONX3* wpsprd/

python /home/angelos.d.lampiris/uems/control/wps.py
mv tmp.txt namelist.wps

time /home/angelos.d.lampiris/uems/uems/util/mpich2/bin/mpiexec.gforker  -n 17 /home/angelos.d.lampiris/uems/uems/bin/metgrid

rm METGRID.TBL metgrid.log.* namelist.wps

cp /home/angelos.d.lampiris/uems/uems/data/tables/wrf/physics/lsm/* .
cp /home/angelos.d.lampiris/uems/uems/data/tables/wrf/physics/micro/* .
cp /home/angelos.d.lampiris/uems/uems/data/tables/wrf/physics/radn/* .
ln -sf wpsprd/met_em* .

###########CALcULATE end
###########
cyclen=$(date --date="${date} ${cyclec}:00:00 ${horizon} hours" +"%H")
ny=$(date --date="${date} ${cyclec}:00:00 ${horizon} hours" +%y)
nm=$(date --date="${date} ${cyclec}:00:00 ${horizon} hours" +%m)
nd=$(date --date="${date} ${cyclec}:00:00 ${horizon} hours" +%d)

###########CALcULATE dfi start
###########
hdfi1=$(date --date="${date} ${cyclec}:00:00 1 hours ago" +"%H")
ydfi1=$(date --date="${date} ${cyclec}:00:00 1 hours ago" +%y)
mdfi1=$(date --date="${date} ${cyclec}:00:00 1 hours ago" +%m)
ddfi1=$(date --date="${date} ${cyclec}:00:00 1 hours ago" +%d)

###########CALcULATE dfi end
###########
hdfi2=$(date --date="${date} ${cyclec}:00:00 0 hours" +"%H")
ydfi2=$(date --date="${date} ${cyclec}:00:00 0 hours" +%y)
mdfi2=$(date --date="${date} ${cyclec}:00:00 0 hours" +%m)
ddfi2=$(date --date="${date} ${cyclec}:00:00 0 hours" +%d)

cp -f /home/angelos.d.lampiris/uems/namelists/namelist.eme ./namelist.input
sed -i '/ start_year                 = 2018/c\ start_year                 = 20'${cy} namelist.input
sed -i '/ start_month                = 12/c\ start_month                = '${cm} namelist.input
sed -i '/ start_day                  = 09/c\ start_day                  = '${cd} namelist.input
sed -i '/ start_hour                 = 12/c\ start_hour                 = '${cyclec} namelist.input

sed -i '/ end_year                   = 2018/c\ end_year                   = 20'${ny} namelist.input
sed -i '/ end_month                  = 12/c\ end_month                  = '${nm} namelist.input
sed -i '/ end_day                    = 09/c\ end_day                    = '${nd} namelist.input
sed -i '/ end_hour                   = 18/c\ end_hour                   = '${cyclen} namelist.input


sed -i '/ dfi_fwdstop_year           = 2018/c\ dfi_fwdstop_year           = 20'${ydfi2} namelist.input
sed -i ' dfi_fwdstop_month          = 12/c\ dfi_fwdstop_month          = '${mdfi2} namelist.input
sed -i '/ dfi_fwdstop_day            = 09/c\ dfi_fwdstop_day            = '${ddfi2} namelist.input
sed -i '/ dfi_fwdstop_hour           = 12/c\ dfi_fwdstop_hour           = '${hdfi2} namelist.input


sed -i '/ dfi_bckstop_year           = 2018/c\ dfi_bckstop_year           = 20'${ydfi1} namelist.input
sed -i ' dfi_bckstop_month          = 12/c\ dfi_bckstop_month          = '${mdfi1} namelist.input
sed -i '/ dfi_bckstop_day            = 09/c\ dfi_bckstop_day            = '${ddfi1} namelist.input
sed -i '/ dfi_bckstop_hour           = 11/c\ dfi_bckstop_hour           = '${hdfi1} namelist.input

time /home/angelos.d.lampiris/uems/uems/util/mpich2/bin/mpiexec.gforker  -n 34  /home/angelos.d.lampiris/uems/uems/bin/real_arw.exe


time /home/angelos.d.lampiris/uems/uems/util/mpich2/bin/mpiexec.gforker  -n 60  /home/angelos.d.lampiris/uems/uems/bin/wrfm_arw.exe

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

rm -f /home/angelos.d.lampiris/latest/*

mv *.png /home/angelos.d.lampiris/latest/

rm *.gs

###DO pre
cp -f /home/angelos.d.lampiris/scripts/gr_comp3/* .

grads  -a 1.2029  -bcx rain.gs

mv pre*.png /home/angelos.d.lampiris/latest/

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

mv *.png /home/angelos.d.lampiris/latest/


# DISTANT DIRECTORY
TARGETFOLDER='/plots3'

#LOCAL DIRECTORY
SOURCEFOLDER='/home/angelos.d.lampiris/latest/'

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
