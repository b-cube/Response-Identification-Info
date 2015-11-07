-- -- unique comment lines counted
-- with j as (
-- 	with i as (
-- 		select id, response_id, tags, regexp_replace(extracted_info, E'[\n\r]+', ' | ', 'g') as the_comment, 'not mapped' as code
-- 		from blended_metadatas
-- 		where source_standard = 'ISO'
-- 			and extracted_info ilike '%FGDC content not mapped to ISO. From Xpath: %'
-- 
-- 		union all
-- 
-- 		select id, response_id, tags, regexp_replace(extracted_info, E'[\n\r]+', ' | ', 'g') as the_comment, 'translated' as code
-- 		from blended_metadatas
-- 		where source_standard = 'ISO'
-- 			and extracted_info ilike '%translated from % to %'
-- 	)
-- 	-- select id, response_id, trim(leading ' ' from unnest(string_to_array(the_comment, '|')))
-- 	select trim(leading ' ' from unnest(string_to_array(the_comment, '|'))) as a_comment
-- 	from i
-- 	
-- )
-- 
-- select a_comment, count(a_comment) as count
-- from j
-- where a_comment != '' and a_comment not like '%ORIGIN%' and left(a_comment, 1) != '<' and left(a_comment, 1) != '2'
-- group by a_comment
-- order by count desc;


-- -- counts - how many responses per unique comment
-- with j as (
-- 	with i as (
-- 		select id, response_id, tags, regexp_replace(extracted_info, E'[\n\r]+', ' | ', 'g') as the_comment
-- 		from blended_metadatas
-- 		where source_standard = 'ISO'
-- 			and (extracted_info ilike '%FGDC content not mapped to ISO. From Xpath: %' or extracted_info ilike '%translated from % to %')
-- 	)
-- 	select id, response_id, trim(leading ' ' from unnest(string_to_array(the_comment, '|'))) as a_comment
-- 	from i
-- 	
-- )
-- 
-- select a_comment, count(distinct response_id) as found_in_responses
-- from j
-- where a_comment != '' and a_comment not like '%ORIGIN%' and left(a_comment, 1) != '<' and left(a_comment, 1) != '2'
-- group by a_comment
-- order by found_in_responses desc;

-- count per host
with i as (
	select id, response_id, tags, 
		trim(leading ' ' from unnest(string_to_array(regexp_replace(extracted_info, E'[\n\r]+', ' | ', 'g'), '|'))) as the_comment
	from blended_metadatas
	where source_standard = 'ISO'
		and (extracted_info ilike '%FGDC content not mapped to ISO. From Xpath: %' or extracted_info ilike '%translated from % to %')
)
select r.host, count(r.host) as host_count, the_comment
from i join responses r on r.id = i.response_id
where the_comment != '' and the_comment not like '%ORIGIN%' and left(the_comment, 1) != '<' and left(the_comment, 1) != '2'
group by the_comment, r.host
order by r.host, host_count desc, the_comment;