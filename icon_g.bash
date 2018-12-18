#!/bin/bash

while getopts ":c:p:h:d:" opt; do
  case $opt in
    c)
      cyclec=$OPTARG
      echo "cycle is: $cyclec" >&2
      ;;
    p)
      path=$OPTARG
      echo "path is: $path" >&2
      ;;
    h)
      horizon=$OPTARG
      echo "horizon is: $horizon" >&2
      ;;
    d)
      date=$OPTARG
      echo "date is: $date" >&2
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

cyclec=$(date --date="${date} ${cyclec}:00:00 0 hours" +"%H")
cy=$(date --date="${date} ${cyclec}:00:00 0 hours" +%y)
cm=$(date --date="${date} ${cyclec}:00:00 0 hours" +%m)
cd=$(date --date="${date} ${cyclec}:00:00 0 hours" +%d)
echo current cycle 20${cy}-${cm}-${cd}-${cyclec}

exit



cd /home/angelos.d.lampiris/data/downloads
rm /home/angelos.d.lampiris/data/downloads/*
rm /home/angelos.d.lampiris/data/gribs/*

horizon=6
freq=3
start=0
kyklos=$cyclec
dur=$horizon
run=$kyklos


for ((i=$start;i<=$dur;i+=$freq)); do
kk=`printf "%03d" $i`;
s=`printf "%02d" $i`;
###DOWNLOADING 3-D GRIBS
for ((j=1;j<=60;j+=1)); do

#P
gp="https://opendata.dwd.de/weather/nwp/icon-eu/grib/${cyclec}/p/icon-eu_europe_regular-lat-lon_model-level_20${cy}${cm}${cd}${cyclec}_${kk}_${j}_P.grib2.bz2"
wget $gp &


#T
gt="https://opendata.dwd.de/weather/nwp/icon-eu/grib/${cyclec}/t/icon-eu_europe_regular-lat-lon_model-level_20${cy}${cm}${cd}${cyclec}_${kk}_${j}_T.grib2.bz2"
wget $gt &


#QV
gqv="https://opendata.dwd.de/weather/nwp/icon-eu/grib/${cyclec}/qv/icon-eu_europe_regular-lat-lon_model-level_20${cy}${cm}${cd}${cyclec}_${kk}_${j}_QV.grib2.bz2"
wget $gqv &


#U
gu="https://opendata.dwd.de/weather/nwp/icon-eu/grib/${cyclec}/u/icon-eu_europe_regular-lat-lon_model-level_20${cy}${cm}${cd}${cyclec}_${kk}_${j}_U.grib2.bz2"
wget $gu &


#V
gv="https://opendata.dwd.de/weather/nwp/icon-eu/grib/${cyclec}/v/icon-eu_europe_regular-lat-lon_model-level_20${cy}${cm}${cd}${cyclec}_${kk}_${j}_V.grib2.bz2"
wget $gv &

wait

bzip2 -d *.bz2
cat *.grib2 icon >> icon
rm *.bz2 *.grib2

done;

###DOWNLOADING 1-D GRIBS
gpmsl="https://opendata.dwd.de/weather/nwp/icon-eu/grib/${cyclec}/pmsl/icon-eu_europe_regular-lat-lon_single-level_20${cy}${cm}${cd}${cyclec}_${kk}_PMSL.grib2.bz2"
wget $gpmsl &

gpsfc="https://opendata.dwd.de/weather/nwp/icon-eu/grib/${cyclec}/ps/icon-eu_europe_regular-lat-lon_single-level_20${cy}${cm}${cd}${cyclec}_${kk}_PS.grib2.bz2"
wget $gpsfc &

gskin="https://opendata.dwd.de/weather/nwp/icon-eu/grib/${cyclec}/t_g/icon-eu_europe_regular-lat-lon_single-level_20${cy}${cm}${cd}${cyclec}_${kk}_T_G.grib2.bz2"
wget $gskin &

gt2m="https://opendata.dwd.de/weather/nwp/icon-eu/grib/${cyclec}/t_2m/icon-eu_europe_regular-lat-lon_single-level_20${cy}${cm}${cd}${cyclec}_${kk}_T_2M.grib2.bz2"
wget $gt2m &

grh2m="https://opendata.dwd.de/weather/nwp/icon-eu/grib/${cyclec}/relhum_2m/icon-eu_europe_regular-lat-lon_single-level_20${cy}${cm}${cd}${cyclec}_${kk}_RELHUM_2M.grib2.bz2"
wget $grh2m &

gu10m="https://opendata.dwd.de/weather/nwp/icon-eu/grib/${cyclec}/u_10m/icon-eu_europe_regular-lat-lon_single-level_20${cy}${cm}${cd}${cyclec}_${kk}_U_10M.grib2.bz2"
wget $gu10m &

gv10m="https://opendata.dwd.de/weather/nwp/icon-eu/grib/${cyclec}/v_10m/icon-eu_europe_regular-lat-lon_single-level_20${cy}${cm}${cd}${cyclec}_${kk}_V_10M.grib2.bz2"
wget $gv10m &

# gtso="https://opendata.dwd.de/weather/nwp/icon-eu/grib/${cyclec}/t_so/icon-eu_europe_regular-lat-lon_soil-level_20${cy}${cm}${cd}${cyclec}_${kk}_T_SO.grib2.bz2"
# wget $gtso &

# gwso="https://opendata.dwd.de/weather/nwp/icon-eu/grib/${cyclec}/w_so/icon-eu_europe_regular-lat-lon_soil-level_20${cy}${cm}${cd}${cyclec}_${kk}_W_SO.grib2.bz2"
# wget $gwso &

gwsnow="https://opendata.dwd.de/weather/nwp/icon-eu/grib/${cyclec}/w_snow/icon-eu_europe_regular-lat-lon_single-level_20${cy}${cm}${cd}${cyclec}_${kk}_W_SNOW.grib2.bz2"
wget $gwsnow &

ghsnow="https://opendata.dwd.de/weather/nwp/icon-eu/grib/${cyclec}/h_snow/icon-eu_europe_regular-lat-lon_single-level_20${cy}${cm}${cd}${cyclec}_${kk}_H_SNOW.grib2.bz2"
wget $ghsnow &

wait

bzip2 -d *.bz2
cat *.grib2 icon >> icon
rm *.bz2 *.grib2

mv icon /home/angelos.d.lampiris/data/gribs/icon_${kk}_20${cy}${cm}${cd}${cyclec}.grib2
rm /home/angelos.d.lampiris/data/downloads/*
done;

cd /home/angelos.d.lampiris/data/icon_int
ln -sf /home/angelos.d.lampiris/data/gribs/

cp ncl/land.grib2 .
cp ncl/hsurf.nc .
cp ncl/hhl.nc .
cp ncl/transformer.ncl .
