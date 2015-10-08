select codelist, codelist_value, count(codelist_value)
from rolecodes
group by codelist, codelist_value
order by codelist, codelist_value;