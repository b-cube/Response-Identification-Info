-- {"nondigital": [], 
--"offline": [{"path": "DVD-ROM"}], 
--"online": [{"status": 302, "path": "http://pubs.usgs.gov/of/2007/1191/data/composite/bathy/grids/geo/comp2m_geo.zip", "date_verified": "2015-11-05T00:18:19.617329", "error": ""}, {"status": 302, "path": "http://pubs.usgs.gov/of/2007/1191/data/composite/bathy/grids/geo/", "date_verified": "2015-11-05T00:18:20.534212", "error": ""}, {"status": 302, "path": "http://pubs.usgs.gov/of/2007/1191/html/catalog.html", "date_verified": "2015-11-05T00:18:20.667771", "error": ""}]}

-- with m as (
-- 	select response_id, online
-- 	from metadata_completeness,
-- 		json_array_elements(distributions->'online') online
-- )

-- select response_id, json_array_elements(distributions->'nondigital') as oldies
-- from metadata_completeness
-- where json_array_length(distributions->'nondigital') > 0;

with i as (
	select d.response_id, (e.value->'protocol')::text as protocol
	from identities d, jsonb_array_elements(d.identity::jsonb) e
	where d.identity is not null 
		and (e.value->>'protocol' = 'ISO' or e.value->>'protocol' = 'FGDC')
)
select m.response_id, 
	date_trunc('year', r.metadata_age)::date as age,
	trim(both '"' from i.protocol) as protocol,
	json_array_length(m.distributions->'nondigital') as num_nondigital,
	json_array_length(m.distributions->'offline') as num_offline,
	json_array_length(m.distributions->'online') as num_online
from metadata_completeness m
	join responses r on r.id = m.response_id
	join i on i.response_id = m.response_id;



	