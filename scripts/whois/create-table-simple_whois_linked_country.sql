-- create linked table with countries
create external table  simple_whois_linked_country 
PARTITIONED BY(year,month,day)
STORED AS PARQUET
LOCATION '/user/hive/sadag/whois/warehouse_linked_country'
AS
SELECT  
tld,domainName,
LAG(Audit_auditUpdatedDate, 1) OVER (partition by domainname ORDER BY Audit_auditUpdatedDate asc) AS Audit_auditUpdatedDate_Prev,
Audit_auditUpdatedDate,
LEAD(Audit_auditUpdatedDate, 1) OVER (partition by domainname ORDER BY Audit_auditUpdatedDate asc) AS Audit_auditUpdatedDate_Next,
LAG(registrant_country, 1) OVER (partition by domainname ORDER BY Audit_auditUpdatedDate asc) AS registrant_country_prev,
registrant_country,
year,
month,
day
from simple_whois;