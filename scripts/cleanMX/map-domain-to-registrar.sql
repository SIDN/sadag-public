--mapping cleanmx
use sadag;

--mapping cleanmx
use sadag;

-- map table to csv file
create external table sadag.cleanmx_phishing_data (domain string, blacklistdate timestamp)
row format delimited fields terminated by ","
LOCATION '/user/hive/sadag/cleanmx/phishing';

create external table sadag.cleanmx_viruses_data (domain string, blacklistdate timestamp)
row format delimited fields terminated by ","
LOCATION '/user/hive/sadag/cleanmx/viruses';

create external table sadag.cleanmx_portals_data (domain string, blacklistdate timestamp)
row format delimited fields terminated by ","
LOCATION '/user/hive/sadag/cleanmx/portals';

-- get registrar and country for cleanmx phishing

select domainname,lower(split_part(CASE when registrarname_prev is not null then registrarname_prev
                                        else registrarname
                                   END,"|",1
                        )) as registrarname,country,createddate,blacklistdate
from (
    SELECT domainname, registrarname,registrarname_prev, to_date(standardregcreateddate) createddate, to_date(blacklistdate) blacklistdate
    from sadag.cleanmx_phishing_data
    left outer join
        (select tld, domainname,registrarname,registrarname_prev, audit_auditupdateddate_prev, audit_auditupdateddate, audit_auditupdateddate_next,standardregcreateddate
         from simple_whois_linked
         where domainname in (select domain from cleanmx_phishing_data)) whois_rows
    on cleanmx_phishing_data.domain = whois_rows.domainname
    where (blacklistdate > audit_auditupdateddate_prev and  blacklistdate <= audit_auditupdateddate) OR
          (audit_auditupdateddate_prev is null and blacklistdate <= audit_auditupdateddate) OR
          (blacklistdate > audit_auditupdateddate and audit_auditupdateddate_next is null )

) as sub1
left outer join registrar_info_impala on lower(split_part(CASE when registrarname_prev is not null then registrarname_prev
                                        else registrarname
                                   END,"|",1
                        ))  = registrar_info_impala.registrar
order by domainname, country,blacklistdate


-- get registrar and country for cleanmx viruses

select domainname,lower(split_part(CASE when registrarname_prev is not null then registrarname_prev
                                        else registrarname
                                   END,"|",1
                        )) as registrarname,country,createddate,blacklistdate
from (
    SELECT domainname, registrarname,registrarname_prev, to_date(standardregcreateddate) createddate, to_date(blacklistdate) blacklistdate
    from sadag.cleanmx_viruses_data
    left outer join
        (select tld, domainname,registrarname,registrarname_prev,audit_auditupdateddate_prev, audit_auditupdateddate, audit_auditupdateddate_next,standardregcreateddate
         from simple_whois_linked
         where domainname in (select domain from cleanmx_viruses_data)) whois_rows
    on cleanmx_viruses_data.domain = whois_rows.domainname
    where (blacklistdate > audit_auditupdateddate_prev and  blacklistdate <= audit_auditupdateddate) OR
          (audit_auditupdateddate_prev is null and blacklistdate <= audit_auditupdateddate) OR
          (blacklistdate > audit_auditupdateddate and audit_auditupdateddate_next is null )

) as sub1
left outer join registrar_info_impala on lower(split_part(CASE when registrarname_prev is not null then registrarname_prev
                                        else registrarname
                                   END,"|",1
                        )) = registrar_info_impala.registrar
order by domainname, country,blacklistdate

-- get registrar and country for cleanmx portals

select domainname,lower(split_part(CASE when registrarname_prev is not null then registrarname_prev
                                        else registrarname
                                   END,"|",1
                        )) as registrarname,country,createddate,blacklistdate
from (
    SELECT domainname, registrarname,registrarname_prev, to_date(standardregcreateddate) createddate, to_date(blacklistdate) blacklistdate
    from sadag.cleanmx_portals_data
    left outer join
        (select tld, domainname,registrarname,registrarname_prev, audit_auditupdateddate_prev, audit_auditupdateddate, audit_auditupdateddate_next,standardregcreateddate
         from simple_whois_linked
         where domainname in (select domain from cleanmx_portals_data)) whois_rows
    on cleanmx_portals_data.domain = whois_rows.domainname
    where (blacklistdate > audit_auditupdateddate_prev and  blacklistdate <= audit_auditupdateddate) OR
          (audit_auditupdateddate_prev is null and blacklistdate <= audit_auditupdateddate) OR
          (blacklistdate > audit_auditupdateddate and audit_auditupdateddate_next is null )

) as sub1
left outer join registrar_info_impala on lower(split_part(CASE when registrarname_prev is not null then registrarname_prev
                                        else registrarname
                                   END,"|",1
                        )) = registrar_info_impala.registrar
order by domainname, country,blacklistdate





impala-shell -i hadoop-data-01.sidnlabs.nl -f cleanmx-portal-registrar-registrarcountry-createdate-query.sql -o cleanmx-portal-registrar-registrarcountry-createdate.csv -B --output_delimiter=, -k
impala-shell -i hadoop-data-01.sidnlabs.nl -f cleanmx-viruses-registrar-registrarcountry-createdate-query.sql -o cleanmx-viruses-registrar-registrarcountry-createdate.csv -B --output_delimiter=, -k
impala-shell -i hadoop-data-01.sidnlabs.nl -f cleanmx-phishing-registrar-registrarcountry-createdate-query.sql -o cleanmx-phishing-registrar-registrarcountry-createdate.csv -B --output_delimiter=, -k


