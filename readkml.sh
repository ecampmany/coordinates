#!/bin/bash
if [ $# -ne 1 ]; then
echo "Usage: readkml.sh file (*.kmz, *.kml) " >&2
exit 1
fi

# Read filename as input

filestring=$1

# Remove blank spaces in name. Split the filename and extension. 

cp "$filestring" "${filestring// /_}"
fileg=`echo $filestring | sed "s/ /_/g"`

filename=`echo $fileg | awk '{print substr($1,1,length($1)-4)}'`
fileext=`echo $fileg | awk '{print substr($1,length($1)-2,3)}'`
echo $fileg

# In case of kmz, unzip it

if [[ $fileext == "kmz" ]]; then
rm doc.kml
unzip $fileg
mv doc.kml $filename.kml
fi

# Read all the coordinates between <coordinates> and </coordinates> inside
# <LinearRing> (could be also inside <Polygon>
# Multiple strings with longitude,latitude,(altitude) space separated 
# Print all the latitudes/longitudes printing all the seconds/firsts 
# Sort the values and store the min and max value, first and last.

latitudes=`awk '/<LinearRing>/{flag=1;next}/<\/LinearRing>/{flag=0}flag' $filename.kml | awk '/<coordinates>/{flag=1;next}/<\/coordinates>/{flag=0}flag {print $0}' | awk '{for (i=1; i<=NF; i++) {split($i,a,",") ; print a[2]}}' | sort | awk 'NR == 1 { print }END{ print }'` 

longitudes=`awk '/<LinearRing>/{flag=1;next}/<\/LinearRing>/{flag=0}flag' $filename.kml | awk '/<coordinates>/{flag=1;next}/<\/coordinates>/{flag=0}flag' | awk '{for (i=1; i<=NF; i++) {split($i,a,",") ; print a[1]}}' | sort | awk 'NR == 1 { print }END{ print }'`


# Calculate geodesic distance between latitudes and longitudes

latmin=`echo $latitudes | awk '{print $1}'`
latmax=`echo $latitudes | awk '{print $2}'`
lonmin=`echo $longitudes | awk '{print $1}'`
lonmax=`echo $longitudes | awk '{print $2}'`

PI=3.141592653589793

hor=`echo $latmin $lonmin | awk '{print sin($1*('$PI'/180))*sin('$latmin'*('$PI'/180)) + cos($1*('$PI'/180))*cos('$latmin'*('$PI'/180))*cos(('$lonmax'-$2)*('$PI'/180))}'`
horizontal=`echo $hor | awk '{print 6371.0*atan2(sqrt(1.-$1*$1), $1)}'`

ver=`echo $latmin $lonmax | awk '{print sin($1*('$PI'/180))*sin('$latmax'*('$PI'/180)) + cos($1*('$PI'/180))*cos('$latmax'*('$PI'/180))*cos(('$lonmax'-$2)*('$PI'/180))}'`
vertical=`echo $ver | awk '{print 6371.0*atan2(sqrt(1.-$1*$1), $1)}'`

# Print final area

echo $horizontal $vertical | awk '{print "AREA (km2): "$1*$2}'
echo " "

# Add Minimum Bounding Box to GoogleEarth file 

echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<kml xmlns=\"http://www.opengis.net/kml/2.2\">
        <Placemark>
	<Style id=\"yellowPoly\">
		<LineStyle>
        		<color>7f00ffff</color>
        		<width>4</width>
      		</LineStyle>
      		<PolyStyle>
        		<color>7f00ff00</color>
        		<fill>0</fill>
      		</PolyStyle>
    	</Style>
		<Polygon>
                <extrude>1</extrude>
                <tesselate>1</tesselate>
                <altitudeMode>relativeToGround</altitudeMode>
                <outerBoundaryIs>
                    <LinearRing>
                        <coordinates>
                            $lonmin,$latmin,0  
                            $lonmin,$latmax,0  
                            $lonmax,$latmax,0  
                            $lonmax,$latmin,0
		            $lonmin,$latmin,0
                        </coordinates>
                    </LinearRing>
                </outerBoundaryIs>
            </Polygon>
        </Placemark>
</kml>"  > $filename.box.kml

	echo "UPDATE mshop_runs SET run_p1lat = $latmax,run_p1lng= $lonmin,run_p2lat = $latmax,run_p2lng = $lonmax,run_p3lat= $latmin,run_p3lng=$lonmax,run_p4lat=$latmin,run_p4lng=$lonmin where run_id =  ";
