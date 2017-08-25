
-- get total domains per registrar from whois for all data

SELECT split_part(registrarname,"|",1) registrarName, count(distinct domainname) as domains
FROM simple_whois
group by registrarName
order by domains desc

-- get total legacy domains per registrar from whois for all data

SELECT split_part(registrarname,"|",1) registrarName, count(distinct domainname) as domains
FROM simple_whois
where tld in ('aero','asia','biz','cat','com','coop','edu','gov','info','int','jobs','mil','mobi','museum', 'name','net','org','post','pro','tel','travel')
group by registrarName
order by domains desc


SELECT split_part(registrarname,"|",1) registrarName, tld,count(distinct domainname) as domains
FROM simple_whois
WHERE (year(audit_auditupdateddate) = 2016 and month(audit_auditupdateddate) >= 1 and month(audit_auditupdateddate) < 7 )
group by registrarName,tld
order by registrarname,domains desc


-- get total # of apwg domains per registrar from apwg
select registrarname, count(distinct domainname) as domains
from (

SELECT tld, domainname, CASE when registrarName_prev is not null then split_part(registrarName_prev,"|",1)
                             else split_part(registrarName,"|",1)
                        END as registrarname, to_date(blacklistdate) blacklistdate
from (select domain,blacklistdate
      from apwg_data
      where flag in (1,2)
      and blacklistdate >= 2014-01-01 and blacklistdate <= 01-07-2014
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
group by registrarname
order by domains desc



-- get total legacy domains per registrar from apwg

select registrarname, count(distinct domainname) as domains
from (

SELECT tld, domainname, CASE when registrarName_prev is not null then split_part(registrarName_prev,"|",1)
                             else split_part(registrarName,"|",1)
                        END as registrarname, to_date(blacklistdate) blacklistdate
from (select domain,blacklistdate
      from apwg_data
      where flag in (1,2)
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
group by registrarname
order by domains desc





-- get total # of stopbadware domains per registrar from stopbadware
select registrarname, count(distinct domainname) as domains
from (

SELECT tld, domainname, CASE when registrarName_prev is not null then split_part(registrarName_prev,"|",1)
                             else split_part(registrarName,"|",1)
                        END as registrarname, to_date(blacklistdate) blacklistdate
from (select domain,blacklistdate
      from stopbadware_data
      where flag in (1,2)
      --and blacklistdate >= 2014-01-01 and blacklistdate <= 01-07-2014
      group by  domain,blacklistdate) stopbadware_data
left outer join 
    (select tld, domainname, registrarname_prev, registrarname,audit_auditupdateddate_prev, audit_auditupdateddate, audit_auditupdateddate_next,
    standardregcreateddate, standardregupdateddate
     from simple_whois_linked
     where domainname in (select distinct(domain) from apwg_data)) whois_rows
on stopbadware_data.domain = whois_rows.domainname
where (blacklistdate > audit_auditupdateddate_prev and  blacklistdate <= audit_auditupdateddate) OR
      (audit_auditupdateddate_prev is null and blacklistdate <= audit_auditupdateddate) OR
      (blacklistdate > audit_auditupdateddate and audit_auditupdateddate_next is null )
      
) as sub1
group by registrarname
order by domains desc


-- get total # of stopbadware legacy domains per registrar from stopbadware
select registrarname, count(distinct domainname) as domains
from (

SELECT tld, domainname, CASE when registrarName_prev is not null then split_part(registrarName_prev,"|",1)
                             else split_part(registrarName,"|",1)
                        END as registrarname, to_date(blacklistdate) blacklistdate
from (select domain,blacklistdate
      from stopbadware_data
      where flag in (1,2)
      --and blacklistdate >= 2014-01-01 and blacklistdate <= 01-07-2014
      group by  domain,blacklistdate) stopbadware_data
left outer join 
    (select tld, domainname, registrarname_prev, registrarname,audit_auditupdateddate_prev, audit_auditupdateddate, audit_auditupdateddate_next,
    standardregcreateddate, standardregupdateddate
     from simple_whois_linked
     where domainname in (select distinct(domain) from apwg_data)) whois_rows
on stopbadware_data.domain = whois_rows.domainname
where (blacklistdate > audit_auditupdateddate_prev and  blacklistdate <= audit_auditupdateddate) OR
      (audit_auditupdateddate_prev is null and blacklistdate <= audit_auditupdateddate) OR
      (blacklistdate > audit_auditupdateddate and audit_auditupdateddate_next is null )
      
) as sub1
where tld in ('aero','asia','biz','cat','com','coop','edu','gov','info','int','jobs','mil','mobi','museum', 'name','net','org','post','pro','tel','travel')
group by registrarname
order by domains desc






-- How many domains are mapped to how many registrars on average? 
select avg(linkedRegistrars) as avg_linkedRegistrars
from(
   select domainname, count(distinct split_part(registrarname,"|",1)) as linkedRegistrars
   from simple_whois 
   where length(registrarname) > 0
   group by domainname) as sub1



