#!/usr/bin/env python

import os
import sys

f_apwg_data = open(sys.argv[1])
f_tld_filter = open(sys.argv[2])
f_results = open(sys.argv[3],'w')

#list containing phishes formatted: <domain>,<date>
phish_matches = []

#load tld filters
tld_filter = []
for line in f_tld_filter:
   if len(line) == 0:
      #skip empty line
      continue
   parts = line.split(',')
   tld_filter.append(parts[0])


status_countr = 0
#find phishes that match tld filter
for line in f_apwg_data:
   status_countr += 1
   if status_countr % 10000 == 0:
      print "processed {0} lines".format(status_countr)

   if len(line) == 0:
      #skip empty line
      continue
   
   parts = line.split(',')
   #get tld from domain in pos 0
   domain_parts = parts[0].split('.')
   #get the last part which is the tld
   label_len = len(domain_parts)
   tld = domain_parts[label_len-1]
   if tld in tld_filter:
      #found match, print 2nd level + date
      phish_matches.append("{0}.{1},{2}".format(domain_parts[label_len-2],domain_parts[label_len-1],parts[1]))


#save the found phishes in file
for phish in phish_matches:
   f_results.write("{0}\n".format(phish))

f_apwg_data.close()
f_tld_filter.close()
f_results.close()

print "Done!"
