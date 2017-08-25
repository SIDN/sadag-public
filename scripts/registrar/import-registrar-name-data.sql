
create external table sadag.registrar_name_impala (registrar string, ianaid int)
row format delimited fields terminated by ","
STORED AS PARQUET
LOCATION '/user/hive/sadag/registrar-name-impala';

-- Hive part
-- create staging table with hive to load csv data, impala fails on quotes.

CREATE EXTERNAL TABLE IF NOT EXISTS sadag.registrar_name_staging (registrar string,ianaid int)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
STORED AS TEXTFILE
LOCATION '/user/hive/sadag/registrar-name-staging'

--insert into impala table

INSERT INTO TABLE registrar_name_impala
select registrar,ianaid from sadag.registrar_name_staging

-- end of hive part

CREATE TABLE registrar_info_and_name_impala
  STORED AS PARQUET
AS
select info.registrar as code, name.registrar as registrar, country, name.ianaid
from registrar_info_impala info, registrar_name_impala name
where info.ianaid = name.ianaid