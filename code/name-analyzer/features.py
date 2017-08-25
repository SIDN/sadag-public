import tldextract
from tld.utils import get_tld
from urllib.parse import urlparse
import logging
import sys
import itertools
import editdistance
import pandas as pd
import numpy as np

#this is a PYTHON 3 code


def readAlexa(path):
    alexa = set()

    with  open(path) as f:

        line=f.readlines()
        for k in line:
            t=k.rstrip().split(",")
            if len(t)==2:
                k=t[1]
                alexa.add(k)
                #ext = tldextract.extract(k)
                #alexaNOTLD.add(ext.domain)
                #add alexa domains removing the .com part, for example. for that we need to use the mozilla tld file


            elif len(t)==1:
                alexa.add(t)

    return alexa


def readAlexaTLDz(path):
    alexaWoTLD = set()

    with  open(path) as f:

        line=f.readlines()
        for k in line:
            t=k.rstrip().split(",")
            if len(t)==2:
                k=t[1]
                #alexa.add(k)
                ext = tldextract.extract(k)
                alexaWoTLD.add(ext.domain)
                #add alexa domains removing the .com part, for example. for that we need to use the mozilla tld file


            elif len(t)==1:
                ext = tldextract.extract(t)
                alexaNOTLD.add(ext.domain)

    return alexaWoTLD



def getTLDObj(s):
    mix = ""
    try:
        mix = get_tld(s, as_object=True)
    except:
        logging.debug('Error with get_tld()        function: % s        ' % s)

    return mix

def getPath(s):
    return urlparse(s).path

def getVars(s):
    return urlparse(s).query

def getFQDN(s):
    domain = ""
    try:
        domain = '.'.join(tldextract.extract(s)[:]).strip('.')


    except UnicodeError:
        logging.debug('UnicodeError: problem with a domain name % s' % domain)

    fqdn = ""
    if (domain.rfind('.') != -1):
        if (domain[:7] == 'http://'):
            fqdn = domain[7:]
        else:
            fqdn = domain
        if (fqdn[:4] == 'www.'):
            fqdn = fqdn[4:]

    return fqdn


def get2LD(s):
    mix = ""
    try:
        if "http" in s:
            mix = get_tld(s)
        else:
            mix = get_tld('http://' + s)
            # print(mix)
    except:
        logging.debug('Error with get_tld()        function: % s        ' % s)

    return mix

def getSubdomain(s):
    tempObj=getTLDObj(s)
    subdomain="-1"
    try:
            subdomain=tempObj.subdomain
    except:
        logging.debug('Error with get_tld()        function: % s        ' % s)
    return str(subdomain)


def createAllCombinationsOfDomains(s):

    ww=[]
    tobeReturned = []

    #we need to produce a new list with every single element splitted by .

    newList=[]
    for k in s:
        temp=k.split(".")
        for x in temp:
            newList.append(x)

    nComb=len(newList)
    print("the length on nComb is: " + str(nComb))
    for y in range(1,nComb):
        for t in itertools.combinations(newList,y):
            #tempV=str(t[0])
            #tempZ=tempV.split(",")
            #if str(tempZ[0]) not in mozzilaTLDs:
            ww.append(t)

    for k in ww:
        w=str(k).replace("(","").replace(")","").replace("'","").replace(",",".").replace(" ","").replace("[","").replace("]","")
        if w[len(w) - 1] == ".":
            w = w[:-1]
        tobeReturned.append(w)
       # print(w)

    return tobeReturned


def readTLDS(path):
    tlds = dict()

    with  open(path) as f:

        line=f.readlines()
        for k in line:
            k= k.rstrip().replace("'","")
            key=k.split(".")[-1]

            if key not in tlds:
                tempArray=[]
                tempArray.append(k)

                tlds[key]=tempArray
            else:
                tempArray = tlds[key]
                tempArray.append(k)
                tlds[key] = tempArray

    return tlds

