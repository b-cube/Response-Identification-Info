-- select count(id)
-- from osdds
-- where url_templates is not null and url_templates::text != '[]'::text;

-- select url, namespaces
-- from osdds
-- where namespaces::jsonb ?| array['time', 'geo'];
-- 	--and namespaces->>'default' != 'http://www.w3.org/XML/1998/namespace';

-- with ns as(
--    select url, json_each_text(namespaces) as kvps
--    from osdds
-- )
-- 
-- select kvps, count(kvps)
-- from ns
-- group by kvps;



select count(distinct o.id)
from osdds o
where namespaces::jsonb->>


--kvps.value = 'http://a9.com/-/opensearch/extensions/geo/1.0/' or kvps.value = 'http://a9.com/-/opensearch/extensions/time/1.0/';
