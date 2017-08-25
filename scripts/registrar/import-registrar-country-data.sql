
-- map registrar countries table

create external table sadag.registrar_info (registrar string, country string)
row format delimited fields terminated by ","
LOCATION '/user/hive/sadag/icann-registrars/';

refresh registrar_info;

-- get all registrars and their address if found as basis for registrar/country list
select all_registrars.registrar, country
from
(select split_part(registrarname,"|",1) as registrar
from simple_whois_linked
group by registrar) as all_registrars
left join registrar_info on lower(registrar_info.registrar)  = lower(regexp_replace(all_registrars.registrar, ',', '_'))
order by all_registrars.registrar asc

-- import the final registar / country mapping data

create external table sadag.registrar_info_impala (registrar string, country string, ianaid int, accredited boolean)
row format delimited fields terminated by ","
STORED AS PARQUET
LOCATION '/user/hive/sadag/registrar-info-impala';

-- Hive part
-- create staging table with hive to load csv data, impala fails on quotes.

CREATE EXTERNAL TABLE IF NOT EXISTS sadag.registrar_info_staging (registrar string, country string, ianaid int, accredited boolean)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
STORED AS TEXTFILE
LOCATION '/user/hive/sadag/registrar-info-staging'

--insert into impala table

INSERT INTO TABLE registrar_info_impala
select lower(registrar),country, ianaid, accredited from sadag.registrar_info_staging

-- end of hive part