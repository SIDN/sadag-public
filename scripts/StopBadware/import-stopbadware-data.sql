
-- stopbadware

use sadag;

set hive.mapred.supports.subdirectories=true;
set mapred.input.dir.recursive=true;


CREATE EXTERNAL TABLE IF NOT EXISTS stopbadware_staging (
domain STRING, blacklistdate STRING, createdate STRING, flag STRING )
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
   "separatorChar" = ","
)  
STORED AS TEXTFILE
LOCATION '/user/hive/sadag/stopbadware/staging';


CREATE EXTERNAL TABLE IF NOT EXISTS stopbadware_data (
domain STRING, blacklistdate TIMESTAMP, createdate TIMESTAMP, flag INT )
STORED AS PARQUET
LOCATION '/user/hive/sadag/stopbadware/warehouse';


INSERT INTO TABLE stopbadware_data
SELECT
domain, concat(blacklistdate , " 00:00:00"), concat(createdate , " 00:00:00"), cast( flag as int)
from stopbadware_staging;
