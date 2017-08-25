
-- create timeseries data

--overal stats
--registrar_domains_2014-2016.csv
--registrar_legacy_domains_2014-2016.csv

SELECT '30-06-2016' scanned,split_part(registrarname,"|",1) registrarName, count(distinct domainname) as domains
FROM simple_whois
where audit_auditupdateddate >= '2016-01-01' and audit_auditupdateddate < '2016-07-01'
group by scanned, registrarName
order by domains desc

SELECT '31-12-2016' scanned,split_part(registrarname,"|",1) registrarName, count(distinct domainname) as domains
FROM simple_whois
where audit_auditupdateddate >= '2016-07-01' and audit_auditupdateddate < '2017-01-01'
group by scanned, registrarName
order by domains desc


-- get total legacy domains per registrar from whois for all data

SELECT '30-6-2016' scanned,split_part(registrarname,"|",1) registrarName, count(distinct domainname) as domains
FROM simple_whois
where audit_auditupdateddate >= '2016-01-01' and audit_auditupdateddate < '2016-07-01'
and tld in ('aero','asia','biz','cat','com','coop','edu','gov','info','int','jobs','mil','mobi','museum', 'name','net','org','post','pro','tel','travel')
group by scanned, registrarName
order by domains desc

SELECT '31-12-2014' scanned,split_part(registrarname,"|",1) registrarName, count(distinct domainname) as domains
FROM simple_whois
where audit_auditupdateddate >= '2014-07-01' and audit_auditupdateddate < '2015-01-01'
and tld in ('aero','asia','biz','cat','com','coop','edu','gov','info','int','jobs','mil','mobi','museum', 'name','net','org','post','pro','tel','travel')
group by scanned, registrarName
order by domains desc

--apwg stats
--domains-per-registrar-apwg_2014-2016.csv
--domains-legacy-per-registrar-apwg-2014-2016.csv


-- get total # of apwg domains per registrar from apwg
select '31-12-2016' scanned, registrarname, count(distinct domainname) as domains
from (

SELECT tld, domainname, CASE when registrarName_prev is not null then split_part(registrarName_prev,"|",1)
                             else split_part(registrarName,"|",1)
                        END as registrarname, to_date(blacklistdate) blacklistdate
from (select domain,blacklistdate
      from apwg_data
      where flag in (1,2)
      and blacklistdate >= '2016-07-01' and blacklistdate < '2017-01-01'
      group by  domain,blacklistdate) apwg_data
left outer join 
    (select tld, domainname, registrarname_prev, registrarname,audit_auditupdateddate_prev, audit_auditupdateddate, audit_auditupdateddate_next,
    standardregcreateddate, standardregupdateddate
     from simple_whois_linked
     where domainname in (select distinct(domain) from apwg_data)) whois_rows
on apwg_data.domain = whois_rows.domainname
where (blacklistdate > audit_auditupdateddate_prev and  blacklistdate <= audit_auditupdateddate) OR
      (audit_auditupdateddate_prev is null and blacklistdate <= audit_auditupdateddate) OR
      (blacklistdate > audit_auditupdateddate and audit_auditupdateddate_next is null )
      
) as sub1
group by scanned, registrarname
order by domains desc



-- get total legacy domains per registrar from apwg

select '30-06-2016' scanned, registrarname, count(distinct domainname) as domains
from (

SELECT tld, domainname, CASE when registrarName_prev is not null then split_part(registrarName_prev,"|",1)
                             else split_part(registrarName,"|",1)
                        END as registrarname, to_date(blacklistdate) blacklistdate
from (select domain,blacklistdate
      from apwg_data
      where flag in (1,2)
      and blacklistdate >= '2016-01-01' and blacklistdate < '2016-07-01'
      group by  domain,blacklistdate) apwg_data
left outer join 
    (select tld, domainname, registrarname_prev, registrarname,audit_auditupdateddate_prev, audit_auditupdateddate, audit_auditupdateddate_next,
    standardregcreateddate, standardregupdateddate
     from simple_whois_linked
     where domainname in (select distinct(domain) from apwg_data)) whois_rows
on apwg_data.domain = whois_rows.domainname
where (blacklistdate > audit_auditupdateddate_prev and  blacklistdate <= audit_auditupdateddate) OR
      (audit_auditupdateddate_prev is null and blacklistdate <= audit_auditupdateddate) OR
      (blacklistdate > audit_auditupdateddate and audit_auditupdateddate_next is null )
      
) as sub1
where tld in ('aero','asia','biz','cat','com','coop','edu','gov','info','int','jobs','mil','mobi','museum', 'name','net','org','post','pro','tel','travel')
group by scanned, registrarname
order by domains desc