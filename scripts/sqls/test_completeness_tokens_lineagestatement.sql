with i as (
	select d.response_id, jsonb_array_elements(d.identity::jsonb) ident
	from identities d
	where d.identity is not null
), m as 
(
	select response_id, existences->'lineage' as has_lineage,
		j.* as tokens
	from metadata_completeness, json_array_elements(wordcounts->'lineage') j
)

select m.response_id, m.has_lineage::text::boolean as has_lineage, 
	True as has_lineage_statement, 
	'ISO' as protocol
from m join i on i.response_id = m.response_id
where i.ident->>'protocol' = 'ISO' and
	m.value::jsonb->>'tag'::text like '%/dataQualityInfo/DQ_DataQuality/lineage/LI_Lineage/statement/CharacterString'

union all

select w.response_id, (w.existences->'lineage')::text::boolean as has_lineage,
	False as has_lineage_statement,
	'ISO' as protocol
from metadata_completeness w join i on i.response_id = w.response_id
	left outer join m on m.response_id = w.response_id
where i.ident->>'protocol' = 'ISO'
	and w.response_id not in(
		select m.response_id
		from m
	)

union all

select m.response_id, 
	(m.existences->'lineage')::text::boolean as has_lineage,
	False as has_lineage_statement,
	'FGDC' as protocol
from metadata_completeness m join i on i.response_id = m.response_id
where i.ident->>'protocol' = 'FGDC'