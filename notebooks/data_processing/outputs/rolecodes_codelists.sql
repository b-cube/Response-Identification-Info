select codelist, count(codelist)
from rolecodes
group by codelist
order by codelist;