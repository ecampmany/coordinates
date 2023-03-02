if [ $# -lt 3 ]; then
echo "Usage: wgs84utm2latlon utmx utmy zone (epsg)
$epsg retrieved from spatialreference.org or user-defined">&2
exit 1
fi

utmx=$1
utmy=$2
zone=$3

if [ $# -eq 3 ]; then

utm_zone=$zone
epsg=`cat /Users/elies/Vortex/bin/epsg_utm_84.txt | awk '/[^0-9]'$utm_zone'/ { print substr($1,1,length($1)-1) }'`
fi

if [ $# -eq 4 ]; then
epsg=$4
fi

coord=`echo $utmx $utmy | gdaltransform -s_srs $epsg -t_srs EPSG:4326`
lat=`echo $coord | awk '{print $2}'`
lon=`echo $coord | awk '{print $1}'`
echo $lat, $lon | awk '{printf "%9.6f %10.6f\n", $1,$2}'
