select country, count(1) as registrars
from registrar_info_impala 
where ianaid is not null
group by country
order by registrars desc
