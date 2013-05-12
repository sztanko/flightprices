from math import radians, cos, sin, asin, sqrt
import sys


def haversine( lat1, lon1, lat2, lon2):
    """
    Calculate the great circle distance between two points 
    on the earth (specified in decimal degrees)
    """
    # convert decimal degrees to radians 
    lon1, lat1, lon2, lat2 = map(radians, [float(lon1), float(lat1), float(lon2), float(lat2)])
    # haversine formula 
    dlon = lon2 - lon1 
    dlat = lat2 - lat1 
    a = sin(dlat/2)**2 + cos(lat1) * cos(lat2) * sin(dlon/2)**2
    c = 2 * asin(sqrt(a)) 
    km = int(6367 * c)
    return km

c=0
for line in sys.stdin.readlines():
	t = line.strip().split("\t")
	if c==0:
		t.append("distance")
	else:
		t.append( str( haversine( t[-4], t[-3], t[-2], t[-1] )))
	print "\t".join(t)
	c+=1


