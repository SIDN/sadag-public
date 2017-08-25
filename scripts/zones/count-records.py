#!/usr/bin/env python

##################################################################
#
# Usage: script <path> <outfile>
#
##################################################################

import sys
import gzip
import re
import os.path
from subprocess import Popen, PIPE

COMPRESSED_FILE = '.gz'
UNCOMPRESSED_FILE = '.zone'

NS_PATTERN = re.compile( "([A-Za-z0-9\.-]+)\s+([0-9]+\s+)*(IN\s+)?NS\s+.*", re.M|re.I)
#NS_PATTERN = re.compile( "([A-Za-z0-9\.-]+)\s([0-9]+\s)*(in\s)?ns\s+", re.M|re.I)
#DS_PATTERN = re.compile( "([A-Za-z0-9\.-]+)\s([0-9]+\s)*(in\s)?ds\s+", re.M|re.I)
DS_PATTERN = re.compile( "([A-Za-z0-9\.-]+)\s+([0-9]+\s+)*(IN\s)?DS\s+.*", re.M|re.I)
def handleLine(line,domainnames,dnssec):
    match = NS_PATTERN.match(line)
    if match:
       domainnames.add(match.group(1))
    else:
       match = DS_PATTERN.match(line)
       if match:
          dnssec.add(match.group(1))

def extractTldAndDate(path):
   parts = path.split('/')
   return parts[len(parts)-2], parts[len(parts)-3]
   


def handleFile(ext, dirname, names):

   #use sets to counts unique domains 
   domainnames = set()
   dnssec = set()  
 
   #fState = open(sys.argv[2], 'a+')
   #stateMap = {}
   #read previous state, we are restartable and continue where we left off.
   #for entry in fState:
   #  parts = entry.split(',')
   #  stateMap[parts[0]+parts[1]] = entry
  
   for name in names:
      f = os.path.join(dirname, name)
      print "Found file: ", f

      if not name.lower().endswith(COMPRESSED_FILE) and not name.lower().endswith(UNCOMPRESSED_FILE):
         print "Skip file: ", f
         continue

      tld, day = extractTldAndDate(f)
      print "extracted tld: %s day: %s" % (tld, day)

      #check if this tld,day combination has not been processed already 
      if day+tld in  stateMap:
        print "%s has already been procesed, skipping" % (tld +"-" + day)      
        continue

      #some zone files are very large, we do not want to load them fully into
      #memory which is required for parsing. 
      #we stream through the files, checking on a line-by-line basis if the
      #line contains a NS or DS record
      if name.lower().endswith(COMPRESSED_FILE):
         #use zcat and pip to python because the python gzip decompression is
         #much slower!
         fin = Popen(['zcat', f], stdout=PIPE)
         for line in fin.stdout:
            handleLine(line,domainnames,dnssec)

      elif name.lower().endswith(UNCOMPRESSED_FILE):
         fin =  open(f, 'r')
         for line in fin:
            handleLine(line,domainnames,dnssec)
      
         fin.close()

      #remove apex
      domainnames.discard(tld+".")
      domainnames.discard(tld)
      dnssec.discard(tld+".")
      dnssec.discard(tld)         
      
      lineOut = "%s,%s,%s,%s\n" % (day,tld,len(domainnames), len(dnssec))
      print lineOut 
      fState.write(lineOut)

      #add results to statemap, there might be multiple files in the dir (compr and uncompr)
      parts = lineOut.split(',')
      stateMap[parts[0]+parts[1]] = lineOut
      #reset counter sets       
      domainnames = None
      dnssec = None
      

# Start with root path in first arg
   
root = sys.argv[1]

fState = open(sys.argv[2], 'a+')
stateMap = {}
#read previous state, we are restartable and continue where we left off.
for entry in fState:
   parts = entry.split(',')
   stateMap[parts[0]+parts[1]] = entry

print "Start from : ", root
os.path.walk(root, handleFile, None)
print "done!"
