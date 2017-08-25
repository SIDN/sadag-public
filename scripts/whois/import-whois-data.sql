--
-- Import the csv formatted whois data into parquet tables.
--create staging table

CREATE DATABASE IF NOT EXISTS sadag;
--create staging table

use sadag;

set hive.mapred.supports.subdirectories=true;
set mapred.input.dir.recursive=true;

CREATE EXTERNAL TABLE IF NOT EXISTS simple_whois_staging (

domainName STRING,registrarName STRING,contactEmail STRING,whoisServer STRING,nameServers STRING,createdDate STRING,updatedDate STRING,expiresDate STRING,standardRegCreatedDate STRING,standardRegUpdatedDate STRING,standardRegExpiresDate STRING,status STRING,Audit_auditUpdatedDate STRING,registrant_email STRING,registrant_name STRING,registrant_organization STRING,registrant_street1 STRING,registrant_street2 STRING,registrant_street3 STRING,registrant_street4 STRING,registrant_city STRING,registrant_state STRING,registrant_postalCode STRING,registrant_country STRING,registrant_fax STRING,registrant_faxExt STRING,registrant_telephone STRING,registrant_telephoneExt STRING,administrativeContact_email STRING,administrativeContact_name STRING,administrativeContact_organization STRING,administrativeContact_street1 STRING,administrativeContact_street2 STRING,administrativeContact_street3 STRING,administrativeContact_street4 STRING,administrativeContact_city STRING,administrativeContact_state STRING,administrativeContact_postalCode STRING,administrativeContact_country STRING,administrativeContact_fax STRING,administrativeContact_faxExt STRING,administrativeContact_telephone STRING,administrativeContact_telephoneExt STRING)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
STORED AS TEXTFILE
LOCATION '/user/hive/sadag/whois/staging'
tblproperties ("skip.header.line.count"="1");

-- create parquet table and 1st conversions with timestamps

set hive.mapred.supports.subdirectories=true;
set mapred.input.dir.recursive=true;

CREATE EXTERNAL TABLE IF NOT EXISTS simple_whois (tld String,
domainName STRING,registrarName STRING,contactEmail STRING,whoisServer STRING,nameServers STRING,createdDate STRING,updatedDate STRING,
expiresDate STRING,standardRegCreatedDate TIMESTAMP,standardRegUpdatedDate TIMESTAMP,standardRegExpiresDate TIMESTAMP,
status STRING,Audit_auditUpdatedDate TIMESTAMP,registrant_email STRING,registrant_name STRING,registrant_organization STRING,registrant_street1 STRING,
registrant_street2 STRING,registrant_street3 STRING,registrant_street4 STRING,registrant_city STRING,registrant_state STRING,registrant_postalCode STRING,
registrant_country STRING,registrant_fax STRING,registrant_faxExt STRING,registrant_telephone STRING,registrant_telephoneExt STRING,
administrativeContact_email STRING,administrativeContact_name STRING,administrativeContact_organization STRING,administrativeContact_street1 STRING,
administrativeContact_street2 STRING,administrativeContact_street3 STRING,administrativeContact_street4 STRING,administrativeContact_city STRING,
administrativeContact_state STRING,administrativeContact_postalCode STRING,administrativeContact_country STRING,administrativeContact_fax STRING,
administrativeContact_faxExt STRING,administrativeContact_telephone STRING,administrativeContact_telephoneExt STRING)
PARTITIONED BY (year int, month int, day int)
STORED AS PARQUET
LOCATION '/user/hive/sadag/whois/warehouse';

-- create table with structured types for registrars and resellers

set hive.mapred.supports.subdirectories=true;
set mapred.input.dir.recursive=true;

CREATE EXTERNAL TABLE IF NOT EXISTS simple_whois_registrar (
tld STRING,domainName STRING,registrarName ARRAY<STRING>,registrarName_prev ARRAY<STRING>,standardRegCreatedDate TIMESTAMP, Audit_auditUpdatedDate TIMESTAMP,
Audit_auditUpdatedDate_Prev TIMESTAMP
)
PARTITIONED BY (year int, month int, day int)
STORED AS PARQUET
LOCATION '/user/hive/sadag/whois/warehouse_registrar';


-- create table with string types for registrars only

set hive.mapred.supports.subdirectories=true;
set mapred.input.dir.recursive=true;

