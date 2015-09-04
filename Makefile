DATABASE_NAME=gaul


allCountries.zip:
	curl -o $@ 'http://download.geonames.org/export/dump/allCountries.zip'

allCountries.txt: allCountries.zip
	unzip @<

alternateNames.txt: alternateNames.zip
	unzip @<

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

