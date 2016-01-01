-- kinds of distribution objects (urls or otherwise)
with i as (
    select d.response_id, (e.value->'protocol')::text as protocol
    from identities d, jsonb_array_elements(d.identity::jsonb) e
    where d.identity is not null 
        and (e.value->>'protocol' = 'ISO' or e.value->>'protocol' = 'FGDC')
)
select m.response_id, 
    date_trunc('year', r.metadata_age)::date as age,
    trim(both '"' from i.protocol) as protocol,
    json_array_length(m.distributions->'nondigital') as num_nondigital,
    json_array_length(m.distributions->'offline') as num_offline,
    json_array_length(m.distributions->'online') as num_online
from metadata_completeness m
    join responses r on r.id = m.response_id
    join i on i.response_id = m.response_id;