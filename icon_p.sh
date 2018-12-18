#!/bin/bash

###########CALcULATE CURENT CYCLE
###########
hour=$(date +"%H")

if [ "$hour" -ge 04 -a "$hour" -le 11 ]; then cyclec=00;  fi

if [ "$hour" -ge 11 -a "$hour" -lt 14 ]; then cyclec=06; fi

if [ "$hour" -ge 14 -a "$hour" -lt 17 ]; then cyclec=09; fi

if [ "$hour" -ge 17 -a "$hour" -le 23 ]; then cyclec=12;  fi

#if [ "$hour" -ge 20 -a "$hour" -le 23 ]; then cyclec=15;  fi


datetod=`date  +%Y%m%d`$cycle
cy=$(date  +%y)
cm=$(date  +%m)
cd=$(date  +%d)

if [ "$hour" -ge 23 -a "$hour" -le 24 ]; then cyclec=18;
cy=$(date  +%y)
cm=$(date  +%m)
cd=$(date  +%d)
fi

if [ "$hour" -ge 00 -a "$hour" -le 06 ]; then cyclec=18;
cy=$(date -d "1 day ago" +%y)
cm=$(date -d "1 day ago" +%m)
cd=$(date -d "1 day ago" +%d)
fi

date=${cy}${cm}${cd}
###########CALcULATE NEXT CYCLE
###########
cyclen=$(date --date="${date} ${cyclec}:00:00 3 hours" +"%H")
ny=$(date --date="${date} ${cyclec}:00:00 3 hours" +%y)
nm=$(date --date="${date} ${cyclec}:00:00 3 hours" +%m)
nd=$(date --date="${date} ${cyclec}:00:00 3 hours" +%d)

###########CALcULATE previous CYCLE
###########
cyclep=$(date --date="${date} ${cyclec}:00:00 3 hours ago" +"%H")
py=$(date --date="${date} ${cyclec}:00:00 3 hours ago" +%y)
pm=$(date --date="${date} ${cyclec}:00:00 3 hours ago" +%m)
pd=$(date --date="${date} ${cyclec}:00:00 3 hours ago" +%d)


echo past cycle 20${py}-${pm}-${pd}-${cyclep}
echo current cycle 20${cy}-${cm}-${cd}-${cyclec}
echo next cycle 20${ny}-${nm}-${nd}-${cyclen}

cd /mirror/uems/icon_scripts/tests_cat
rm *
rm /mirror/uems/icon_scripts/gribs/*

horizon=6
freq=3
start=0
kyklos=$cyclec
dur=$horizon
run=$kyklos

###DOWNLOADING 3-D GRIBS
for ((i=$start;i<=$dur;i+=$freq)); do
kk=`printf "%03d" $i`;
s=`printf "%02d" $i`;
for ((j=1;j<=60;j+=1)); do

#P
gp="https://opendata.dwd.de/weather/nwp/icon-eu/grib/${cyclec}/p/icon-eu_europe_regular-lat-lon_model-level_20${cy}${cm}${cd}${cyclec}_${kk}_${j}_P.grib2.bz2"
wget $gp &


wait

bzip2 -d *.bz2
cat *.grib2 icon >> icon
rm *.bz2 *.grib2

done;

mv icon /mirror/uems/icon_scripts/gribs/icon_${kk}_20${cy}${cm}${cd}${cyclec}.grib2
rm *
done;
