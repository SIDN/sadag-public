#!/usr/bin/env python

import sys
from impala.dbapi import connect
from datetime import date, timedelta, datetime
from dateutil.relativedelta import *

conn = connect(host='hadoop-data-01.sidnlabs.nl', port=21050, use_kerberos=True)
cursor = conn.cursor()

start_date = datetime.strptime(sys.argv[1], '%Y-%m-%d')
end_date = datetime.strptime(sys.argv[2], '%Y-%m-%d')

f = open(sys.argv[3], "w", 0)
#print start_date
#print end_date
while start_date < end_date:
    #print start_date.date()
    
    start_date = start_date + relativedelta(months=+1)
    start_date_bfore = start_date - relativedelta(months=+1)
    #print start_date.date()
    #print start_date_bfore.date()    

    sql = """

WITH filtered AS (
select domainname,tld,blacklistdate
    from sadag.surbl_data
    left outer join
        (select domainname,tld
         from sadag.simple_whois
         where domainname in (select domain from sadag.surbl_data)
         group by  domainname,tld) whois_rows
    on sadag.surbl_data.domain = whois_rows.domainname
)
select '{0}', count(distinct domainname) as domains
from filtered
where blacklistdate >= cast('{1}' as timestamp) and blacklistdate < cast('{2}' as timestamp)
and tld in ('xxx','aero','asia','biz','cat','com','coop','edu','gov','info','int','jobs','mil','mobi','museum', 'name','net','org','post','pro','tel','travel')


 """.format(start_date.date(),start_date_bfore.date(), start_date.date())


    print sql

    cursor.execute(sql)
    for qrow in cursor:
        print "{0},{1}\n".format(qrow[0], qrow[1])
        f.write("{0},{1}\n".format(qrow[0], qrow[1]))   
