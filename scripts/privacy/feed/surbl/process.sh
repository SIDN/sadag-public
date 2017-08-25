#!/usr/bin/env bash

./count-legacy-overall.py 2014-01-01 2017-01-01 count-legacy-overall.csv
./count-legacy-privacy-services.py 2014-01-01 2017-01-01 count-legacy-privacy-services.csv
./count-newgtld-overall.py 2014-01-01 2017-01-01 count-newgtld-overall.csv
./count-newgtld-privacy-services.py 2014-01-01 2017-01-01 count-newgtld-privacy-services.csv

