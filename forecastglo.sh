#!/bin/bash

while getopts ":c:p:h:d:" opt; do
  case $opt in
    c)
      cycle=$OPTARG
      echo "cycle is: $cycle" >&2
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

#exit 0

cyclec=$(date --date="${date} ${cycle}:00:00 0 hours " +%H)
cy=$(date --date="${date} ${cycle}:00:00 0 hours " +%y)
cm=$(date --date="${date} ${cycle}:00:00 0 hours " +%m)
cd=$(date --date="${date} ${cycle}:00:00 0 hours " +%d)


cd /home/angelos/scripts/mars

rm -f maps2.html
cp -f forecastnew12.html maps2.html

COUNTER=2
bay=0
while [  $COUNTER -lt 10 ]; do
  string=$(date --date "$analysis ${cyclec}:00:00 ${bay} hours" "+%d-%m-%Y at %H UTC")

  sed -i "s/tralala$COUNTER/${string}/g" maps2.html
  let bay=bay+6
  echo The counter is $COUNTER
  let COUNTER=COUNTER+1
done

COUNTER=1
while [  $COUNTER -lt 10 ]; do
  string=$(date --date "$analysis ${cyclec}:00:00 ${bay} hours" "+%d-%m-%Y at %H UTC")
  sed -i "s/tralalb$COUNTER/${string}/g" maps2.html
  let bay=bay+6
  echo The counter is $COUNTER
  let COUNTER=COUNTER+1
done


COUNTER=1
while [  $COUNTER -lt 10 ]; do
  string=$(date --date "$analysis ${cyclec}:00:00 ${bay} hours" "+%d-%m-%Y at %H UTC")
  sed -i "s/tralalc$COUNTER/${string}/g" maps2.html
  let bay=bay+6
  echo The counter is $COUNTER
  let COUNTER=COUNTER+1
done


COUNTER=1
while [  $COUNTER -lt 10 ]; do
  string=$(date --date "$analysis ${cyclec}:00:00 ${bay} hours" "+%d-%m-%Y at %H UTC")
  sed -i "s/tralald$COUNTER/${string}/g" maps2.html
  let bay=bay+6
  echo The counter is $COUNTER
  let COUNTER=COUNTER+1
done

COUNTER=1
while [  $COUNTER -lt 10 ]; do
  string=$(date --date "$analysis ${cyclec}:00:00 ${bay} hours" "+%d-%m-%Y at %H UTC")
  sed -i "s/tralale$COUNTER/${string}/g" maps2.html
  let bay=bay+6
  echo The counter is $COUNTER
  let COUNTER=COUNTER+1
done

COUNTER=1
while [  $COUNTER -lt 10 ]; do
  string=$(date --date "$analysis ${cyclec}:00:00 ${bay} hours" "+%d-%m-%Y at %H UTC")
  sed -i "s/tralalf$COUNTER/${string}/g" maps2.html
  let bay=bay+6
  echo The counter is $COUNTER
  let COUNTER=COUNTER+1
done

COUNTER=1
while [  $COUNTER -lt 10 ]; do
  string=$(date --date "$analysis ${cyclec}:00:00 ${bay} hours" "+%d-%m-%Y at %H UTC")
  sed -i "s/tralalg$COUNTER/${string}/g" maps2.html
  let bay=bay+6
  echo The counter is $COUNTER
  let COUNTER=COUNTER+1
done


cp -f maps2.html global.html


exit 0
