
-- spamhaus

use sadag;

set hive.mapred.supports.subdirectories=true;
set mapred.input.dir.recursive=true;


CREATE EXTERNAL TABLE IF NOT EXISTS spamhaus_staging (
domain STRING, blacklistdate STRING )
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
   "separatorChar" = ","
)  
STORED AS TEXTFILE
LOCATION '/user/hive/sadag/spamhaus/staging';


CREATE EXTERNAL TABLE IF NOT EXISTS spamhaus_data (
domain STRING, blacklistdate TIMESTAMP )
STORED AS PARQUET
LOCATION '/user/hive/sadag/spamhaus/warehouse';


INSERT INTO TABLE spamhaus_data
SELECT
domain, concat(blacklistdate , " 00:00:00"), concat(createdate , " 00:00:00"), cast( flag as int)
from spamhaus_staging;
