-- data quality token counts
with quality_tokens as
(
    select response_id, data_quality
    from metadata_completeness, json_array_elements(wordcounts->'data_quality') as data_quality
    where (wordcounts->'data_quality')::text != '[]'
), i as (
    select d.response_id, (e.value->'protocol')::text as ident
    from identities d, jsonb_array_elements(d.identity::jsonb) e
    where d.identity is not null 
        and e.value->>'protocol' = 'ISO'
)
select r.id, date_trunc('month', r.metadata_age)::date as age,
    min(i.ident) as protocol,
    sum((y.data_quality->'tokens')::text::int) as num_quality_tokens,
    count(y.data_quality->'tokens') as num_quality_elements
from responses r join i on i.response_id = r.id
    left outer join quality_tokens y on y.response_id = r.id
where i.ident = '"ISO"'
group by r.id
order by num_quality_elements DESC;