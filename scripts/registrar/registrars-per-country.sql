select country, count(distinct domainname) as domains
from (
select domainname, reg_info.country
from sadag.simple_whois who, sadag.registrar_info_impala reg_info 
where lower(split_part(registrarname,"|",1)) = reg_info.registrar
and tld in ('xxx','aero','asia','biz','cat','com','coop','edu','gov','info','int','jobs','mil','mobi','museum', 'name','net','org','post','pro','tel','travel')
) as matches
group by country
order by domains desc