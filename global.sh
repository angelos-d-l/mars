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
horizon=168
cd  /mirror/uems/nuems2/uems/runs/g2
. ../../etc/EMS.profile
rm grib/*
ems_prep --dset gfsp50  --length ${horizon}

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


/home/angelos/scripts/mars/forecastglo.sh -c ${cyclec} -d 20${cy}${cm}${cd} -h ${horizon}

cd /home/angelos/scripts/mars

HOST='forecastweather.gr'
USER='forecast'
PASSWD='stam042727mg19912018'
FILE='global.html'

ftp -n $HOST <<END_SCRIPT
quote USER $USER
quote PASS $PASSWD
binary
cd /public_html/prognosi
put $FILE
quit
END_SCRIPT



# DISTANT DIRECTORY
TARGETFOLDER='/public_html/prognosi/glim'

#LOCAL DIRECTORY
SOURCEFOLDER='/mirror/ssd/global/'

HOST='forecastweather.gr'
USER='forecast'
PASS='stam042727mg19912018'

lftp -f "
set ftp:ssl-allow no
open $HOST
user $USER $PASS
lcd $SOURCEFOLDER
mirror --delete-first --transfer-all --parallel=10 --reverse  --verbose $SOURCEFOLDER $TARGETFOLDER
bye
"


exit 0
#/public_html/prognosi/glim
