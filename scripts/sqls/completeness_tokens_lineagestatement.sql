-- -- count of how many iso this affects
-- with i as (
-- 	select d.response_id, jsonb_array_elements(d.identity::jsonb) ident
-- 	from identities d
-- 	where d.identity is not null
-- ), m as 
-- (
-- 	select response_id, existences->'lineage' as has_lineage,
-- 		j.* as tokens
-- 	from metadata_completeness, json_array_elements(wordcounts->'lineage') j
-- )
-- 
-- select count(distinct m.response_id) --, m.has_lineage, m.value->'tokens' as num_tokens_in_statement
-- from m join i on i.response_id = m.response_id
-- where i.ident->>'protocol' = 'ISO'
-- 	and m.value::jsonb->>'tag'::text like '%/dataQualityInfo/DQ_DataQuality/lineage/LI_Lineage/statement/CharacterString'
-- ;


-- -- rolling it into (has_lineage or has token for tag) for the raw counts
-- with i as (
-- 	select d.response_id, (e.value->'protocol')::text as ident
-- 	from identities d, jsonb_array_elements(d.identity::jsonb) e
-- 	where d.identity is not null 
-- 		and (e.value->>'protocol' = 'ISO' or e.value->>'protocol' = 'FGDC' )
-- ), x as 
-- (
-- 	with m as
-- 	(
-- 		select response_id, j.value as lineage
-- 		from metadata_completeness, json_array_elements(wordcounts->'lineage') j
-- 		where wordcounts->>'lineage' != '[]'
-- 	)
-- 	select m.response_id, m.lineage->'tokens' as statement_tokens
-- 	from m 
-- 	where (m.lineage->>'tag')::text ilike '%/dataQualityInfo/DQ_DataQuality/lineage/LI_Lineage/statement/CharacterString%'
-- )
-- 
-- select --c.response_id, 
-- -- 	(c.existences->'lineage')::text::boolean as has_lineage,
-- -- 	x.statement_tokens
-- 	case when 
-- 		(c.existences->'lineage')::text::boolean = True 
-- 			or x.statement_tokens is not null 
-- 		then True 
-- 		else False 
-- 	end as the_lineage,
-- 	count(c.response_id),
-- 	i.ident
-- from metadata_completeness c 
-- 	left outer join x on x.response_id = c.response_id
-- 	left outer join i on i.response_id = c.response_id
-- group by i.ident, the_lineage;

with i as (
	select d.response_id, (e.value->'protocol')::text as ident
	from identities d, jsonb_array_elements(d.identity::jsonb) e
	where d.identity is not null 
		and e.value->>'protocol' = 'ISO'
), x as 
(
	with m as
	(
		select response_id, j.value as lineage
		from metadata_completeness, json_array_elements(wordcounts->'lineage') j
		where wordcounts->>'lineage' != '[]'
	)
	select m.response_id, m.lineage->'tokens' as statement_tokens
	from m 
	where (m.lineage->>'tag')::text ilike '%/dataQualityInfo/DQ_DataQuality/lineage/LI_Lineage/statement/CharacterString%'
)

select r.host,
	case 
		when (c.existences->'lineage')::text::boolean = True then 'Processing Steps'
		when x.statement_tokens is not null then 'Statement'
		else 'No Lineage'
	end as lineage_type,
	count(c.response_id)
from metadata_completeness c 
	left outer join x on x.response_id = c.response_id
	join i on i.response_id = c.response_id
	join responses r on r.id = c.response_id
where i.ident = '"ISO"'
group by r.host, lineage_type
order by r.host, lineage_type;
