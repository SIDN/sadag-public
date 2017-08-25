#!/usr/bin/env python

import Queue
import threading
import time
import sys
import gzip
import re
import os.path
from subprocess import Popen, PIPE

exten_compressed = '.gz'
exten_uncompressed = '.zone'

NS_PATTERN = re.compile( "([A-Za-z0-9\.-]+)\s([0-9]+\s)*(in\s)?ns\s+", re.M|re.I)

exitFlag = 0

class myThread (threading.Thread):
    def __init__(self, threadID, name, q):
        threading.Thread.__init__(self)
        self.threadID = threadID
        self.name = name
        self.q = q
    def run(self):
        print "Starting " + self.name
        process_data(self.name, self.q)
        print "Exiting " + self.name

def process_data(threadName, q):
    while not exitFlag:
        queueLock.acquire()
        if not workQueue.empty():
            data = q.get()
            queueLock.release()
            print "%s processing %s" % (threadName, data)
            checkFile(data)
        else:
            queueLock.release()
        #time.sleep(1)


def checkFile(f):
      lineCount = 0
      domainnames = set()
      dnssec = set()
      fin = None      

      if f.lower().endswith(exten_compressed):
         fin = Popen(['zcat', f], stdout=PIPE)
         for line in fin.stdout:
            handleLine(line, domainnames, dnssec)
            lineCount += 1

            if lineCount % 100000 == 0:
               print "lines processed: %s" % lineCount

            if len(domainnames) % 100000 == 0:
               print "len domains: %s" % len(domainnames)

         print "file: %s, domains: %s, dnssec: %s" % (f, len(domainnames), len(dnssec)) 


def handleLine(line, domainnames, dnssec):
    #print('check line', line)
    #matchNS = re.match( "([A-Za-z0-9\.-]+)\s([0-9]+\s)*(in\s)?ns\s+", line, re.M|re.I)
    matchNS = NS_PATTERN.match(line)
    if matchNS:
       #print "NS --> ", matchNS.group(1)
       domainnames.add(matchNS.group(1))
    #else:
    #   matchDS = re.match( "[A-Za-z0-9.-]+\s([0-9]+\s)*in\sds\s.*", line, re.M|re.I)
    #   if matchDS:
    #      #print "DS --> ", matchDS.group(1)
    #      dnssec.add(matchDS.group(1))



def listFiles(ext, dirname, names):

    for name in names:
      f = os.path.join(dirname, name)
      print "Add file to queue: ", f
      workQueue.put(f)


threadList = ["Thread-1", "Thread-2", "Thread-3", "Thread-4", "Thread-5", "Thread-6", "Thread-7", "Thread-8"]
queueLock = threading.Lock()
workQueue = Queue.Queue()
threads = []
threadID = 1

# Create new threads
for tName in threadList:
    thread = myThread(threadID, tName, workQueue)
    thread.start()
    threads.append(thread)
    threadID += 1

# Fill the queue
queueLock.acquire()

# Start the walk
root = sys.argv[1]
os.path.walk(root, listFiles, None)

queueLock.release()

# Wait for queue to empty
while not workQueue.empty():
    pass

# Notify threads it's time to exit
exitFlag = 1

# Wait for all threads to complete
for t in threads:
    t.join()

    
print "Exiting Main Thread"
