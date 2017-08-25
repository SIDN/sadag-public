#!/usr/bin/env python

##################################################################
#
# Usage: script <path> <outfile>
#
##################################################################

import sys
import os.path

def extractDate(path):
   parts = path.split('.')
   return parts[2]


def handleFile(ext, dirname, names):

   for name in names:
      f = os.path.join(dirname, name)
      print "Found file: ", f

      ddate = extractDate(f)
      print "extracted date: %s" % (ddate,)

      fin =  open(f, 'r')
      for line in fin:
         dom = line.strip()
         if not dom in uniqueDomains:
            #print "Add domain: {0}".format(dom)
            formattedDate = "{0}-{1}-{2}".format(ddate[0:4], ddate[4:6], ddate[6:8])
            uniqueDomains[dom] = formattedDate 
      
      fin.close()

# Start with root path in first arg
   
root = sys.argv[1]
uniqueDomains = {}

print "Start from : ", root
os.path.walk(root, handleFile, None)

fOut = open(sys.argv[2], 'a+')
for k, v in uniqueDomains.iteritems():
   lineOut = "%s,%s\n" % (k,v)
   fOut.write(lineOut)

fOut.close()
print "done!"
