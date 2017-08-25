use sadag;

WITH filtered AS (
select tld,domainname,registrarname
    from sadag.spamhaus_data
    left outer join
        (select tld,domainname,registrarname,audit_auditupdateddate_prev, audit_auditupdateddate, audit_auditupdateddate_next
         from sadag.simple_whois_linked
         where domainname in (select domain from sadag.spamhaus_data)) whois_rows
    on sadag.spamhaus_data.domain = whois_rows.domainname
    WHERE
          (blacklistdate > audit_auditupdateddate_prev and  blacklistdate <= audit_auditupdateddate) OR
          (audit_auditupdateddate_prev is null and blacklistdate <= audit_auditupdateddate) OR
          (blacklistdate > audit_auditupdateddate and audit_auditupdateddate_next is null )
)
select reg_info.ianaid, registrar_name_impala.registrar, count(distinct domainname) as domains 
from filtered who, sadag.registrar_info_impala reg_info ,registrar_name_impala
where lower(split_part(who.registrarname,"|",1)) = reg_info.registrar
and registrar_name_impala.ianaid = reg_info.ianaid
and reg_info.ianaid is not null
and tld in ('xxx','aero','asia','biz','cat','com','coop','edu','gov','info','int','jobs','mil','mobi','museum', 'name','net','org','post','pro','tel','travel')
group by reg_info.ianaid,registrar_name_impala.registrar
order by domains desc;
