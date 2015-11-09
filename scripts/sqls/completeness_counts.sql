-- select *
-- from metadata_completeness
-- limit 2;

-- with a 
-- as (
-- 	select response_id, j.*
-- 	from metadata_completeness, 
-- 		jsonb_to_recordset(wordcounts::jsonb)
-- 		as j(
-- 			lineage jsonb,
-- 			data_quality jsonb,
-- 			attributes jsonb
-- 		)
-- )
-- 
-- select 


--{"lineage": false, "attribute": false, "data_quality": true, "metadata": false}
-- with m as (
-- 	select response_id, existences->'lineage' as has_lineage,
-- 		existences->'attribute' as has_attribute,
-- 		existences->'data_quality' as has_quality,
-- 		existences->'metadata' as has_metadata
-- 	from metadata_completeness
-- )
-- 
-- select r.host,
-- 	sum(case when m.has_lineage::text = 'true' then 1 else 0 end) as count_w_lineage,
-- 	sum(case when m.has_lineage::text != 'true' then 1 else 0 end) as count_wo_lineage
-- 	
-- from responses r join m on m.response_id = r.id
-- group by r.host
-- order by r.host;


-- let's run with iso vs fgdc
with m as (
	select response_id, existences->'lineage' as has_lineage,
		existences->'attribute' as has_attribute,
		existences->'data_quality' as has_quality,
		existences->'metadata' as has_metadata
	from metadata_completeness
), i as (
	select d.response_id, jsonb_array_elements(d.identity::jsonb) ident
	from identities d
	where d.identity is not null
), a as (
	select extract(year from metadata_age) as the_year,
		count(id) as responses_per_year
	from responses
	where metadata_age is not null
	group by the_year
)

select r.host, i.ident->'protocol' as protocol, date_trunc('year', r.metadata_age)::date as published,
	sum(case when m.has_lineage::text = 'true' then 1 else 0 end) as count_w_lineage,
	sum(case when m.has_lineage::text != 'true' then 1 else 0 end) as count_wo_lineage,
	round((sum(case when m.has_lineage::text = 'true' then 1. else 0. end) / min(a.responses_per_year)::numeric) * 100.0, 2) as pct_of_total,
	min(a.responses_per_year) as total_responses_per_year
from responses r join m on m.response_id = r.id
	join i on i.response_id = r.id
	join a on a.the_year = extract(year from r.metadata_age)
where extract(year from r.metadata_age) > 1990 and extract(year from r.metadata_age) < 2016
group by r.host, protocol, published
order by r.host, date_trunc('year', r.metadata_age)::date ASC, protocol;