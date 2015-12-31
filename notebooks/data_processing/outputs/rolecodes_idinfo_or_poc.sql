select codelist_value, count(codelist_value)
from rolecodes
where xpath ilike '%identificationInfo%' or xpath ilike '%/contact'
group by codelist_value
order by codelist_value;