#!/usr/bin/env python

import sys
import re
import csv
import urllib2
import urllib


fDataOut = open('registrars-registrarowl-lower.csv', "a", 0)
countriesFound = 0

with open('registrars-registrarowl-sorted-final.csv', 'rb') as csvfile:
    reader = csv.reader(csvfile, delimiter=',', quotechar='"')
    for row in reader:
       fDataOut.write("\"{0}\",{1}\n".format(row[0].lower(), row[1]))


