-- responses with a distribution link using any of the children elements
with j as 
(
    select response_id, element_key, count(id) as num_values
    from iso_onlineresources
    where --element_key = 'name'
        --and 
        tags ilike '%%/distributionInfo%%'
    group by element_key, response_id
), i as (
    select d.response_id, (e.value->'protocol')::text as protocol
    from identities d, jsonb_array_elements(d.identity::jsonb) e
    where d.identity is not null and e.value->>'protocol' = 'ISO'
)
select j.element_key, 
    count(distinct j.response_id) as num_responses,
    (
        select count(distinct i.response_id) as total_responses
        from i
    ) as total_responses,
    round(
        count(distinct j.response_id) / (
            select count(distinct i.response_id)::numeric
            from i
        ) * 100., 2
    ) as pct_responses
from j join responses r on j.response_id = r.id
group by j.element_key
order by num_responses DESC;