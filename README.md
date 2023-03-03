# coordinates

Set of very simple geographical tools written in bash:

* **wgs84utm2latlon.sh** Transform geographical coordinates from UTM to Latitude and Longitude<br> 
(Dependencies: GDAL libraries and epsg_utm_84.txt required)

* **wgs84lat2utm.sh** Transform geographical coordinates from Latitude and Longitude to UTM <br>
(Dependencies: GDAL libraries and epsg_utm_84.txt required)

* **geodetic_distance.sh**: Calculate geodetic distance between two points defined by latitude and longitude

* **readkml.sh**: Calculate the area of the minimum bounding box parallel to Equator for any irregular polygone in a kml file