def pathDistance(s):
    result = 0
    s = s.lower()
    path = getPath(s)
    print(" path  is " + path)

    # print(" x is " + x + " and subdomain is " + subdomain)
    subdomainPerDash = path.split("/")

    if len(subdomainPerDash) == 0:
        tempArray = []
        tempArray.append(subdomain)
        subdomaniPerDot = tempArray



    combiDash = subdomainPerDash

    # gets a paypal for example
    minValue = -1
    for x in alexa:

        for k in combiDash:

            tempValue = calcDistanceWithAlexa(k)
            if minValue == -1:
                minValue = tempValue
            elif minValue > -1:
                if tempValue < minValue:
                    minValue = tempValue

    return minValue


def subdomainDistance(s):
    result = 0
    s = s.lower()
    subdomain=getTLDObj(s).domain
    print(" subdomain is " + subdomain)

    # print(" x is " + x + " and subdomain is " + subdomain)
    subdomainPerDash = subdomain.split("-")
    subdomaniPerDot = subdomain.split(".")

    if len(subdomainPerDash)==0:
        tempArray=[]
        tempArray.append(subdomain)
        subdomaniPerDot=tempArray

    if len(subdomainPerDash) == 0:
        tempArray = []
        tempArray.append(subdomain)
        subdomaniPerDot = tempArray

    #combiDash = createAllCombinationsOfDomains(subdomainPerDash)
    #combiDot = createAllCombinationsOfDomains(subdomaniPerDot)
    combiDash=subdomainPerDash
    combiDot=subdomaniPerDot
    # gets a paypal for example
    minValue=-1
    for x in alexa:

        for k in combiDash:

            tempValue=calcDistanceWithAlexa(k)
            if minValue==-1:
                minValue=tempValue
            elif  minValue>-1:
                if tempValue < minValue:
                    minValue=tempValue


            if minValue!= 0 and minValue!=-1:
                for k in combiDot:
                    tempValue = calcDistanceWithAlexa(k)

                    if tempValue < minValue:
                        minValue = tempValue


    return minValue



def subdomainDistanceAllCombs(s):
    result = 0
    s = s.lower()
    subdomain=getSubdomain(s)
    print(" subdomain is " + subdomain)

    # print(" x is " + x + " and subdomain is " + subdomain)
    subdomainPerDash = subdomain.split("-")
    subdomaniPerDot = subdomain.split(".")

    if len(subdomainPerDash)==0:
        tempArray=[]
        tempArray.append(subdomain)
        subdomaniPerDot=tempArray

    if len(subdomainPerDash) == 0:
        tempArray = []
        tempArray.append(subdomain)
        subdomaniPerDot = tempArray

    combiDash = createAllCombinationsOfDomains(subdomainPerDash)
    combiDot = createAllCombinationsOfDomains(subdomaniPerDot)

    # gets a paypal for example
    minValue=-1
    for x in alexa:

        for k in combiDash:

            tempValue=calcDistanceWithAlexa(k)
            if minValue==-1:
                minValue=tempValue
            elif  minValue>-1:
                if tempValue < minValue:
                    minValue=tempValue


            if minValue!= 0 and minValue!=-1:
                for k in combiDot:
                    tempValue = calcDistanceWithAlexa(k)

                    if tempValue < minValue:
                        minValue = tempValue


    return minValue


def secondLDDistance(s):

    return 0


def varDistance(s):

    return 0

def compareSubdomainWithAlexa(s, alexa):

    result = 0
    s = s.lower()
    subdomain = getFQDN(s)

    # print(" x is " + x + " and subdomain is " + subdomain)
    subdomainPerDash = subdomain.split("-")
    subdomaniPerDot = subdomain.split(".")

    combiDash = createAllCombinationsOfDomains(subdomainPerDash)
    combiDot = createAllCombinationsOfDomains(subdomaniPerDot)

    # gets a paypal for example
    for x in alexa:


        for k in combiDash:
            if k != "www":
              #  print("k is " + k)

                if k in alexa and k not in mozzilaTLDs:

                    result = 1
                  #  print(k)

       # print(s + " , " + k)

        if result != 1:
            for k in combiDot:
              #  print(k)
                if k != "www":
                    if k in alexa and k not in mozzilaTLDs:
                        result = 1
                        #print(k)

        return result

