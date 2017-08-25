WITH filtered AS (
select tld,domainname,blacklistdate,registrant_name, registrant_organization
    from sadag.stopbadware_data
    left outer join
        (select tld, domainname,audit_auditupdateddate_prev, audit_auditupdateddate, audit_auditupdateddate_next,standardregcreateddate,
        registrant_name, registrant_organization
         from sadag.simple_whois_linked_registrant
         where domainname in (select domain from sadag.stopbadware_data where flag in (1,2))) whois_rows
    on sadag.stopbadware_data.domain = whois_rows.domainname
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
and blacklistdate >= cast('{1}' as timestamp) and blacklistdate < cast('{2}' as timestamp)
and tld in ('xxx','aero','asia','biz','cat','com','coop','edu','gov','info','int','jobs','mil','mobi','museum', 'name','net','org','post','pro','tel','travel')
union
select domainname
from filtered who
where ( lower(who.registrant_name) = 'perfect privacy, llc'
        OR lower(who.registrant_name) like 'privacydotlink customer %'
        OR lower(who.registrant_name) like '% dynadot privacy'
        OR lower(who.registrant_name) like '%(c/o rebel.com privacy service)'
       )
and blacklistdate >= cast('{1}' as timestamp) and blacklistdate < cast('{2}' as timestamp)
and tld in ('xxx','aero','asia','biz','cat','com','coop','edu','gov','info','int','jobs','mil','mobi','museum', 'name','net','org','post','pro','tel','travel')
) as all_matches;