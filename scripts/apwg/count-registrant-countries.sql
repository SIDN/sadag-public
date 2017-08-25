
-- registrant_country contains fullname of country OR ISO country code.

-- get total # of apwg domains per registrar from apwg
select registrant_country, count(distinct domainname) as domains
from (

SELECT tld, domainname, CASE when registrant_country_prev is not null then registrant_country_prev
                             else registrant_country
                        END as registrant_country, to_date(blacklistdate) blacklistdate
from (select domain,blacklistdate
      from apwg_data
      where flag in (1,2)
      --and blacklistdate >= 2014-01-01 and blacklistdate <= 01-07-2014
      group by  domain,blacklistdate) apwg_data
left outer join 
    (select tld, domainname, registrant_country_prev, registrant_country,audit_auditupdateddate_prev, audit_auditupdateddate, audit_auditupdateddate_next
     from simple_whois_linked_country
     where domainname in (select distinct(domain) from apwg_data)) whois_rows
on apwg_data.domain = whois_rows.domainname
where (blacklistdate > audit_auditupdateddate_prev and  blacklistdate <= audit_auditupdateddate) OR
      (audit_auditupdateddate_prev is null and blacklistdate <= audit_auditupdateddate) OR
      (blacklistdate > audit_auditupdateddate and audit_auditupdateddate_next is null )
      
) as sub1
where tld not in ('aero','asia','biz','cat','com','coop','edu','gov','info','int','jobs','mil','mobi','museum', 'name','net','org','post','pro','tel','travel')
group by registrant_country
order by domains desc 




-- get total legacy domains per registrar from apwg
select registrant_country, count(distinct domainname) as domains
from (

SELECT tld, domainname, CASE when registrant_country_prev is not null then registrant_country_prev
                             else registrant_country
                        END as registrant_country, to_date(blacklistdate) blacklistdate
from (select domain,blacklistdate
      from apwg_data
      where flag in (1,2)
      --and blacklistdate >= 2014-01-01 and blacklistdate <= 01-07-2014
      group by  domain,blacklistdate) apwg_data
left outer join 
    (select tld, domainname, registrant_country_prev, registrant_country,audit_auditupdateddate_prev, audit_auditupdateddate, audit_auditupdateddate_next
     from simple_whois_linked_country
     where domainname in (select distinct(domain) from apwg_data)) whois_rows
on apwg_data.domain = whois_rows.domainname
where (blacklistdate > audit_auditupdateddate_prev and  blacklistdate <= audit_auditupdateddate) OR
      (audit_auditupdateddate_prev is null and blacklistdate <= audit_auditupdateddate) OR
      (blacklistdate > audit_auditupdateddate and audit_auditupdateddate_next is null )
      
) as sub1
where tld in ('aero','asia','biz','cat','com','coop','edu','gov','info','int','jobs','mil','mobi','museum', 'name','net','org','post','pro','tel','travel')
group by registrant_country
order by domains desc 



create external table simple_whois_registrant_country 
PARTITIONED BY(year,month,day)
STORED AS PARQUET
LOCATION '/user/hive/sadag/whois/warehouse_linked_registrant_country'
AS
SELECT  
tld,domainName,registrant_country,Audit_auditUpdatedDate,
LAG(Audit_auditUpdatedDate, 1) OVER (partition by domainname ORDER BY Audit_auditUpdatedDate asc) AS Audit_auditUpdatedDate_Prev,
LEAD(Audit_auditUpdatedDate, 1) OVER (partition by domainname ORDER BY Audit_auditUpdatedDate asc) AS Audit_auditUpdatedDate_Next,
LAG(registrant_country, 1) OVER (partition by domainname ORDER BY Audit_auditUpdatedDate asc) AS registrant_country_prev,
year,
month,
day
from simple_whois;

select count(1)
from simple_whois_linked_country






select count(1)
from (

SELECT tld, domainname, CASE when registrant_country_prev is not null then registrant_country_prev
                             else registrant_country
                        END as registrant_country, to_date(blacklistdate) blacklistdate
from (select domain,blacklistdate
      from apwg_data
      where flag in (1,2)
      --and blacklistdate >= 2014-01-01 and blacklistdate <= 01-07-2014
      group by  domain,blacklistdate) apwg_data
left outer join 
    (select tld, domainname, registrant_country_prev, registrant_country,audit_auditupdateddate_prev, audit_auditupdateddate, audit_auditupdateddate_next
     from simple_whois_linked_country
     where domainname in (select distinct(domain) from apwg_data)) whois_rows
on apwg_data.domain = whois_rows.domainname
where (blacklistdate > audit_auditupdateddate_prev and  blacklistdate <= audit_auditupdateddate) OR
      (audit_auditupdateddate_prev is null and blacklistdate <= audit_auditupdateddate) OR
      (blacklistdate > audit_auditupdateddate and audit_auditupdateddate_next is null )
      
) as sub1 
where registrant_country is null

select count(1)
from apwg_data


found countries  : 247 443
all   countries  : 271 230
missing countries: 23 787 ~ 8,77%