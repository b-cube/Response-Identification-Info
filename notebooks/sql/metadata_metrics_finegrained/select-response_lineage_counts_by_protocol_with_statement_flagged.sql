-- lineage counts with the processing steps vs statement flagged
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
    where (m.lineage->>'tag')::text ilike '%%/dataQualityInfo/DQ_DataQuality/lineage/LI_Lineage/statement/CharacterString%'
)

select date_trunc('month', r.metadata_age)::date as age,
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
group by age, lineage_type
order by lineage_type, age ASC;