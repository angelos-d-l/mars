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

horizon=96
cd  /mirror/uems/nuems2/uems/runs/bartzabel
. ../../etc/EMS.profile


ems_prep --dset gfsp25pt  --length ${horizon} --cycle ${cyclec}  --sfc sportsstpt   --date 20${cy}${cm}${cd}



ems_run


ems_post --grads


cd emsprd/grads/
mv *.ctl in.ctl
tar cvf today.tar *
rsync  -avz -e "ssh -i ~/.ssh/gfw" --stats --progress  today.tar doctoral88@35.204.124.143:~/wrfData

ssh -i ~/.ssh/gfw doctoral88@35.204.124.143 /home/doctoral88/images_bartzabel.sh


/home/angelos/scripts/forecast2.sh -c ${cyclec} -d 20${cy}${cm}${cd} -h ${horizon}

cd /home/angelos/scripts

HOST='forecastweather.gr'
USER='forecast'
PASSWD='stam042727mg19912018'
FILE='index.html'

ftp -n $HOST <<END_SCRIPT
quote USER $USER
quote PASS $PASSWD
binary
cd /public_html/prognosi
put $FILE
quit
END_SCRIPT



exit 0
