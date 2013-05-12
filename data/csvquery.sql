select f.src_name src, a.city dst, min(f.price) price, c.lat src_lat, c.lng src_lng,  avg(a.lat) dst_lat, avg(a.lng) dst_lng from flights.tsv f, airports.tsv a, cities.tsv c where f.dst_code=a.code1 and f.src_name=c.name and c.lat>15 and c.lng>-25 and c.lng<40 group by f.src_name, a.city, c.lat, c.lng  order by f.src_name, a.city