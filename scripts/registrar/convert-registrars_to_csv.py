#!/usr/bin/env python

import sys
import re


fDataIn = open('icann-accredited-registrar-countries-raw.txt', "r")
fDataOut = open('icann-accredited-registrar-countries.csv', "w")
for line in fDataIn:
    #print line
    parts = line.split('   ')
    if len(parts) > 2: 
       #fDataOut.write( "{0},{1}\n".format(parts[0].strip().replace(',', '_'), parts[2].strip()))
       fDataOut.write( "\"{0}\",{1}\n".format(parts[0].strip(), parts[2].strip()))

