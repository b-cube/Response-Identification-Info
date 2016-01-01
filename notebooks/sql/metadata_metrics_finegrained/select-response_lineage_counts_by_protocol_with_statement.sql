-- lineage counts now include the possible iso lineage statement
with i as (
    select d.response_id, (e.value->'protocol')::text as ident
    from identities d, jsonb_array_elements(d.identity::jsonb) e
    where d.identity is not null 
        and (e.value->>'protocol' = 'ISO' or e.value->>'protocol' = 'FGDC' )
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
    where (m.lineage->>'tag')::text ilike '%%/dataQualityInfo/DQ_DataQuality/lineage/LI_Lineage/statement/CharacterString%'
)

select 
    case when 
        (c.existences->'lineage')::text::boolean = True 
            or x.statement_tokens is not null 
        then True 
        else False 
    end as the_lineage,
    count(c.response_id),
    i.ident
from metadata_completeness c 
    left outer join x on x.response_id = c.response_id
    left outer join i on i.response_id = c.response_id
group by i.ident, the_lineage;