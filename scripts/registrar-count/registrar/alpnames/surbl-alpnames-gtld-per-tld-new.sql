use sadag;

WITH filtered AS (
select tld,domainname,registrarname,blacklistdate
    from sadag.surbl_data
    left outer join
        (select tld,domainname,registrarname,audit_auditupdateddate_prev, audit_auditupdateddate, audit_auditupdateddate_next
         from sadag.simple_whois_linked
         where domainname in (select domain from sadag.surbl_data)) whois_rows
    on sadag.surbl_data.domain = whois_rows.domainname
    WHERE
          (blacklistdate > audit_auditupdateddate_prev and  blacklistdate <= audit_auditupdateddate) OR
          (audit_auditupdateddate_prev is null and blacklistdate <= audit_auditupdateddate) OR
          (blacklistdate > audit_auditupdateddate and audit_auditupdateddate_next is null )
)
select to_date(trunc(blacklistdate, 'MONTH')) as "date", count(distinct domainname) as domains 
from filtered who, sadag.registrar_info_impala reg_info
where lower(split_part(who.registrarname,"|",1)) = reg_info.registrar
and reg_info.ianaid = 1857 --alpnames
and tld not in ('us','xxx','aero','asia','biz','cat','com','coop','edu','gov','info','int','jobs','mil','mobi','museum', 'name','net','org','post','pro','tel','travel')
group by to_date(trunc(blacklistdate, 'MONTH'))
order by to_date(trunc(blacklistdate, 'MONTH')) asc;

