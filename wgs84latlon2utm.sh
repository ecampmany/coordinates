#!/bin/bash
if [ $# -lt 2 ]; then
echo "Usage: wgs84latlon2utm lat lon (epsg)
\$epsg retrieved from spatialreference.org or user-defined">&2
exit 1
fi

lat=$1
lon=$2
zone=`echo $lon | awk '{print int(1+($1+180.0)/6.0)}'`
hemisphere=`echo $lat | awk '{if ($1<0) print "S"; else print "N"}'`


if [ $# -eq 2 ]; then
utm_zone=$zone$hemisphere
epsg=`cat epsg_utm_84.txt | awk '/[^0-9]'$utm_zone'/ { print substr($1,1,length($1)-1) }'`
fi
if [ $# -eq 3 ]; then
epsg=$3
fi 

coord=`echo $lon $lat | gdaltransform -s_srs EPSG:4326 -t_srs $epsg`
echo $coord | awk '{printf "%9.6f %10.6f\n", $1,$2}'
