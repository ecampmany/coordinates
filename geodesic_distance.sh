#!/bin/bash
if [ $# -ne 4 ]; then
echo "Usage: geodetic_distance lat1 lon1 lat2 lon2
Distance between point1 and point2 in geographic coordinates ">&2
exit 1
fi
LAT=$1
LON=$2
lat=$3
lon=$4
PI=3.1415927
geo=`echo $lat $lon | awk '{print sin($1*('$PI'/180))*sin('$LAT'*('$PI'/180)) + cos($1*('$PI'/180))*cos('$LAT'*('$PI'/180))*cos
(('$LON'-$2)*('$PI'/180))}'`
echo $geo | awk '{print 6371.0*atan2(sqrt(1.-$1*$1), $1)}'

