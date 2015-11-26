select count(id), trim(both '"' from (headers->'Content-Type')::text) as mimetype
from responses
group by mimetype
order by mimetype;

