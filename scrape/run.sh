for i in `cat cities.txt | grep -v "#" | sort | uniq `; do ./scrape.sh $i 130621; done
