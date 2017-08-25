#!/usr/bin/env python

import sys
import re
import csv

#convert input file to ascii first
#iconv -c -t ASCII  iana-registrar-ids.csv > iana-registrar-ids-asii.csv

ac_registrars = {}
nac_registrars = {}

def clean(raw):
     #print raw
     reg = raw.lower().replace(".","").replace(",","").replace("-","") #remove 2 different types of dash
     reg = re.sub(r"\(.*\)", "", reg)
     reg = re.sub(r"(r[0-9]+-[a-zA-Z]+)", "", reg)
     index = reg.find(" dba ")
     if index > 0:
         reg = reg[0:index]

     index = reg.find(" d/b/a ")
     if index > 0:
         reg = reg[0:index]
        
     reg = reg.replace(" ","")

     reg = re.sub("[^a-zA-Z0-9]+", "", reg)

     #print raw + " ---> " + reg
     return reg

with open('iana-registrar-ids-asii.csv', 'rb') as csvfile:
    reader = csv.reader(csvfile, delimiter=',', quotechar='"')
    for row in reader:
        reg = clean(row[1])       
        if row[2] == "Accredited":
            ac_registrars[reg] = row[0]
        else:
            nac_registrars[reg] = row[0]
        
with open('registrar-country-mapping-final.csv', 'rb') as csvfile:
    reader = csv.reader(csvfile, delimiter=',', quotechar='"')
    for row in reader:
        reg = clean(row[0])

        if reg in ac_registrars:
            print "\"{0}\",{1},{2},true".format(row[0].lower(), row[1], ac_registrars[reg])

        elif reg in nac_registrars:
            print "\"{0}\",{1},{2},false".format(row[0].lower(), row[1], nac_registrars[reg])
        else:
            print "\"{0}\",{1},,false".format(row[0].lower(), row[1])

