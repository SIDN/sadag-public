use sadag;

select country, count(distinct domainname) as domains 
from simple_whois who, sadag.registrar_info_impala reg_info 
where lower(split_part(who.registrarname,"|",1)) = reg_info.registrar
and tld in ('xxx','aero','asia','biz','cat','com','coop','edu','gov','info','int','jobs','mil','mobi','museum', 'name','net','org','post','pro','tel','travel')
group by country
order by domains DESC;

