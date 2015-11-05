-- -- ALL About FGDC

-- select tags, extracted_info, extracted_type
-- from blended_metadatas
-- where source_standard = 'FGDC';

-- select b.response_id, b.tags, count(b.tags) as num_per_tag
-- from blended_metadatas b
-- where source_standard = 'FGDC'
-- group by b.response_id, b.tags
-- order by b.response_id, num_per_tag DESC;

-- select b.tags, count(b.response_id) as num_per_tag
-- from blended_metadatas b
-- where source_standard = 'FGDC'
-- group by b.tags
-- order by num_per_tag DESC;

-- select distinct r.host, date_trunc('month', r.metadata_age)::date as date_bin
-- from blended_metadatas b join responses r on r.id = b.response_id
-- where source_standard = 'FGDC'
-- order by r.host DESC, date_bin ASC;

-- select r.host, count(r.host), case when r.source_url ilike '%erddap%' then 'ERDDAP' else 'OTHER' end as is_it_dap
-- from blended_metadatas b join responses r on r.id = b.response_id
-- where source_standard = 'FGDC' and tags ilike '%networka%'
-- group by is_it_dap, r.host
-- order by r.host DESC;

-- -- All About ISO

-- 72375 comments total
-- select tags, extracted_info, extracted_type
-- from blended_metadatas
-- where source_standard = 'ISO'
-- 	and extracted_info not ilike 'ORIGIN'
-- ;

--'%FGDC content not mapped to ISO. From Xpath: %'
--'% translated from % to % FGDC content %'
-- 
-- select tags, extracted_info, extracted_type
-- from blended_metadatas
-- where source_standard = 'ISO'
-- 	and extracted_info ilike '%translated from % to %'
-- ;

-- with i as (
-- 	select id, response_id, tags, extracted_info, 'not mapped' as code
-- 	from blended_metadatas
-- 	where source_standard = 'ISO'
-- 		and extracted_info ilike '%FGDC content not mapped to ISO. From Xpath: %'
-- 
-- 	union all
-- 
-- 	select id, response_id, tags, extracted_info, 'translated'::text as code
-- 	from blended_metadatas
-- 	where source_standard = 'ISO'
-- 		and extracted_info ilike '%translated from % to %'
-- )
-- select tags, code, count(code) as num_per_tag
-- from i
-- group by tags, code
-- order by tags, num_per_tag;

--regexp_replace(to_clean, E'[ tnr]+', ' ', 'g')

with i as (
	select id, response_id, tags, regexp_replace(extracted_info, E'[\n\r]+', ' | ', 'g') as the_comment, 'not mapped' as code
	from blended_metadatas
	where source_standard = 'ISO'
		and extracted_info ilike '%FGDC content not mapped to ISO. From Xpath: %'

	union all

	select id, response_id, tags, regexp_replace(extracted_info, E'[\n\r]+', ' | ', 'g') as the_comment, 'translated' as code
	from blended_metadatas
	where source_standard = 'ISO'
		and extracted_info ilike '%translated from % to %'
)
select the_comment, code, count(code) as num_per_tag
from i
group by the_comment, code
order by the_comment, code, num_per_tag;