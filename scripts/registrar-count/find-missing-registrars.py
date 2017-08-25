#!/usr/bin/env python

import sys
import csv


registrars = {}

with open('/Users/maarten/sidn/development/github/sadag/scripts/registrar/registrar-country-mapping-with-accreditation-final.csv', 'rb') as csvfile:
    reader = csv.reader(csvfile, delimiter=',', quotechar='"')
    for row in reader:
       #find registrars with ianaid
       if len(row) > 3 and len(row[2]) > 0:
           #print "test: " + row[2]
           registrars[row[0]] = row[2]


with open('missing-legacy-registars.csv', 'rb') as csvfile:
    reader = csv.reader(csvfile, delimiter=',', quotechar='"')
    for row in reader:
       if len(row) > 0:
          if row[0] == "NULL" and row[1] not in registrars:
             print row[1] + ","  + row[2]          

#print registrars
