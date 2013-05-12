width = 1350
height = 580

dur = 2000

data = {}
svg = d3.select("#map").append("svg")
    .attr("width", width)
    .attr("height", height)
countries = svg.append("g").attr("class","countries")
lines = svg.append("g").attr("class","lines")
cities = svg.append("g").attr("class","cities")
center = svg.append("g").attr("class","center")
center.append("circle").attr("cx",width/2).attr("cy",height/2).attr("r",6)
center.append("text").text("")
title = d3.select("#title")
pr = {}
w = {}
d3.json("data/world-110m.json", (error, w_f) ->
	w = w_f
	d3.tsv("data/data.tsv", (error, dat) ->
		data = d3.nest().key((d) -> d.SRC ).sortKeys(d3.ascending).entries(dat)
		_.each(data, (d)-> 
			d.lat = +d.values[0].SRC_LAT
			d.lng = +d.values[0].SRC_LNG
			_.each(d.values, (item) -> 
				item.PRICE=+item.PRICE
				item.distance=+item.distance
				item.ppk = item.PRICE * 100 / item.distance
				item.ll = [+item.DST_LNG, +item.DST_LAT]
			)
			d.med_ppk = d3.median(d.values, (dd) -> dd.ppk)
			#d.values = _.filter(d.values,(dd) -> (dd.ppk < d.med_ppk*3.8 or d.PRICE<100 ) and dd.distance>230)
			d.min_ppk = _.min(_.map(d.values,(dd) ->dd.ppk))
			d.max_ppk = _.max(_.map(d.values,(dd) -> dd.ppk))
			_.each(d.values, (i) -> i.q=i.ppk/d.med_ppk)
			return true
		)
		drawList(data)
		return true	
	
	)
)
drawList = (data) ->
	d3.select("#list").selectAll("a").data(data).enter()
	.append("a")
	.attr("href","#map")
	.on("click",(d) -> 
		d3.event.preventDefault()
		draw(d)
	)
	.text((d) -> d.key+" ")

draw = (city) ->
	console.log(city)
	old_pr = pr
	pr = d3.geo.azimuthalEquidistant()
	.scale(650)
	.translate([width / 2, height / 2])
	.rotate([-city.lng,-city.lat,0])
	.clipAngle(180 - 1e-3)
	.precision(.5);
	if old_pr=={} 
		old_pr=pr
	sc = d3.scale.linear().domain([city.min_ppk,city.med_ppk,city.max_ppk]).range(['green','yellow','red'])
	scr = d3.scale.linear().domain([city.min_ppk,city.med_ppk,city.max_ppk]).range([4,4,4])
	p = countries.selectAll("path")
		.data(topojson.object(w, w.objects.countries).geometries)
	p.transition().duration(dur).attr("d", d3.geo.path().projection(pr))
	f = d3.format(",.2f")
	titleF = (d) -> title.text(d.DST + " - "+f(d.ppk)+" - "+f(city.med_ppk)+" - "+f(d.ppk/city.med_ppk)+" - "+f(d.ppk/city.med_ppk*d.distance)+"km"+" - "+d.distance+"km")
	p.enter()
		.append("path")
		.attr("d", d3.geo.path().projection(pr))
	
	c = cities.selectAll("circle")
		.data(city.values)
		
	
	c.attr("cx",(d) -> pr(d.ll)[0] )
		.attr("cy",(d) -> pr(d.ll)[1] )
		.attr("r",(d) -> scr(d.ppk))
		.style("fill",(d) -> sc(d.ppk))
		.on("mouseover",titleF)
		.style("display","none").transition().delay(dur).duration(0).style("display","block")
	c.enter().append("circle").attr("cx",(d) -> pr(d.ll)[0] )
		.attr("cy",(d) -> pr(d.ll)[1] )
		.attr("r",(d) -> scr(d.ppk))
		.style("fill",(d) -> sc(d.ppk))
		.style("opacity",.5)
		.on("mouseover",titleF)
		.style("display","none").transition().delay(dur).duration(0).style("display","block")
		
	c.exit().remove()


