##Metrics used in this code
2017-06-01
giovane moura

These are the metrics used in the code so far:



code usage:

    python3 features.py  $maliciousDomainsFile.csv $alexa1M.csv $mozzilaTLDFiles.csv  $outputFile.csv

Example below of outputFile.csv:


    URL,f1,f5,f5substring,f6
    http://toonbogers.nl/wp-content/languages/source/error/hk/card_info.php,0,0,1,0
    http://toonbogers.nl/wp-content/languages/source/error/hk/index.php,0,0,1,0
    http://ecowatches.nl/asdad/amazon=signin8encoding4UTF84openid64assoc45handle45gbflex34openid65claimed3453344334e3j23n23n42832kjk28922/ap/35293/signin.php,0,0,1,0
    http://cardonlineservices.nl/51AS8E1T2DC8R1T/index.php,0,0,1,0
    http://cardonlineservices.nl/51AS8E1T2DC8R1T/,0,0,1,0
    http://vandaagaanmelden.nl/https/bankieren.rabobank.nl/klanten/,0,1,1,0
  
 an URL is composed of:
 http://DOMAIN/PATH/PATH/path.html$VARs$VAR
 
 a domain is composed of <SUBDOMAIN.2LD>
 
 so:
    
    f1=1 if  phishing is the DOMAIN part
    f1a= if phishing on 2LD part 
    f1b= if phihshing on SUBDOMAIN part (see above)
    f5=1 if phishing on the PATH part (exact match with alexa 1M)
    f5substring is F5, but the match does not have to exclusive. that's why econswatches above, which has amaozn on PATH does not give 1 for f5, but gives for f5substring
    f6=1 if phishing is on the variables (separated by "&" )
    f7= mininum Levi's distance (https://en.wikipedia.org/wiki/Levenshtein_distance) from SUBDOMAIN combinations to ALL alexa 1M -- for the DOMAIN part
    f8= mininum Levi's distance for the PATH
    
    NOTICE that ALWAYS:
    f7=0 if f1b=1
    f8=0 if f1a=1
    f9=0 if f5=1
    f10=0 if f6=1
    
 
  Notes:
  
 
Possible sources for alexa 1millioN:

https://s3-us-west-1.amazonaws.com/umbrella-static/index.html
(from cisco) 

and alexa1m (outdated?
) http://s3.amazonaws.com/alexa-static/top-1m.csv.zip 



