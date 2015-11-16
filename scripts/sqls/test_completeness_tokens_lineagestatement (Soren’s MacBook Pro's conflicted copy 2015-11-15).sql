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
-- select m.response_id, m.has_lineage::text::boolean as has_lineage, 
-- 	True as has_lineage_statement, 
-- 	'ISO' as protocol
-- from m join i on i.response_id = m.response_id
-- where i.ident->>'protocol' = 'ISO' and
-- 	m.value::jsonb->>'tag'::text like '%/dataQualityInfo/DQ_DataQuality/lineage/LI_Lineage/statement/CharacterString'
-- 
-- union all
-- 
-- select w.response_id, (w.existences->'lineage')::text::boolean as has_lineage,
-- 	False as has_lineage_statement,
-- 	'ISO' as protocol
-- from metadata_completeness w join i on i.response_id = w.response_id
-- 	left outer join m on m.response_id = w.response_id
-- where i.ident->>'protocol' = 'ISO'
-- 	and w.response_id not in(
-- 		select m.response_id
-- 		from m
-- 	)
-- 
-- union all
-- 
-- select m.response_id, 
-- 	(m.existences->'lineage')::text::boolean as has_lineage,
-- 	False as has_lineage_statement,
-- 	'FGDC' as protocol
-- from metadata_completeness m join i on i.response_id = m.response_id
-- where i.ident->>'protocol' = 'FGDC'

-- select response_id, existences->'lineage' as has_lineage, wordcounts
-- from metadata_completeness
-- where ((wordcounts->>'lineage')::jsonb->>'tag')::text like '%/dataQualityInfo/DQ_DataQuality/lineage/LI_Lineage/statement/CharacterString'
-- limit 50;

-- select response_id, existences->'lineage' as has_lineage, wordcounts
-- from metadata_completeness
-- where '"MD_Metadata/dataQualityInfo/DQ_DataQuality/lineage/LI_Lineage/statement/CharacterString"' =
-- 	any(array(select * from jsonb_array_elements((wordcounts->'lineage')::jsonb->'tag'))::text[])
-- ;

with y as 
(
	with x as 
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

	select c.response_id, 
		(c.existences->'lineage')::text::boolean as has_lineage,
		x.statement_tokens
	from metadata_completeness c 
		left outer join x on x.response_id = c.response_id
)
select y.response_id, y.has_lineage, y.statement_tokens,
	case when y.has_lineage = True or y.statement_tokens is not null then True else False end as the_lineage
from y
order by y.response_id;


with i as (
	select d.response_id, (e.value->'protocol')::text as ident
	from identities d, jsonb_array_elements(d.identity::jsonb) e
	where d.identity is not null 
		and (e.value->>'protocol' = 'ISO' or e.value->>'protocol' = 'FGDC' )
), y as 
(
	with x as 
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

	select c.response_id, 
		(c.existences->'lineage')::text::boolean as has_lineage,
		x.statement_tokens
	from metadata_completeness c 
		left outer join x on x.response_id = c.response_id
)
select y.response_id, y.has_lineage, y.statement_tokens,
	case when y.has_lineage = True or y.statement_tokens is not null then True else False end as the_lineage,
	i.ident
from y 
	left outer join i on i.response_id = y.response_id
order by y.response_id;
 