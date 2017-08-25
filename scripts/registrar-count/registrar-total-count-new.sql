use sadag;

select info.ianaid, info.registrar, count(distinct domainname) as domains 
from simple_whois_linked who, registrar_info_and_name_impala info
where lower(split_part(who.registrarname,"|",1)) = info.code
and info.ianaid is not null
and tld not in ('us','xxx','aero','asia','biz','cat','com','coop','edu','gov','info','int','jobs','mil','mobi','museum', 'name','net','org','post','pro','tel','travel')
group by info.ianaid, info.registrar
order by domains desc;

