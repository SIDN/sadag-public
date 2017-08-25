'''
2017-05-29
Giovane Moura giovane.moura@sidn.nl
this code does what Maciej asked me:


Could you then implement it as a python method so that I can use it in my classifier? As an input it would take a full URL like: http://www.paypal.com.rctdecen3d2nm.immvh.com/cgi-bin/webscr/?_dispatch=6f193a0473d3e4c0d58ea8e5f4046906e232edc9&amp;emaddr=abuse@aol.com&amp;referer=14-14&amp;login-processing=ok.

I was thinking that maybe you could implement the following six related features:

1) if the second level domain suffix contains any exact Alexa domain, e.g.
YES: http://facebook-login.com.pl/login-to-facebook/

2) if the second level domain suffix contains any trigram (Predator method)

3) if any other subdomain suffix contains an exact Alexa domain, e.g.
YES: http://www.paypal.com.rctdecen3d2nm.immvh.com/cgi-bin/webscr/?_dispatch=6f193a0473d3e4c0d58ea8e5f4046906e232edc9&amp;emaddr=abuse@aol.com&amp;referer=14-14&amp;login-processing=ok

4) if any other subdomain suffix "contains" any trigram, e.g.
YES: http://facbok.user.loginh.com/

5) if any URL suffix contains any exact Alexa domain, e.g.
YES: http://pagereading.ggg.co.nz/2015/06/wells-fargo-personal-business-banking.html?spref=tw

6) if any URL suffix "contains" any trigram, e.g.
YES: http://loginh.com/facbook-login-page


'''

import tldextract
from tld.utils import get_tld
from urllib.parse import urlparse
import logging

#first, process the TLDs from suffix list:
#python prepare_tlds.py  public_suffix_list.dat |cut -d'"' -f2 > tlds.csv
#tlds.csv continas a list of tlds that accept regsitraiton


def getPath(s):
    return urlparse(s).path


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


def readAlexa(path):
    alexa = set()
    with  open(path) as f:

        line=f.readlines()
        for k in line:
            k= k.rstrip()
            alexa.add(k)

    return alexa

#then, read the alexa 1m list

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

#then, read the test domain files

def parseURL(url):
   
    url = url.replace("http://", "")
    url = url.replace("https://", "")

    aTemp = url.split("/")
    dTemp = aTemp[0]

    restTemp = ""
    for k in range(1, len(aTemp)):
        restTemp = restTemp + "/" + aTemp[k].rstrip()

    r=[]
    r.append(dTemp)
    r.append(restTemp)
    return r


def getTLDObj(s):
    mix = ""
    try:
        mix = get_tld(s, as_object=True)
    except:
        logging.debug('Error with get_tld()        function: % s        ' % s)

    return mix


#1) if the second level domain suffix contains any exact Alexa domain, e.g.
#YES: http://facebook-login.com.pl/login-to-facebook/
#def f1(stringz):

def compareSubdomainWithAlexa(s,alexa):
    result=0
    #gets a paypal for example
    for k in alexa:
        subdomain=getTLDObj(k)
        subdomainPerDash = subdomain.split("-")
        subdomaniPerDot = subdomain.splitd(".")

        for k in subdomainPerDash:
            if k != "www":
                if s==k:
                    result=1

        print(s+" , " + k)

        if result!=1:
            for k in subdomaniPerDot:
                if k != "www":
                    if s == k:
                        result = 1

        return result


def feature1(domain,alexa):

    result=-1
    #get a domain and an alexa set
    #for each entry in alexa, see if it contains any
    tldOBJ=getTLDObj(domain)
    #this fully qualified domain name can be either splitted by " ." or " -"
    #so let's split it using these methods and see if it contains any of the alexa entries
    #see    https://pypi.python.org/pypi/tld
    #subdomain is like phishing-www.bad from *bad.com

    subdomain=tldOBJ.subdomain

    #we need to split this subdomain into "."  and " -"
    subdomainPerDash=subdomain.split("-")
    subdomaniPerDot=subdomain.splitd(".")

    #for each of them, we compare against each subdomain of alexa, excluding www

    for k in subdomainPerDash:
        if k!= "www":
         result=compareSubdomainWithAlexa(k,alexa)

    if result!=1:
        for k in subdomaniPerDot:
            if k != "www":
                result = compareSubdomainWithAlexa(k, alexa)

    return result

