-- {"nondigital": [], 
-- "offline": [{"path": "DVD-ROM"}], 
-- "online": [{"status": 302, 
--		"path": "http://pubs.usgs.gov/of/2007/1191/data/composite/bathy/grids/geo/comp2m_geo.zip", 
--		"date_verified": "2015-11-05T00:18:19.617329", "error": ""}, 
--{"status": 302, "path": "http://pubs.usgs.gov/of/2007/1191/data/composite/bathy/grids/geo/", "date_verified": "2015-11-05T00:18:20.534212", "error": ""}, {"status": 302, "path": "http://pubs.usgs.gov/of/2007/1191/html/catalog.html", "date_verified": "2015-11-05T00:18:20.667771", "error": ""}]}

-- number by host
-- with m as (
-- 	select response_id, online
-- 	from metadata_completeness,
-- 		json_array_elements(distributions->'online') online
-- )
-- select r.host, count(m.online) as num_hrefs
-- from responses r join m on m.response_id = r.id
-- group by r.host
-- order by num_hrefs DESC;

-- let's play with averages
-- with m as (
-- 	select response_id, count(online) as num_per_response
-- 	from metadata_completeness,
-- 		json_array_elements(distributions->'online') online
-- 	group by response_id
-- )
-- select r.host, round(avg(m.num_per_response), 2) as avg_hrefs
-- from responses r join m on m.response_id = r.id
-- where r.host is not null
-- group by r.host
-- order by avg_hrefs DESC;

-- -- for status codes
-- with m as (
-- 	select response_id, round((online->>'status')::text::int, -2) as status_code
-- 	from metadata_completeness,
-- 		json_array_elements(distributions->'online') online
-- )
-- select r.host, m.status_code, count(m.status_code) as num_per_status
-- from responses r join m on m.response_id = r.id
-- group by r.host, m.status_code
-- order by r.host, m.status_code ASC;


-- for status codes by metadata age
-- with m as (
-- 	select response_id, round((online->>'status')::text::int, -2) as status_code
-- 	from metadata_completeness,
-- 		json_array_elements(distributions->'online') online
-- ), a as (
-- 	select extract(year from metadata_age) as the_year,
-- 		count(id) as responses_per_year
-- 	from responses
-- 	where metadata_age is not null
-- 	group by the_year
-- )
-- select a.the_year, m.status_code, count(m.status_code) as num_per_status
-- from responses r join m on m.response_id = r.id
-- 	join a on a.the_year = extract(year from r.metadata_age) 
-- where r.metadata_age is not null
-- group by a.the_year, m.status_code
-- order by a.the_year, m.status_code ASC;

-- select r.source_url 
-- from responses r
-- where extract(year from r.metadata_age) = 1964;

-- -- how many have a lineage token for the statement

with m as (
	select response_id, existences->'lineage' as has_lineage
	from metadata_completeness
)

select r.host,
	sum(case when m.has_lineage::text = 'true' then 1 else 0 end) as count_w_lineage,
	sum(case when m.has_lineage::text != 'true' then 1 else 0 end) as count_wo_lineage
from responses r join m on m.response_id = r.id
group by r.host
order by count_w_lineage DESC;