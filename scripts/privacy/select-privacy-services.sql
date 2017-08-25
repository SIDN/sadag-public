-- get all potential privacy services
select lower(registrant_name),lower(registrant_organization), count(distinct(domainname)) as tot
from simple_whois
group by registrant_name,registrant_organization
order by tot desc
limit 5000
 
-- privacydotlink has unique name per client

select lower(registrant_name),lower(registrant_organization), count(distinct(domainname)) as tot
from simple_whois
where lower(registrant_name) like 'privacydotlink customer%'
group by registrant_name,registrant_organization
order by tot desc
limit 5000


create external table sadag.privacy_service_data (registrant_name string,registrant_organization string,domains int)
row format delimited fields terminated by ","
STORED AS PARQUET
LOCATION '/user/hive/sadag/privacy-service-impala';

-- HIVE
-- map hive table to csv file
create external table sadag.privacy_service_staging (registrant_name string,registrant_organization string,domains int)
row format delimited fields terminated by ","
LOCATION '/user/hive/sadag/privacy-service-staging'
tblproperties("skip.header.line.count"="1");

INSERT INTO TABLE privacy_service_data
select registrant_name,registrant_organization,sum(domains) from sadag.privacy_service_staging
group by registrant_name,registrant_organization

-- END HIVE


-- count new gtld names using privacy service
select count(distinct domainname) as domains
from (
select domainname,who.registrant_name,who.registrant_organization,audit_auditupdateddate
from simple_whois who, privacy_service_data priv
where lower(who.registrant_name) = priv.registrant_name
    AND lower(who.registrant_organization) = priv.registrant_organization
and audit_auditupdateddate >= cast('2016-01-01' as timestamp) and audit_auditupdateddate <= cast('2016-07-01' as timestamp)
and tld not in ('xxx','aero','asia','biz','cat','com','coop','edu','gov','info','int','jobs','mil','mobi','museum', 'name','net','org','post','pro','tel','travel')
union
select domainname,who.registrant_name,who.registrant_organization,audit_auditupdateddate
from simple_whois who
where ( lower(who.registrant_name) = 'perfect privacy, llc'
        OR lower(who.registrant_name) like 'privacydotlink customer %'
        OR lower(who.registrant_name) like '% dynadot privacy'
        OR lower(who.registrant_name) like '%(c/o rebel.com privacy service)'
       )
and audit_auditupdateddate >= cast('2016-01-01' as timestamp) and audit_auditupdateddate <= cast('2016-07-01' as timestamp)
and tld not in ('xxx','aero','asia','biz','cat','com','coop','edu','gov','info','int','jobs','mil','mobi','museum', 'name','net','org','post','pro','tel','travel')
) as all_matches

-- count new gtld names using privacy service per tld

-- count new gtld names using privacy service per tld
select tld,count(distinct domainname) as domains
from (
select tld,domainname
from simple_whois who, privacy_service_data priv
where lower(who.registrant_name) = priv.registrant_name
    AND lower(who.registrant_organization) = priv.registrant_organization
and audit_auditupdateddate >= cast('2016-01-01' as timestamp) and audit_auditupdateddate <= cast('2016-07-01' as timestamp)
and tld not in ('xxx','aero','asia','biz','cat','com','coop','edu','gov','info','int','jobs','mil','mobi','museum', 'name','net','org','post','pro','tel','travel')
group by tld,domainname
union
select tld, domainname
from simple_whois who
where ( lower(who.registrant_name) = 'perfect privacy, llc'
        OR lower(who.registrant_name) like 'privacydotlink customer %'
        OR lower(who.registrant_name) like '% dynadot privacy'
        OR lower(who.registrant_name) like '%(c/o rebel.com privacy service)'
       )
and audit_auditupdateddate >= cast('2016-01-01' as timestamp) and audit_auditupdateddate <= cast('2016-07-01' as timestamp)
and tld not in ('xxx','aero','asia','biz','cat','com','coop','edu','gov','info','int','jobs','mil','mobi','museum', 'name','net','org','post','pro','tel','travel')
group by tld,domainname
) as all_matches
group by tld
order by domains desc

 
select count(distinct domainname)
from simple_whois who, privacy_service_data priv
where lower(who.registrant_name) like 'privacydotlink customer %'

-- find more privacy services

select lower(registrant_name),lower(registrant_organization), count(distinct(domainname)) as tot
from simple_whois
where (
lower(registrant_name) like '%privacy%'
or lower(registrant_name) like '%proxy%'
or lower(registrant_name) like '%private%'
or lower(registrant_name) like '%protect%'
or lower(registrant_organization) like '%privacy%'
or lower(registrant_organization) like '%proxy%'
or lower(registrant_organization) like '%private%'
or lower(registrant_organization) like '%protect%')
and lower(registrant_name)  not like 'privacydotlink customer %'
and lower(registrant_name)  not like '% dynadot privacy'
group by lower(registrant_name),lower(registrant_organization)
order by tot desc
limit 10000

--also add "c/o whoisproxy.com ltd."


select count(*)
from privacy_service_data

select *
from privacy_service_data
order by domains desc