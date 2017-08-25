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
select tld,domainname,blacklistdate,registrant_name, registrant_organization
    from sadag.sdf_data
    left outer join
        (select tld, domainname,audit_auditupdateddate_prev, audit_auditupdateddate, audit_auditupdateddate_next,
        registrant_name, registrant_organization
         from sadag.simple_whois_linked_registrant
         where domainname in (select domain from sadag.sdf_data)) whois_rows
    on sadag.sdf_data.domain = whois_rows.domainname
    WHERE
          (blacklistdate > audit_auditupdateddate_prev and  blacklistdate <= audit_auditupdateddate) OR
          (audit_auditupdateddate_prev is null and blacklistdate <= audit_auditupdateddate) OR
          (blacklistdate > audit_auditupdateddate and audit_auditupdateddate_next is null )
)
select "{0}", count(distinct domainname) as domains
from (
select domainname
from filtered who, sadag.privacy_service_data priv
where lower(who.registrant_name) = priv.registrant_name
    AND lower(who.registrant_organization) = priv.registrant_organization
and blacklistdate >=  cast('{1}' as timestamp) and blacklistdate < cast('{2}' as timestamp)
and tld not in ('us','xxx','aero','asia','biz','cat','com','coop','edu','gov','info','int','jobs','mil','mobi','museum', 'name','net','org','post','pro','tel','travel')
union
select domainname
from filtered who
where ( lower(who.registrant_name) = 'perfect privacy, llc'
        OR lower(who.registrant_name) like 'privacydotlink customer %'
        OR lower(who.registrant_name) like '% dynadot privacy'
        OR lower(who.registrant_name) like '%(c/o rebel.com privacy service)'
       )
and blacklistdate >=  cast('{1}' as timestamp) and blacklistdate < cast('{2}' as timestamp)
and tld not in ('us','xxx','aero','asia','biz','cat','com','coop','edu','gov','info','int','jobs','mil','mobi','museum', 'name','net','org','post','pro','tel','travel')
) as all_matches;

 """.format(start_date.date(),start_date_bfore.date(), start_date.date())


    print sql

    cursor.execute(sql)
    for qrow in cursor:
        print "{0},{1}\n".format(qrow[0], qrow[1])
        f.write("{0},{1}\n".format(qrow[0], qrow[1]))   
