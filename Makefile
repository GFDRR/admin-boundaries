

admin0.sql:
	shp2pgsql -W LATIN1 -G g2015_2014_0/g2015_2014_0.shp >> $@

admin1.sql:
	shp2pgsql -W LATIN1 -G g2015_2014_1/g2015_2014_1.shp >> $@

admin2.sql:
	shp2pgsql -W LATIN1 -G g2015_2013_2/g2015_2013_2.shp >> $@
