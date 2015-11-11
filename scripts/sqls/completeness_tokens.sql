-- "{"lineage": 
--	[{"tokens": 18, 
--	"text": "Remote Sensing Systems Inc, JAXA, NASA, OSDPD, CoastWatch 2013-12-01T19:15:23Z NOAA CoastWatch (West Coast Node) and NOAA SFSC ERD", 
--	"tag": "MI_Metadata/dataQualityInfo/DQ_DataQuality/lineage/LI_Lineage/statement/CharacterString"}], 
--  "attributes": [], "data_quality": []}"

with lineage_tokens as
(
	select response_id, lineage
	from metadata_completeness, json_array_elements(wordcounts->'lineage') as lineage
	where (wordcounts->'lineage')::text != '[]'
), quality_tokens as
(
	select response_id, data_quality
	from metadata_completeness, json_array_elements(wordcounts->'data_quality') as data_quality
	where (wordcounts->'data_quality')::text != '[]'
), i as (
	select d.response_id, jsonb_array_elements(d.identity::jsonb) ident
	from identities d
	where d.identity is not null
)
select r.id, date_trunc('month', r.metadata_age)::date as age,
	--i.ident->>'protocol' as protocol,
	sum((x.lineage->'tokens')::text::int) as num_lineage_tokens,
	count(x.lineage->'tokens') as num_lineage_elements,
	sum((y.data_quality->'tokens')::text::int) as num_quality_tokens,
	count(y.data_quality->'tokens') as num_quality_elements
from responses r join i on i.response_id = r.id
	left outer join lineage_tokens x on x.response_id = r.id
	left outer join quality_tokens y on y.response_id = r.id
where (i.ident->>'protocol' = 'ISO' or i.ident->>'protocol' = 'FGDC')
group by r.id;

-- select response_id, data_quality
-- from metadata_completeness, 
-- 	json_array_elements(wordcounts->'data_quality') as data_quality
-- limit 50;
