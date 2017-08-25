#!/usr/bin/env python

import sys
import os.path

uniqueDomains = {}

for line in sys.stdin:
   parts = line.strip().split('|')
   dom = parts[0]
   if not dom in uniqueDomains:
      formattedDate = "{0}-{1}-{2}".format(parts[3][0:4], parts[3][5:7], parts[3][8:10])
      uniqueDomains[dom] = formattedDate

for k, v in uniqueDomains.iteritems():
   print "%s,%s" % (k,v)