def readMaledetti():

    tlds=readTLDS("tlds.csv")

    #let's first consider maciej's example
    # http://www.paypal.com.rctdecen3d2nm.immvh.com/cgi-bin/webscr/?_dispatch=6f193a0473d3e4c0d58ea8e5f4046906e232edc9&amp;emaddr=abuse@aol.com&amp;referer=14-14&amp;login-processing=ok
    temp = "http://www.paypal.com.rctdecen3d2nm.immvh.com/cgi-bin/webscr/?_dispatch=6f193a0473d3e4c0d58ea8e5f4046906e232edc9&amp;emaddr=abuse@aol.com&amp;referer=14-14&amp;login-processing=ok"
    temp= "http://www.paypal.com.rctdecen3d2nm.compute.amazonaws.com/cgi-bin/webscr/?_dispatch=6f193a0473d3e4c0d58ea8e5f4046906e232edc9&amp;emaddr=abuse@aol.com&amp;referer=14-14&amp;login-processing=ok"

    a=parseURL(temp)

    fqdn=a[0]
    rest=a[1]

    #now, what I have to do:
    # 1. get the FQDN
    # 2. determine if parts of it contains a entry at alexa

    #now, I have to discard the TLD part from the tlds dict

    preTLD=fqdn.split(".")[-1]

    tldsOfThisone=tlds[preTLD]

    #now, test for every entry if there's a match
    toBeRemovedFromFqdn=""
    #for each TLD under this 2LD, we need to verify if fqdn falls into it
    f1result=0
    for k in tldsOfThisone:

        nSubz=len(k.split("."))

        #now, use this number to create a entry to verify against the fqdn
        if len(fqdn)>=nSubz:
            #then we can do the comparsion
            #get the nSubz from fqdn
            testDomain=""
            splittedFqdn=fqdn.split(".")
            for x in range (0, nSubz):
                if x==0:
                    testDomain=splittedFqdn[len(splittedFqdn)-1 -x].rstrip()
                else:
                    testDomain=splittedFqdn[len(splittedFqdn)-1 -x].rstrip()+ "."+testDomain
            #now, we have to check if this testDomain matches exactly as the fqdn entry
            #print(testDomain)
            if testDomain==k:
                toBeRemovedFromFqdn=testDomain
                break;

    #print("Have to remove "+ str(toBeRemovedFromFqdn))

    domainToBeChecked=fqdn.replace(toBeRemovedFromFqdn,"")
    if domainToBeChecked[-1]==".":
        domainToBeChecked=domainToBeChecked[:-1]

    return domainToBeChecked


def f1(domain):

    #now, do these features
    #now we have a domain like www.paypal.com.rctdecen3d2nm to verify
    #we can't simply look it up on the alexa list; we need to permuatate it
    #analyze www.paypal
    #www.paypal.com
    #www.paypal.com.rctdecen3d2nm
    #paypal.com
    #aypal.com.rctdecen3d2nm
    #com.rctdecen3d2nm
    alexa=readAlexa("top100.csv")

    f1Result=0
    setOfCombinations=set()

    nSubdomains=len(domain.split(","))
    tlds = readTLDS("tlds.csv")

    #for x in range (0, nSubdomains-2):


        #let's say the first part is www.
        #here'show we do




alexa=readAlexa("top100.csv")
temp = "http://www.paypal.com.rctdecen3d2nm.compute.amazonaws.com/cgi-bin/webscr/?_dispatch=6f193a0473d3e4c0d58ea8e5f4046906e232edc9&amp;emaddr=abuse@aol.com&amp;referer=14-14&amp;login-processing=ok"
print(feature1(temp,alexa))

#demo
#a=readTLDS("tlds.csv")
#this list must be in stripped from http:// and https:/

#b=readAlexa("top100.csv")
#domain=readMaledetti()
#resultf1=f1(domain)

