#http://www.skyscanner.net/flights-from/lond/130621/cheapest-flights-from-london-in-june-2013.html?di=1
d="raw/$1/$2"
mkdir -p $d
wget -x --load-cookies cookies.txt "http://www.skyscanner.net/flights-from/$1/$2/cheapest-flights-from-london-in-june-2013.html?di=1" -O $d/$1-$2.html

for url in `cat $d/$1-$2.html | grep "\"url\" :" | grep ":" | grep -v "null" | awk -F'"' '{print $4}' | sort | uniq`
do
	co=`echo $url | awk -F'/' '{print $4}'`
	echo $co
	sleep 5
	wget -x --load-cookies cookies.txt "http://www.skyscanner.net$url" -O $d/$1-$2-$co.html
done