def comparePathWithAlexa(s):
    result = 0
    s=s.lower()
    secondLD=getPath(s)
    subdomainPerSlash=secondLD.split("/")
    combiSlash=createAllCombinationsOfDomains(subdomainPerSlash)


    # gets a paypal for example
    for x in alexa:
        for k in combiSlash:
           # if len(k) >=1 and  k[len(k)-1]==".":
            #    k= k[:-1]
            if k != "www" and k!="":
                #print("k is " + k)

                if k in alexa: # and k not in mozzilaTLDs:

                    result = 1
                   # print("got here")
                    break;
                  #  print(k)

       # print(s + " , " + k)

        if result != 1:
            for k in combiSlash:
              #  print(k)
                if k != "www":
                    if k in alexa: #and k not in mozzilaTLDs:
                        result = 1
                        break;
                        #print(k)

        return result

def comparePathWithAlexaSubstring(s):
    result = 0
    s=s.lower()
    secondLD=getPath(s)
    if len(secondLD)> 1:

        subdomainPerSlash=secondLD.split("/")
        combiSlash=createAllCombinationsOfDomains(subdomainPerSlash)


        # gets a paypal for example
        for x in alexa:
            for k in combiSlash:
               # if len(k) >=1 and  k[len(k)-1]==".":
                #    k= k[:-1]
                if k != "www" and k!="":
                    #print("k is " + k)

                    if k in alexaNOTLD: # and k not in mozzilaTLDs:

                        result = 1
                        #print("got here")
                        break;
                      #  print(k)

           # print(s + " , " + k)

            if result != 1:
                for k in combiSlash:
                  #  print(k)
                    if k != "www":
                        if k in alexaNOTLD: #and k not in mozzilaTLDs:
                            result = 1
                            break;
                            #print(k)
    else:
        result=0

    return result

def compareVarsWithAlexa(s):
    result =0
    s = s.lower()
    #vars are usually marked by a start with ?
    #so let's split as it
    vars= getVars(s)
    subdomainPerSlash=vars.split("&")
    if len(subdomainPerSlash)==1:
        result=0
    else:
        tempString=""
        tempList=[]
        for i in range (1,len(subdomainPerSlash)-1):
            if i==1:
                tempString=subdomainPerSlash[1]
            else:
                tempString=tempString+"?"+subdomainPerSlash[i]
            tempList.append(tempString)

        combiSlash=createAllCombinationsOfDomains(tempList)

        # gets a paypal for example
        for x in alexa:
            for k in combiSlash:
                if k != "www":
                  #  print("k is " + k)

                    if k in alexa and k not in mozzilaTLDs:

                        result = 1
                      #  print(k)

           # print(s + " , " + k)

            if result != 1:
                for k in combiSlash:
                  #  print(k)
                    if k != "www":
                        if k in alexa and k not in mozzilaTLDs:
                            result = 1
                            #print(k)

        return result


def feature1(domain):
    result = -1
    # get a domain and an alexa set
    # for each entry in alexa, see if it contains any
    #tldOBJ = getTLDObj(domain)
    #a=get2LD(domain)
    together=getFQDN(domain)

    result = compareSubdomainWithAlexa(together, alexa)
    return result

def feature1b(domain):
    result = -1
    # get a domain and an alexa set
    # for each entry in alexa, see if it contains any
    #tldOBJ = getTLDObj(domain)
    #a=get2LD(domain)
    together=getSubdomain(domain)

    if len(together)>0:
        result = compareSubdomainWithAlexa(together, alexa)
        return result
    else:
        return 0

