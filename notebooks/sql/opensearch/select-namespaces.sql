-- get the osdd namespace uris
select kvps.value, count(kvps.value)
from osdds,
    json_each_text(namespaces) as kvps
group by kvps.value
order by count desc, kvps.value