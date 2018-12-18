#!/bin/bash


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
TARGETFOLDER='/plots'

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
