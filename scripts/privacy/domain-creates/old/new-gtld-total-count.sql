select "2014-06-30", count(distinct domainname) as domains
from simple_whois who
where audit_auditupdateddate >= cast('2014-01-01' as timestamp) and audit_auditupdateddate <= cast('2014-07-01' as timestamp)
and tld not in ('us','xxx','aero','asia','biz','cat','com','coop','edu','gov','info','int','jobs','mil','mobi','museum', 'name','net','org','post','pro','tel','travel')

union

select "2014-12-31", count(distinct domainname) as domains
from simple_whois who
where audit_auditupdateddate >= cast('2014-07-01' as timestamp) and audit_auditupdateddate <= cast('2014-12-31' as timestamp)
and tld not in ('us','xxx','aero','asia','biz','cat','com','coop','edu','gov','info','int','jobs','mil','mobi','museum', 'name','net','org','post','pro','tel','travel')

union

select "2015-06-30", count(distinct domainname) as domains
from simple_whois who
where audit_auditupdateddate >= cast('2015-01-01' as timestamp) and audit_auditupdateddate <= cast('2015-07-01' as timestamp)
and tld not in ('us','xxx','aero','asia','biz','cat','com','coop','edu','gov','info','int','jobs','mil','mobi','museum', 'name','net','org','post','pro','tel','travel')

union

select "2015-12-31", count(distinct domainname) as domains
from simple_whois who
where audit_auditupdateddate >= cast('2015-07-01' as timestamp) and audit_auditupdateddate <= cast('2015-12-31' as timestamp)
and tld not in ('us','xxx','aero','asia','biz','cat','com','coop','edu','gov','info','int','jobs','mil','mobi','museum', 'name','net','org','post','pro','tel','travel')


union

select "2016-06-30", count(distinct domainname) as domains
from simple_whois who
where audit_auditupdateddate >= cast('2016-01-01' as timestamp) and audit_auditupdateddate <= cast('2016-07-01' as timestamp)
and tld not in ('us','xxx','aero','asia','biz','cat','com','coop','edu','gov','info','int','jobs','mil','mobi','museum', 'name','net','org','post','pro','tel','travel')

union

select "2016-12-31", count(distinct domainname) as domains
from simple_whois who
where audit_auditupdateddate >= cast('2016-07-01' as timestamp) and audit_auditupdateddate <= cast('2016-12-31' as timestamp)
and tld not in ('us','xxx','aero','asia','biz','cat','com','coop','edu','gov','info','int','jobs','mil','mobi','museum', 'name','net','org','post','pro','tel','travel')



