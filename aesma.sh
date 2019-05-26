#!/bin/bash

export NCARG_USRRESFILE=/home/angelos/.hluresfile2
export NCARG_ROOT=/home/angelos/ncl
   NCARG_ROOT=/home/angelos/ncl
    PATH=/home/angelos/ncl/bin:$PATH
    export NCARG_ROOT
    export PATH
export KMP_STACKSIZE=500000000
ulimit -s unlimited
export LD_LIBRARY_PATH=/home/angelos/net/lib:${LD_LIBRARY_PATH}


cd  /mirror/uems/nuems2/uems/runs/asmodeus_v1
. ../../etc/EMS.profile


mv /home/angelos/run.tar.gz .

tar xvfz run.tar.gz

cp /mirror/uems/nuems2/uems/data/tables/wrf/physics/lsm/*  .
cp /mirror/uems/nuems2/uems/data/tables/wrf/physics/micro/*  .
cp /mirror/uems/nuems2/uems/data/tables/wrf/physics/radn/*  .


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



######Weather Spot
export LD_LIBRARY_PATH=/home/angelos/anaconda2/pkgs/libgfortran-3.0.0-1/lib/:${LD_LIBRARY_PATH}
cd ~/updb
rm -f *
cp ../updb_sc2/* .
ln -sf /mirror/uems/nuems2/uems/runs/asmodeus_v1/wrfprd/wrfout_d01* .
ncl tear.ncl
ncl tempclc.ncl
mv temp2.nc temp.nc
./translator_winter.exe

#############################################
############################################

if [ -s ./weatherspot.txt ]
then
        echo "weatherspot.txt has some data."
        # do something as file has data
else
        echo "weatherspot.txt is empty."
        exit 0
        # do something as file is empty
fi

#############################################
############################################
time xz -9 --threads=0 weatherspot.txt
rsync  -avz -e "ssh -i ~/.ssh/gfw" --stats --progress ~/updb/weatherspot.txt.xz  doctoral88@35.204.124.143:~/
ssh -i ~/.ssh/gfw doctoral88@35.204.124.143 /home/doctoral88/update_asmodeus.sh




exit 0

rsync  -avz -e "ssh -i ~/.ssh/gfw" --stats --progress doctoral88@35.204.124.143:~/weatherspot.txt ~/updb/
lftp -c "set ftp:ssl-allow no; open -u angelos,al578899! files.antimeteo.gr; put -O weatherspot/ /home/doctoral88/weatherspot.txt"

# DISTANT DIRECTORY
TARGETFOLDER='/public_html/prognosi/secular'

#LOCAL DIRECTORY
SOURCEFOLDER='/mirror/ssd/nmmd01/'

HOST='forecastweather.gr'
USER='forecast'
PASS='stam042727mg19912018'

lftp -f "
set ftp:ssl-allow no
open $HOST
user $USER $PASS
lcd $SOURCEFOLDER
mirror --reverse --delete --verbose $SOURCEFOLDER $TARGETFOLDER
bye
"
















######Weather Spot
export LD_LIBRARY_PATH=/home/angelos/anaconda2/pkgs/libgfortran-3.0.0-1/lib/:${LD_LIBRARY_PATH}
cd ~/updb
rm -f *
cp ../updb_sc2/* .
ln -sf /mirror/uems/nuems2/uems/runs/asmodeus_v1/wrfprd/wrfout_d01* .
ncl tear.ncl
ncl tempclc.ncl
mv temp2.nc temp.nc
./translator.exe

#############################################
############################################

if [ -s ./weatherspot.txt ]
then
        echo "weatherspot.txt has some data."
        # do something as file has data
else
        echo "weatherspot.txt is empty."
        exit 0
        # do something as file is empty
fi

#############################################
############################################
lftp -c "set ftp:ssl-allow no; open -u angelos,al578899! files.antimeteo.gr; put -O weatherspot/ /home/angelos/updb/weatherspot.txt"
curl http://files.antimeteo.gr/weatherspot/ll.php
curl http://files.antimeteo.gr/weatherspot/dailyupdate.php

ssh angelos-s1 ~/grads.sh
ssh angelos-s1 /home/angelos/scripts/forecast3.sh -c ${cyclec} -d 20${cy}${cm}${cd} -h ${horizon}

scp angelos-s1:~/html/index.html ~/html/
cd ~/html/


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


# DISTANT DIRECTORY
TARGETFOLDER='/public_html/prognosi/secular'

#LOCAL DIRECTORY
SOURCEFOLDER='/mirror/ssd/nmmd01/'

HOST='forecastweather.gr'
USER='forecast'
PASS='stam042727mg19912018'

lftp -f "
set ftp:ssl-allow no
open $HOST
user $USER $PASS
lcd $SOURCEFOLDER
mirror --reverse --delete --verbose $SOURCEFOLDER $TARGETFOLDER
bye
"



exit 0
