from pyquery import PyQuery as pq
import sys, json 
#unicodeData.encode('ascii', 'ignore')

#url = "http://www.skyscanner.net/flights-from/%s/%s/cheapest-flights-from-%s-in-%s.html?di=1" %(city,date)

#jsn = d(d("script")[13]).text()

def parseHtml(f):
	d=pq(open(f, 'r').read())
	metad = [x.strip().split('"')[1] for x in d(d("script")[12]).text().split("\r\n") if x.strip().startswith('city')]
	cityId = metad[0]
	cityName = metad[1]
	jj = json.loads("["+d(d("script")[13]).text().split("[")[1].split("]")[0]+"]")
	for j in jj:
		if j['price']!=None:
			print "\t".join([cityId, cityName, j['placeName'], j['placeId'], str(j['price']), str(j['isDirect']), j['airlines'] ]).encode('utf-8').strip()
	#d.close()

for line in sys.stdin.readlines():
	parseHtml(line.strip())
