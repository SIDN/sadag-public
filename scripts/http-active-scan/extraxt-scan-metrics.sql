-- total new gtlds domains scanned
select count(1)
from crawl_result_http
where crawl_run in (30,31,32,33,34,35)

--newgtld domains scanned per tld
copy (
select reverse(split_part(reverse(domainname),'.',1)) as tld, count(1) as domains
from crawl_result_http
where crawl_run in (30,31,32,33,34,35)
group by tld
order by domains desc
)TO '/home/crawldbprod/dump/new-gtld-tld-count.csv' WITH (FORMAT CSV, HEADER)

--legacy domains scanned per tld
copy (
select reverse(split_part(reverse(domainname),'.',1)) as tld, count(1) as domains
from crawl_result_http
where crawl_run in (36,37,38,39)
group by tld
order by domains desc
)TO '/home/crawldbprod/dump/legacy-gtld-tld-count.csv' WITH (FORMAT CSV, HEADER)

--newgtld scan status per tld
copy (
select reverse(split_part(reverse(domainname),'.',1)) as tld, crawl_status, count(1) as domains
from crawl_result_http
where crawl_run in (30,31,32,33,34,35)
group by tld,crawl_status
order by tld,domains desc
)TO '/home/crawldbprod/dump/new-gtld-tld-status-count.csv' WITH (FORMAT CSV, HEADER)

--legacy scan status per tld
copy (
select reverse(split_part(reverse(domainname),'.',1)) as tld, crawl_status, count(1) as domains
from crawl_result_http
where crawl_run in (36,37,38,39)
group by tld,crawl_status
order by tld,domains desc
)TO '/home/crawldbprod/dump/legacy-gtld-tld-status-count.csv' WITH (FORMAT CSV, HEADER)

--newgtld parked per tld
copy (
select reverse(split_part(reverse(domainname),'.',1)) as tld, count(1) as domains
from crawl_result_http
where crawl_run in (30,31,32,33,34,35)
and page_type = 'Parking'
group by tld
order by tld,domains desc
)TO '/home/crawldbprod/dump/new-gtld-tld-parking-count.csv' WITH (FORMAT CSV, HEADER)

--legacy parked per tld
copy (
select reverse(split_part(reverse(domainname),'.',1)) as tld, count(1) as domains
from crawl_result_http
where crawl_run in (36,37,38,39)
and page_type = 'Parking'
group by tld
order by tld,domains desc
)TO '/home/crawldbprod/dump/legacy-gtld-tld-parking-count.csv' WITH (FORMAT CSV, HEADER)

--newgtld redirect to other domain
copy (
select reverse(split_part(reverse(domainname),'.',1)) as tld, domainname, crawl_url,http_redirect_count
from crawl_result_http
where crawl_run in (30,31,32,33,34,35) and http_redirect_count > 0
)TO '/home/crawldbprod/dump/new-gtld-tld-redirect-count.csv' WITH (FORMAT CSV, HEADER)


--legacy redirect to other domain
copy (
select reverse(split_part(reverse(domainname),'.',1)) as tld, domainname, crawl_url,http_redirect_count
from crawl_result_http
where crawl_run in (36,37,38,39) and http_redirect_count > 0
)TO '/home/crawldbprod/dump/legacy-gtld-tld-redirect-count.csv' WITH (FORMAT CSV, HEADER)

