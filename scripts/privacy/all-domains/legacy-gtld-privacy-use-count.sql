select "{0}", count(distinct domainname) as domains
from (
select domainname
from sadag.simple_whois who, sadag.privacy_service_data priv
where lower(who.registrant_name) = priv.registrant_name
    AND lower(who.registrant_organization) = priv.registrant_organization
and standardregcreateddate >=  cast('{1}' as timestamp) and standardregcreateddate < cast('{2}' as timestamp)
and tld in ('xxx','aero','asia','biz','cat','com','coop','edu','gov','info','int','jobs','mil','mobi','museum', 'name','net','org','post','pro','tel','travel')
union
select domainname
from sadag.simple_whois who
where ( lower(who.registrant_name) = 'perfect privacy, llc'
        OR lower(who.registrant_name) like 'privacydotlink customer %'
        OR lower(who.registrant_name) like '% dynadot privacy'
        OR lower(who.registrant_name) like '%(c/o rebel.com privacy service)'
       )
and standardregcreateddate >=  cast('{1}' as timestamp) and standardregcreateddate < cast('{2}' as timestamp)
and tld in ('xxx','aero','asia','biz','cat','com','coop','edu','gov','info','int','jobs','mil','mobi','museum', 'name','net','org','post','pro','tel','travel')
) as all_matches;