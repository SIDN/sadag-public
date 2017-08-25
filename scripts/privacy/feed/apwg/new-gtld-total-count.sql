WITH filtered AS (
select tld,domainname,blacklistdate
    from sadag.apwg_data
    left outer join
        (select tld, domainname,audit_auditupdateddate_prev, audit_auditupdateddate, audit_auditupdateddate_next
         from sadag.simple_whois_linked_registrant
         where domainname in (select domain from sadag.apwg_data)) whois_rows
    on sadag.apwg_data.domain = whois_rows.domainname
    WHERE
          (blacklistdate > audit_auditupdateddate_prev and  blacklistdate <= audit_auditupdateddate) OR
          (audit_auditupdateddate_prev is null and blacklistdate <= audit_auditupdateddate) OR
          (blacklistdate > audit_auditupdateddate and audit_auditupdateddate_next is null )
)
select '{0}', count(distinct domainname) as domains
from filtered
where blacklistdate >= cast('{1}' as timestamp) and blacklistdate < cast('{2}' as timestamp)
and tld not in ('us','xxx','aero','asia','biz','cat','com','coop','edu','gov','info','int','jobs','mil','mobi','museum', 'name','net','org','post','pro','tel','travel')
