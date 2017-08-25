--mapping apwg
use sadag;

-- get registrar and country for apwg


select domainname,lower(split_part(CASE when registrarname_prev is not null then registrarname_prev
                                        else registrarname
                                   END,"|",1
                        )) as registrarname,country,createddate,blacklistdate
from (
    SELECT domainname, registrarname,registrarname_prev, to_date(standardregcreateddate) createddate, to_date(blacklistdate) blacklistdate
    from sadag.apwg_data
    left outer join
        (select tld, domainname,registrarname,registrarname_prev,audit_auditupdateddate_prev, audit_auditupdateddate, audit_auditupdateddate_next,standardregcreateddate
         from simple_whois_linked
         where domainname in (select domain from apwg_data)) whois_rows
    on apwg_data.domain = whois_rows.domainname
    where (blacklistdate > audit_auditupdateddate_prev and  blacklistdate <= audit_auditupdateddate) OR
          (audit_auditupdateddate_prev is null and blacklistdate <= audit_auditupdateddate) OR
          (blacklistdate > audit_auditupdateddate and audit_auditupdateddate_next is null )

) as sub1
left outer join registrar_info_impala on lower(split_part(CASE when registrarname_prev is not null then registrarname_prev
                             else registrarname
                        END,"|",1)) = registrar_info_impala.registrar
order by domainname, country,blacklistdate




-- domains not found in whois
use sadag;

select domain,blacklistdate
from apwg_data
where domain not in (select distinct(domainname) from simple_whois_linked );



impala-shell -i hadoop-data-01.sidnlabs.nl -f surbl-registrar-registrarcountry-createdate-query.sql -o surbl-registrar-registrarcountry-createdate.csv -B --output_delimiter=, -k












--old


--find correct time-window for each apwg reported domainname
-- create parquet temp table with impala

create external TABLE apwg_whois_mapping_10_12_2016
STORED AS PARQUET
LOCATION '/user/hive/icann/results/apwg-whois-mapping/10-12-2016'
AS
SELECT  
domainname, split_part(registrarName_prev,"|",1) registrarName_prev, split_part(registrarName,"|",1) registrarName,
to_date(phish_date), to_date(audit_auditupdateddate_prev), to_date(audit_auditupdateddate), to_date(audit_auditupdateddate_next),
fqdn,path, to_date(standardregcreateddate), to_date(standardregupdateddate)
from (select domain,fqdn,path,phish_date
      from apwg_data
      where year(phish_date) = 2016 and month(phish_date) >= 10 and month(phish_date) <= 12 
      group by  domain,fqdn,path,phish_date) apwg_data
left outer join 
    (select domainname, registrarname_prev, registrarname,audit_auditupdateddate_prev, audit_auditupdateddate, audit_auditupdateddate_next,
    standardregcreateddate, standardregupdateddate
     from simple_whois_linked
     where domainname in (select distinct(domain) from apwg_data)) whois_rows
on apwg_data.domain = whois_rows.domainname
where (phish_date > audit_auditupdateddate_prev and  phish_date <= audit_auditupdateddate) OR
      (audit_auditupdateddate_prev is null and phish_date <= audit_auditupdateddate) OR
      (phish_date > audit_auditupdateddate and audit_auditupdateddate_next is null )
      


-- export with hive
INSERT OVERWRITE LOCAL DIRECTORY '/staging2/icann/results/csv' ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' SELECT * FROM apwg_whois_mapping_04_06_2016



