select xpath, codelist_value, count(codelist_value)
from rolecodes
group by xpath, codelist_value
order by xpath, codelist_value;