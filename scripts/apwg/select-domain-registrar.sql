-- select abused domains with their registrar
-- for APWG domains

select domainname, registrarname,blacklistdate
from (

SELECT tld, domainname, CASE when registrarname_prev is not null then registrarname_prev
                             else registrarname
                        END as registrarname, to_date(blacklistdate) blacklistdate
from (select domain,blacklistdate
      from apwg_data
      where flag in (1,2)
      --and blacklistdate >= 2014-01-01 and blacklistdate <= 01-07-2014
      group by  domain,blacklistdate) apwg_data
left outer join 
    (select tld, domainname, registrarname_prev, registrarname,audit_auditupdateddate_prev, audit_auditupdateddate, audit_auditupdateddate_next
     from simple_whois_linked
     where domainname in (select distinct(domain) from apwg_data)) whois_rows
on apwg_data.domain = whois_rows.domainname
where (blacklistdate > audit_auditupdateddate_prev and  blacklistdate <= audit_auditupdateddate) OR
      (audit_auditupdateddate_prev is null and blacklistdate <= audit_auditupdateddate) OR
      (blacklistdate > audit_auditupdateddate and audit_auditupdateddate_next is null )
      
) as sub1
where tld in ('xxx','aero','asia','biz','cat','com','coop','edu','gov','info','int','jobs','mil','mobi','museum', 'name','net','org','post','pro','tel','travel')
order by domainname, registrarname,blacklistdate