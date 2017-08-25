select "2014-06-30", count(distinct domainname) as domains
from (
select domainname
from simple_whois who, privacy_service_data priv
where lower(who.registrant_name) = priv.registrant_name
    AND lower(who.registrant_organization) = priv.registrant_organization
and audit_auditupdateddate >= cast('2014-01-01' as timestamp) and audit_auditupdateddate <= cast('2014-07-01' as timestamp)
and tld not in ('us','xxx','aero','asia','biz','cat','com','coop','edu','gov','info','int','jobs','mil','mobi','museum', 'name','net','org','post','pro','tel','travel')
union
select domainname
from simple_whois who
where ( lower(who.registrant_name) = 'perfect privacy, llc'
        OR lower(who.registrant_name) like 'privacydotlink customer %'
        OR lower(who.registrant_name) like '% dynadot privacy'
        OR lower(who.registrant_name) like '%(c/o rebel.com privacy service)'
       )
and audit_auditupdateddate >= cast('2014-01-01' as timestamp) and audit_auditupdateddate <= cast('2014-07-01' as timestamp)
and tld not in ('us','xxx','aero','asia','biz','cat','com','coop','edu','gov','info','int','jobs','mil','mobi','museum', 'name','net','org','post','pro','tel','travel')
) as all_matches

union

select "2014-12-31", count(distinct domainname) as domains
from (
select domainname
from simple_whois who, privacy_service_data priv
where lower(who.registrant_name) = priv.registrant_name
    AND lower(who.registrant_organization) = priv.registrant_organization
and audit_auditupdateddate >= cast('2014-07-01' as timestamp) and audit_auditupdateddate <= cast('2014-12-31' as timestamp)
and tld not in ('us','xxx','aero','asia','biz','cat','com','coop','edu','gov','info','int','jobs','mil','mobi','museum', 'name','net','org','post','pro','tel','travel')
union
select domainname
from simple_whois who
where ( lower(who.registrant_name) = 'perfect privacy, llc'
        OR lower(who.registrant_name) like 'privacydotlink customer %'
        OR lower(who.registrant_name) like '% dynadot privacy'
        OR lower(who.registrant_name) like '%(c/o rebel.com privacy service)'
       )
and audit_auditupdateddate >= cast('2014-07-01' as timestamp) and audit_auditupdateddate <= cast('2014-12-31' as timestamp)
and tld not in ('us','xxx','aero','asia','biz','cat','com','coop','edu','gov','info','int','jobs','mil','mobi','museum', 'name','net','org','post','pro','tel','travel')
) as all_matches

union

select "2015-06-30", count(distinct domainname) as domains
from (
select domainname
from simple_whois who, privacy_service_data priv
where lower(who.registrant_name) = priv.registrant_name
    AND lower(who.registrant_organization) = priv.registrant_organization
and audit_auditupdateddate >= cast('2015-01-01' as timestamp) and audit_auditupdateddate <= cast('2015-07-01' as timestamp)
and tld not in ('us','xxx','aero','asia','biz','cat','com','coop','edu','gov','info','int','jobs','mil','mobi','museum', 'name','net','org','post','pro','tel','travel')
union
select domainname
from simple_whois who
where ( lower(who.registrant_name) = 'perfect privacy, llc'
        OR lower(who.registrant_name) like 'privacydotlink customer %'
        OR lower(who.registrant_name) like '% dynadot privacy'
        OR lower(who.registrant_name) like '%(c/o rebel.com privacy service)'
       )
and audit_auditupdateddate >= cast('2015-01-01' as timestamp) and audit_auditupdateddate <= cast('2015-07-01' as timestamp)
and tld not in ('us','xxx','aero','asia','biz','cat','com','coop','edu','gov','info','int','jobs','mil','mobi','museum', 'name','net','org','post','pro','tel','travel')
) as all_matches

union

select "2015-12-31", count(distinct domainname) as domains
from (
select domainname
from simple_whois who, privacy_service_data priv
where lower(who.registrant_name) = priv.registrant_name
    AND lower(who.registrant_organization) = priv.registrant_organization
and audit_auditupdateddate >= cast('2015-07-01' as timestamp) and audit_auditupdateddate <= cast('2015-12-31' as timestamp)
and tld not in ('us','xxx','aero','asia','biz','cat','com','coop','edu','gov','info','int','jobs','mil','mobi','museum', 'name','net','org','post','pro','tel','travel')
union
select domainname
from simple_whois who
where ( lower(who.registrant_name) = 'perfect privacy, llc'
        OR lower(who.registrant_name) like 'privacydotlink customer %'
        OR lower(who.registrant_name) like '% dynadot privacy'
        OR lower(who.registrant_name) like '%(c/o rebel.com privacy service)'
       )
and audit_auditupdateddate >= cast('2015-07-01' as timestamp) and audit_auditupdateddate <= cast('2015-12-31' as timestamp)
and tld not in ('us','xxx','aero','asia','biz','cat','com','coop','edu','gov','info','int','jobs','mil','mobi','museum', 'name','net','org','post','pro','tel','travel')
) as all_matches

union

select "2016-06-30", count(distinct domainname) as domains
from (
select domainname
from simple_whois who, privacy_service_data priv
where lower(who.registrant_name) = priv.registrant_name
    AND lower(who.registrant_organization) = priv.registrant_organization
and audit_auditupdateddate >= cast('2016-01-01' as timestamp) and audit_auditupdateddate <= cast('2016-07-01' as timestamp)
and tld not in ('us','xxx','aero','asia','biz','cat','com','coop','edu','gov','info','int','jobs','mil','mobi','museum', 'name','net','org','post','pro','tel','travel')
union
select domainname
from simple_whois who
where ( lower(who.registrant_name) = 'perfect privacy, llc'
        OR lower(who.registrant_name) like 'privacydotlink customer %'
        OR lower(who.registrant_name) like '% dynadot privacy'
        OR lower(who.registrant_name) like '%(c/o rebel.com privacy service)'
       )
and audit_auditupdateddate >= cast('2016-01-01' as timestamp) and audit_auditupdateddate <= cast('2016-07-01' as timestamp)
and tld not in ('us','xxx','aero','asia','biz','cat','com','coop','edu','gov','info','int','jobs','mil','mobi','museum', 'name','net','org','post','pro','tel','travel')
) as all_matches

union

select "2016-12-31", count(distinct domainname) as domains
from (
select domainname
from simple_whois who, privacy_service_data priv
where lower(who.registrant_name) = priv.registrant_name
    AND lower(who.registrant_organization) = priv.registrant_organization
and audit_auditupdateddate >= cast('2016-07-01' as timestamp) and audit_auditupdateddate <= cast('2016-12-31' as timestamp)
and tld not in ('us','xxx','aero','asia','biz','cat','com','coop','edu','gov','info','int','jobs','mil','mobi','museum', 'name','net','org','post','pro','tel','travel')
union
select domainname
from simple_whois who
where ( lower(who.registrant_name) = 'perfect privacy, llc'
        OR lower(who.registrant_name) like 'privacydotlink customer %'
        OR lower(who.registrant_name) like '% dynadot privacy'
        OR lower(who.registrant_name) like '%(c/o rebel.com privacy service)'
       )
and audit_auditupdateddate >= cast('2016-07-01' as timestamp) and audit_auditupdateddate <= cast('2016-12-31' as timestamp)
and tld not in ('us','xxx','aero','asia','biz','cat','com','coop','edu','gov','info','int','jobs','mil','mobi','museum', 'name','net','org','post','pro','tel','travel')
) as all_matches




