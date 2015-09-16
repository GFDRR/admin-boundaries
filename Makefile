DATABASE_NAME=gaul


allCountries.zip:
	curl -o $@ 'http://download.geonames.org/export/dump/allCountries.zip'

allCountries.txt: allCountries.zip
	unzip $<

alternateNames.txt: alternateNames.zip
	unzip $<

alternateNames.zip:
	curl -o $@ 'http://download.geonames.org/export/dump/alternateNames.zip'

countryInfo.txt:
	curl -o $@ 'http://download.geonames.org/export/dump/countryInfo.txt'

iso-languagecodes.txt:
	curl -o $@ 'http://download.geonames.org/export/dump/iso-languagecodes.txt'

admin1.txt:
	curl -o $@ 'http://download.geonames.org/export/dump/admin1CodesASCII.txt'

admin2.txt:
	curl -o $@ 'http://download.geonames.org/export/dump/admin2Codes.txt'

admin0.sql:
	shp2pgsql -W LATIN1 -G g2015_2014_0/g2015_2014_0.shp >> $@

admin1.sql:
	shp2pgsql -W LATIN1 -G g2015_2014_1/g2015_2014_1.shp >> $@

admin2.sql:
	shp2pgsql -W LATIN1 -G g2015_2013_2/g2015_2013_2.shp >> $@

geonames.postgis: allCountries.txt alternateNames.txt countryInfo.txt iso-languagecodes.txt
	psql -f geonames.sql -q $(DATABASE_NAME)

%.postgis: %.sql
	psql -q -f $< $(DATABASE_NAME)

# Depends on admin2.postgis
admin2.names.txt: 
	psql -d $(DATABASE_NAME) -F , --no-align -c 'SELECT adm0_name, adm1_name, adm2_name FROM g2015_2013_2 ORDER BY adm0_name, adm1_name, adm2_name' >> $@
	
admin1.names.txt: 
	psql -d $(DATABASE_NAME) -F , --no-align -c 'SELECT adm0_name, adm1_name FROM g2015_2014_1 ORDER BY adm0_name, adm1_name' >> $@

admin0.names.txt: 
	psql -d $(DATABASE_NAME) -F , --no-align -c 'SELECT adm0_name FROM g2015_2014_0 ORDER BY adm0_name' >> $@

capitals-osm.json:
	wget -O $@ http://overpass-api.de/api/interpreter?data=%2F*%0AThis%20has%20been%20generated%20by%20the%20overpass-turbo%20wizard.%0AThe%20original%20search%20was%3A%0A%E2%80%9Cplace%3Dcity%20and%20capital%3Dyes%E2%80%9D%0A*%2F%0A%5Bout%3Ajson%5D%3B%0A%2F%2F%20gather%20results%0A%28%0A%20%20%2F%2F%20query%20part%20for%3A%20%E2%80%9Cplace%3Dcity%20and%20capital%3Dyes%E2%80%9D%0A%20%20node%5B%22place%22%3D%22city%22%5D%5B%22capital%22%3D%22yes%22%5D%5B%22admin_level%22%3D2%5D%3B%0A%29%3B%0A%2F%2F%20print%20results%0Aout%20body%3B%0A%3E%3B%0Aout%20skel%20qt%3B

capitals-osm.txt: capitals-osm.json
	python plain_capitals.py $< | sort >> $@

capitals-wikipedia.txt:
	curl -o $@ "https://docs.google.com/spreadsheets/d/1FniK9JaWQmmQrt_PfUlTnI1pXk23kz4wnEH3jFiF8Js/pub?gid=0&single=true&output=tsv"
