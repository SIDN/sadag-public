WITH apwg_registars AS (
select tld,domainname,lower(split_part(CASE when registrarname_prev is not null then registrarname_prev
                                        else registrarname
                                   END,"|",1
                        )) as registrarname,standardregcreateddate
    from sadag.apwg_data
    left outer join
        (select tld, domainname,registrarname,registrarname_prev,audit_auditupdateddate_prev, audit_auditupdateddate, audit_auditupdateddate_next,standardregcreateddate
         from simple_whois_linked
         where domainname in (select domain from apwg_data)) whois_rows
    on apwg_data.domain = whois_rows.domainname
    where (blacklistdate > audit_auditupdateddate_prev and  blacklistdate <= audit_auditupdateddate) OR
          (audit_auditupdateddate_prev is null and blacklistdate <= audit_auditupdateddate) OR
          (blacklistdate > audit_auditupdateddate and audit_auditupdateddate_next is null )
) 
select '{0}', count(distinct domainname) as domains
from apwg_registars apwg
where standardregcreateddate >= cast('{1}' as timestamp) and standardregcreateddate < cast('{2}' as timestamp)
and tld in ('xxx','aero','asia','biz','cat','com','coop','edu','gov','info','int','jobs','mil','mobi','museum', 'name','net','org','post','pro','tel','travel')








