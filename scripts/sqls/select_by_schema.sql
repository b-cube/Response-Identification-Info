select r.source_url, d
from responses r, lateral unnest(schemas) d
-- limit 100;
where d ilike '%.DTD';