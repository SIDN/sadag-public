--mapping surbl
use sadag;

-- map table to csv file
create external table sadag.surbl_data (domain string, blacklistdate timestamp)
row format delimited fields terminated by ","
LOCATION '/user/hive/sadag/surbl';

-- get registrar and country for surbl


select domainname,lower(split_part(CASE when registrarname_prev is not null then registrarname_prev
                                        else registrarname
                                   END,"|",1
                        )) as registrarname,country,createddate,blacklistdate
from (
    SELECT domainname, registrarname,registrarname_prev, to_date(standardregcreateddate) createddate, to_date(blacklistdate) blacklistdate
    from sadag.surbl_data
    left outer join
        (select tld, domainname,registrarname,registrarname_prev,audit_auditupdateddate_prev, audit_auditupdateddate, audit_auditupdateddate_next,standardregcreateddate
         from simple_whois_linked
         where domainname in (select domain from surbl_data)) whois_rows
    on surbl_data.domain = whois_rows.domainname
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
from surbl_data
where domain not in (select distinct(domainname) from simple_whois_linked );



impala-shell -i hadoop-data-01.sidnlabs.nl -f surbl-registrar-registrarcountry-createdate-query.sql -o surbl-registrar-registrarcountry-createdate.csv -B --output_delimiter=, -k