CREATE EXTERNAL TABLE IF NOT EXISTS simple_whois_registrar_only (
tld STRING,domainName STRING,registrarName STRING,registrarName_prev STRING,standardRegCreatedDate TIMESTAMP, Audit_auditUpdatedDate TIMESTAMP,
Audit_auditUpdatedDate_Prev TIMESTAMP
)
PARTITIONED BY (year int, month int, day int)
STORED AS PARQUET
LOCATION '/user/hive/sadag/whois/warehouse_registrar_only';


-- insert data from csv into parquet table
-- this step is done with hive


set hive.exec.dynamic.partition=true;
set hive.exec.dynamic.partition.mode=nonstrict;

INSERT INTO TABLE simple_whois PARTITION(year,month,day)
SELECT reverse(split(reverse(domainName),'\\.')[0]),
domainName,
registrarName,
contactEmail,whoisServer,nameServers,createdDate,updatedDate,expiresDate,
cast(substring(standardRegCreatedDate,0,19) as timestamp),
cast(substring(standardRegUpdatedDate,0,19) as timestamp),
cast(substring(standardRegExpiresDate,0,19) as timestamp),
status,
cast(substring(Audit_auditUpdatedDate,0,19) as timestamp),
registrant_email,registrant_name,registrant_organization,
registrant_street1,registrant_street2,registrant_street3,registrant_street4,registrant_city,registrant_state,registrant_postalCode,registrant_country,
registrant_fax,registrant_faxExt,registrant_telephone,registrant_telephoneExt,administrativeContact_email,administrativeContact_name,
administrativeContact_organization,administrativeContact_street1,administrativeContact_street2,administrativeContact_street3,administrativeContact_street4,
administrativeContact_city,administrativeContact_state,administrativeContact_postalCode,administrativeContact_country,administrativeContact_fax,
administrativeContact_faxExt,administrativeContact_telephone,administrativeContact_telephoneExt,
year(Audit_auditUpdatedDate),
month(Audit_auditUpdatedDate),
day(Audit_auditUpdatedDate)
from simple_whois_staging;


-- create new table where the different domainname versions are linked with their 
-- Audit_auditUpdatedDate 
-- this step is done with impala

create external table simple_whois_linked 
PARTITIONED BY(year,month,day)
STORED AS PARQUET
LOCATION '/user/hive/sadag/whois/warehouse_linked'
AS
SELECT  
tld,domainName,registrarName,standardRegCreatedDate,standardregupdateddate,Audit_auditUpdatedDate,
LAG(Audit_auditUpdatedDate, 1) OVER (partition by domainname ORDER BY Audit_auditUpdatedDate asc) AS Audit_auditUpdatedDate_Prev,
LEAD(Audit_auditUpdatedDate, 1) OVER (partition by domainname ORDER BY Audit_auditUpdatedDate asc) AS Audit_auditUpdatedDate_Next,
LAG(registrarname, 1) OVER (partition by domainname ORDER BY Audit_auditUpdatedDate asc) AS registrarname_prev,
year,
month,
day
from simple_whois;

-- extract registrar/reseller in complex type
-- this step is done with hive

set hive.exec.dynamic.partition=true;
set hive.exec.dynamic.partition.mode=nonstrict;


INSERT INTO TABLE simple_whois_registrar PARTITION(year,month,day)
SELECT
tld,domainName,split(registrarName,"\\|"),split(registrarName_prev,"\\|"),standardRegCreatedDate,Audit_auditUpdatedDate,Audit_auditUpdatedDate_Prev,
year,month,day
from simple_whois_linked;

--create table with registar names as strings, left join with emoty complex types not possible

INSERT INTO TABLE simple_whois_registrar_only PARTITION(year,month,day)
SELECT
tld,domainName,split_part(registrarName,"|",1),split_part(registrarName_prev,"|",1),standardRegCreatedDate,Audit_auditUpdatedDate,Audit_auditUpdatedDate_Prev,
year,month,day
from simple_whois_linked;


-- create linked table with registrant info, used for priv/proxy

create external table simple_whois_linked_registrant
PARTITIONED BY(year,month,day)
STORED AS PARQUET
LOCATION '/user/hive/sadag/whois/warehouse_linked_registrant'
AS
SELECT  
tld,domainName,standardRegCreatedDate,standardregupdateddate,Audit_auditUpdatedDate,
LAG(Audit_auditUpdatedDate, 1) OVER (partition by domainname ORDER BY Audit_auditUpdatedDate asc) AS Audit_auditUpdatedDate_Prev,
LEAD(Audit_auditUpdatedDate, 1) OVER (partition by domainname ORDER BY Audit_auditUpdatedDate asc) AS Audit_auditUpdatedDate_Next,
registrant_name, registrant_organization,
year,
month,
day
from simple_whois;  




