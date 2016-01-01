-- counts of responses with lineage, in a pretty not great way
with m as (
    select response_id, existences->'lineage' as has_lineage,
        existences->'attribute' as has_attribute,
        existences->'data_quality' as has_quality,
        existences->'metadata' as has_metadata
    from metadata_completeness
)

select r.host,
    sum(case when m.has_lineage::text = 'true' then 1 else 0 end) as count_w_lineage,
    sum(case when m.has_lineage::text != 'true' then 1 else 0 end) as count_wo_lineage
from responses r join m on m.response_id = r.id
group by r.host
order by count_w_lineage DESC;