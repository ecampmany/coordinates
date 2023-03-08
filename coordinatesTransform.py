from osgeo import ogr
from osgeo import osr
import argparse

parser = argparse.ArgumentParser(description='Converts coordinates. Input arguments are EPSG code input, EPSD code output, X, Y.')
parser.add_argument("--epsg_input",help="EPSG code for input coordinates",default="4326",required=True)
parser.add_argument("--epsg_output",help="EPSG code for output coordinates",default="4326",required=True)
parser.add_argument("--x",help="x coordinates in epsg_input coordinates",default="0",required=True)
parser.add_argument("--y",help="y coordinates in epsg_input coordinates",required=True)


args = parser.parse_args()
#EPSG CODES: https://spatialreference.org/ref/epsg/?page=1 (or google it)

InSR = osr.SpatialReference()
InSR.ImportFromEPSG(int(args.epsg_input))       
OutSR = osr.SpatialReference()
OutSR.ImportFromEPSG(int(args.epsg_output))     

Point = ogr.Geometry(ogr.wkbPoint)
Point.AddPoint(int(args.x),int(args.y)) # use your coordinates here
Point.AssignSpatialReference(InSR)    # tell the point what coordinates it's in
Point.TransformTo(OutSR)              # project it to the out spatial reference
print ('{0},{1}'.format(Point.GetX(),Point.GetY())) # output projected X and Y coordinates