def feature1a(domain):
    result = -1
    # get a domain and an alexa set
    # for each entry in alexa, see if it contains any
    #tldOBJ = getTLDObj(domain)
    #a=get2LD(domain)
    togeter=""
    try:
        together=getTLDObj(domain).tld
    except:
        return 0

    if len(together) > 0:
        result = compareSubdomainWithAlexa(together, alexa)
        return result
    else:
        return 0

def feature5(s):
    result = -1
    s=s = s.lower()
    result= comparePathWithAlexa(s)
    return result

def feature5Substring(s):
    result = -1
    s = s.lower()
    result= comparePathWithAlexaSubstring(s)
    return result


def feature6(s):
    result = -1
    s = s.lower()
    result=compareVarsWithAlexa(s)
    if result==None:
        result=0

    return result


def feature7(s):
    result = -1
    s = s.lower()

    together=getSubdomain(s)


    if len(together)>0:
        result = subdomainDistance(together)
        return result
    else:
        return 0




def calcDistanceWithAlexa(s):

    tempArray=[]
    for k in alexa:
        tempV=editdistance.eval(s,k)
        tempArray.append(tempV)

    return  pd.DataFrame(tempArray).min()[0]


print("usage: python3 features.py  $maliciousDomainsFile.csv $alexa1M.csv $mozzilaTLDFiles.csv $outputFile.csv")




if len(sys.argv)!=5:
    print("\nWARNING: wrong number of parameters. Usage:\npython3 features.py  $maliciousDomainsFile.csv $alexa1M.csv $mozzilaTLDFiles.cs   $outputFile.csv\n\n")
#alexa=readAlexa("top100.csv" )
else:
    badDomains = str(sys.argv[1])
    alexaFile = str(sys.argv[2])
    mozzilaFile = str(sys.argv[3])
    #rootFile = str(sys.argv[4])
    outputFile = str(sys.argv[4])

    #mozzilaTLDs=readTLDS("tlds.csv")
    mozzilaTLDs=readTLDS(mozzilaFile)
    #rootZoneFile=readRootZone(rootFile)
    alexa = readAlexa(alexaFile)
    outFile=open(outputFile,'a')
    alexaNOTLD=readAlexaTLDz(alexaFile)

    outFile.write("badDomain,f1,f1a,f1b,f5,f5substring,f6,f7,f8\n")
    with open(badDomains, 'r') as f:
        lines=f.readlines()
        for l in lines:
            print(l)
            vF1=feature1(l.rstrip())
            vF1a = feature1a(l.rstrip())
            vF1b = feature1b(l.rstrip())
            vF5=feature5(l.rstrip())
            vF5S=feature5Substring(l.rstrip())
            vF6 = feature6(l.rstrip())
            vF7=-1
            #comment here to disable Levi' s distance lookup -- it takes forever
            if vF1b==1:
                vF7=0
            else:
                vF7=subdomainDistance(l.rstrip())
            vF8=-1
            if vF5 == 1 or vF5S==1:
                vF8 = 0
            else:
                tempPath=getPath(l.rstrip())
                vF8 = pathDistance(l.rstrip())

            outFile.write(l.rstrip()+"," +str(vF1)+"," +str(vF1a)+"," +str(vF1b)+","+  str(vF5)+ "," + str(vF5S)+ "," + str(vF6)+ ","  + str(vF7)+ "," + str(vF8)+"\n")


    outFile.close()
#temp = "http://www.paypal.com.rctdecen3d2nm.compute.amazonaws.com/cgi-bin/webscr/?_dispatch=6f193a0473d3e4c0d58ea8e5f4046906e232edc9&amp;emaddr=abuse@aol.com&amp;referer=14-14&amp;login-processing=ok"


#print(feature1(temp,alexa))

#temp2="http://www.paypal.com.rctdecen3d2nm.compute.mail.yahoo.com/google/com/?_dispatch=6f193a0473d3e4c0d58ea8e5f4046906e232edc9&amp;emaddr=abuse@aol.com&amp;referer=14-14&amp;login-processing=ok"

#print(feature1(temp))
#print(feature1(temp2))


#print(feature5(temp))
#print(feature5(temp2))