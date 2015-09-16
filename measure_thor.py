import sys
import json
import requests
import codecs

think_hazard = "http://wb-thinkhazard.dev.sig.cloud.camptocamp.net/main/wsgi/administrativedivision?q=%s"

with codecs.open(sys.argv[1], encoding="UTF-8") as raw_data:
    lines = raw_data.readlines()
    print "Testing %s capital cities" % len(lines)
 
    not_found = []
    single_option = []
    many_options = []

    for line in lines:
        name, country = line.split('\t')
        # get the results from thinkhazard
        search_url = think_hazard % name
        r = requests.get(think_hazard % name)
        result = r.json()

        if len(result["data"]) == 0:
            not_found.append(name)

        if len(result["data"]) == 1:
            single_option.append([name, result["data"]])

        if len(result["data"]) == 2:
            many_options.append([name, result["data"]])

    print "Not found: %s percent" % (len(not_found)*100.0 / len(lines)) 
