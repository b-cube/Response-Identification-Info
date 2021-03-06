﻿-- "{"lineage": 
--	[{"tokens": 18, 
--	"text": "Remote Sensing Systems Inc, JAXA, NASA, OSDPD, CoastWatch 2013-12-01T19:15:23Z NOAA CoastWatch (West Coast Node) and NOAA SFSC ERD", 
--	"tag": "MI_Metadata/dataQualityInfo/DQ_DataQuality/lineage/LI_Lineage/statement/CharacterString"}], 
--  "attributes": [], "data_quality": []}"

-- with lineage_tokens as
-- (
-- 	select response_id, lineage
-- 	from metadata_completeness, json_array_elements(wordcounts->'lineage') as lineage
-- 	where (wordcounts->'lineage')::text != '[]'
-- ), quality_tokens as
-- (
-- 	select response_id, data_quality
-- 	from metadata_completeness, json_array_elements(wordcounts->'data_quality') as data_quality
-- 	where (wordcounts->'data_quality')::text != '[]'
-- ), i as (
-- 	select d.response_id, (e.value->'protocol')::text as ident
--    	from identities d, jsonb_array_elements(d.identity::jsonb) e
-- 	where d.identity is not null 
-- 		and (e.value->>'protocol' = 'ISO' or e.value->>'protocol' = 'FGDC')
-- )
-- select r.id, date_trunc('month', r.metadata_age)::date as age,
-- 	min(i.ident),
-- 	sum((x.lineage->'tokens')::text::int) as num_lineage_tokens,
-- 	count(x.lineage->'tokens') as num_lineage_elements,
-- 	sum((y.data_quality->'tokens')::text::int) as num_quality_tokens,
-- 	count(y.data_quality->'tokens') as num_quality_elements
-- from responses r join i on i.response_id = r.id
-- 	left outer join lineage_tokens x on x.response_id = r.id
-- 	left outer join quality_tokens y on y.response_id = r.id
-- where i.ident = '"ISO"' or i.ident = '"FGDC"'
-- group by r.id;

-- select response_id, data_quality
-- from metadata_completeness, 
-- 	json_array_elements(wordcounts->'data_quality') as data_quality
-- limit 50;


	-- with quality_tokens as
-- 	(
-- 		select response_id, data_quality
-- 		from metadata_completeness, json_array_elements(wordcounts->'data_quality') as data_quality
-- 		where (wordcounts->'data_quality')::text != '[]'
-- 	), i as (
-- 		select d.response_id, (e.value->'protocol')::text as ident
-- 		from identities d, jsonb_array_elements(d.identity::jsonb) e
-- 		where d.identity is not null 
-- 			and e.value->>'protocol' = 'ISO'
-- 	)
-- 	select r.id, date_trunc('month', r.metadata_age)::date as age,
-- 		min(i.ident) as protocol,
-- 		sum((y.data_quality->'tokens')::text::int) as num_quality_tokens,
-- 		count(y.data_quality->'tokens') as num_quality_elements
-- 	from responses r join i on i.response_id = r.id
-- 		left outer join quality_tokens y on y.response_id = r.id
-- 	where i.ident = '"ISO"'
-- 	group by r.id
-- 	order by num_quality_elements DESC;

-- with lineage_tokens as
-- (
-- 	select response_id, lineage
-- 	from metadata_completeness, json_array_elements(wordcounts->'lineage') as lineage
-- 	where (wordcounts->'lineage')::text != '[]'
-- ), i as (
-- 	select d.response_id, (e.value->'protocol')::text as ident
-- 	from identities d, jsonb_array_elements(d.identity::jsonb) e
-- 	where d.identity is not null 
-- 		and e.value->>'protocol' = 'ISO'
-- )
-- select r.id, r.host, date_trunc('month', r.metadata_age)::date as age,
-- 	min(i.ident) as protocol,
-- 	sum((y.lineage->'tokens')::text::int) as num_lineage_tokens,
-- 	count(y.lineage->'tokens') as num_lineage_elements
-- from responses r join i on i.response_id = r.id
-- 	left outer join lineage_tokens y on y.response_id = r.id
-- where i.ident = '"ISO"'
-- group by r.id, age
-- order by num_lineage_elements DESC;

--19689

with j as 
(
	with quality_tokens as
	(
		select response_id, data_quality
		from metadata_completeness, json_array_elements(wordcounts->'data_quality') as data_quality
		where (wordcounts->'data_quality')::text != '[]'
	), i as (
		select d.response_id, (e.value->'protocol')::text as ident
		from identities d, jsonb_array_elements(d.identity::jsonb) e
		where d.identity is not null 
			and e.value->>'protocol' = 'FGDC'
	)
	-- select r.id, date_trunc('month', r.metadata_age)::date as age,
	-- 	min(i.ident) as protocol,
	-- 	sum((y.data_quality->'tokens')::text::int) as num_quality_tokens,
	-- 	count(y.data_quality->'tokens') as num_quality_elements
	select r.id, count(y.data_quality->'tokens') as num_quality_elements
	from responses r join i on i.response_id = r.id
		left outer join quality_tokens y on y.response_id = r.id
	where i.ident = '"FGDC"'
	group by r.id
)
select j.num_quality_elements, count(j.id)
from j
group by j.num_quality_elements
order by j.num_quality_elements ASC;
