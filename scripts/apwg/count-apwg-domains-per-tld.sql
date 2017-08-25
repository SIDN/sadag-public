--count apwg domains per tld
-- count all, count fqns?

SELECT tld,count(1) as domains
from (select domain,fqdn,path,phish_date
      from apwg_data
      where year(phish_date) = 2016 and month(phish_date) >= 10 and month(phish_date) <= 12 
      group by  domain,fqdn,path,phish_date) apwg_data
left outer join 
    (select tld,domainname, registrarname_prev, registrarname,audit_auditupdateddate_prev, audit_auditupdateddate, audit_auditupdateddate_next
     from simple_whois_linked
     where domainname in (select distinct(domain) from apwg_data)) whois_rows
on apwg_data.domain = whois_rows.domainname
where (phish_date > audit_auditupdateddate_prev and  phish_date <= audit_auditupdateddate) OR
      (audit_auditupdateddate_prev is null and phish_date <= audit_auditupdateddate) OR
      (phish_date > audit_auditupdateddate and audit_auditupdateddate_next is null )
group by tld
order by domains desc
