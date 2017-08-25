#!/usr/bin/env python

import os
import sys
import tarfile
import csv

def handleFile(ext, dirname, names):

   countr = 0
   registrars = {}
   resellers = {}

   for name in names:
      f = os.path.join(dirname, name)
      if name.lower().endswith(".gz"):
         print "Found file: ", f

         nameParts = name.split('.')
         tld = nameParts[len(nameParts)-4]
         print "Found tld: ", tld
         #create empty maps for tls registrars/resellers
         registrars[tld] = {}
         resellers[tld] = {}

         try: 
            tar = tarfile.open(f)
         except Exception:
            #skip files
            print "Cannot not read file: ", f
            continue

         for member in tar.getmembers():
             #print "member: {0}".format(member)
             f_member = tar.extractfile(member)
             reader = csv.DictReader(f_member)
             for row in reader:
                #get field: registrarName
                 
                entities = row['registrarName'].split('|')
                for index, ent in enumerate(entities): 
                   if index == 0:
                      #registrar
                      print "registrar: {0} ".format(ent)
                      
                      if ent in registrars[tld]:
                         registrars[tld][ent] = registrars[tld][ent] + 1
                      else:
                         registrars[tld][ent] = 1
                   else:
                      #reseller
                      print "reseller: {0} ".format(ent)
                   
                      if ent in resellers[tld]:
                         resellers[tld][ent] = resellers[tld][ent] + 1
                      else:
                         resellers[tld][ent] = 1

         tar.close()
         countr = countr + 1

         if countr == max_countr:
            break
         

   #write results
   f_out = open(sys.argv[2], 'w')
   for tld in registrars:
      for registrar in registrars[tld]:
         f_out.write("{0},\"{1}\",0,{2}\n".format(tld,registrar, registrars[tld][registrar]))
   
   for tld in resellers:
      for reseller in resellers[tld]:
         f_out.write("{0},\"{1}\",1,{2}\n".format(tld,reseller, resellers[tld][reseller]))


   f_out.close() 


# Start with root path in first arg
max_countr = int(sys.argv[3])
root = sys.argv[1]
os.path.walk(root, handleFile, None)

print "Done!"
