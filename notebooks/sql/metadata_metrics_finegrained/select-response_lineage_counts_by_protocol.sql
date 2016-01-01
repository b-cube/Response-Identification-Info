-- lineages by protocol
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
)

select i.ident->'protocol' as protocol,
    sum(case when m.has_lineage::text = 'true' then 1 else 0 end) as count_w_lineage,
    sum(case when m.has_lineage::text != 'true' then 1 else 0 end) as count_wo_lineage
    
from responses r join m on m.response_id = r.id
    join i on i.response_id = r.id
group by protocol
order by protocol;