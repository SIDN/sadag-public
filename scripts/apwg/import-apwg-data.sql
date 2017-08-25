
--
-- Create mapping for apwg domains to whois data
--


CREATE DATABASE IF NOT EXISTS sadag;

use sadag;

set hive.mapred.supports.subdirectories=true;
set mapred.input.dir.recursive=true;

CREATE EXTERNAL TABLE IF NOT EXISTS apwg_data_staging (
domain STRING, blacklistdate STRING, createdate STRING, flag STRING )
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
   "separatorChar" = ","
)  
STORED AS TEXTFILE
LOCATION '/user/hive/sadag/apwg/staging-filtered';

drop table apwg_data

CREATE EXTERNAL TABLE IF NOT EXISTS apwg_data (
domain STRING, blacklistdate TIMESTAMP, createdate TIMESTAMP, flag INT )
STORED AS PARQUET
LOCATION '/user/hive/sadag/apwg/warehouse';


INSERT INTO TABLE apwg_data
SELECT
domain, concat(blacklistdate , " 00:00:00"), concat(createdate , " 00:00:00"), cast( flag as int)
from apwg_data_staging;

