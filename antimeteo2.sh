#!/bin/bash


export NCARG_ROOT=/home/angelos.d.lampiris/ncl
   NCARG_ROOT=/home/angelos.d.lampiris/ncl
    PATH=/home/angelos.d.lampiris/ncl/bin:$PATH
    export NCARG_ROOT
    export PATH
######Weather Spot
#export LD_LIBRARY_PATH=/home/angelos/anaconda2/pkgs/libgfortran-3.0.0-1/lib/:${LD_LIBRARY_PATH}
cd ~/updb
rm -f *
cp ../updb_sc2/* .
ln -sf /home/angelos.d.lampiris/uems/uems/runs/bench/wrfprd/wrfout_d01* .
ncl tear.ncl
ncl tempclc.ncl
mv temp2.nc temp.nc
./translator_emergencyRun_winter.exe

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
#time xz -9 --threads=0 weatherspot.txt
source /home/angelos.d.lampiris/anaconda3/bin/activate base
python update36.py

rm weatherspot.txt
mv weather2.txt weatherspot.txt

lftp -c "set ftp:ssl-allow no; open -u angelos,al578899! files.antimeteo.gr; put -O weatherspot/ /home/angelos.d.lampiris/updb/weatherspot.txt"
#curl https://files.antimeteo.gr/weatherspot/ll.php
curl https://files.antimeteo.gr/weatherspot/dailyupdate.php
