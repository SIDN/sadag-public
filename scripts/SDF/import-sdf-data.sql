
-- spamhaus

use sadag;

set hive.mapred.supports.subdirectories=true;
set mapred.input.dir.recursive=true;


CREATE EXTERNAL TABLE IF NOT EXISTS sdf_staging (
domain STRING, blacklistdate STRING )
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
   "separatorChar" = ","
)  
STORED AS TEXTFILE
LOCATION '/user/hive/sadag/sdf/staging';


CREATE EXTERNAL TABLE IF NOT EXISTS sdf_data (
domain STRING, blacklistdate TIMESTAMP)
STORED AS PARQUET
LOCATION '/user/hive/sadag/sdf/warehouse';


INSERT INTO TABLE sdf_data
SELECT
domain, concat(blacklistdate, " 00:00:00"), url
from sdf_staging
