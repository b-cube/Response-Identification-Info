-- identifiers as percentages per protocol & type
with i as (
    select d.response_id, e.value as ident
    from identities d, jsonb_array_elements(d.identity::jsonb) e
    where d.identity is not null
), j as 
(
    select r.id, r.host, 
        case 
            when trim(both '"' from (i.ident->'protocol')::text) = 'OpenSearch' and i.ident ? 'service'
                then 'OpenSearch:' || trim(both '"' from (i.ident->'service'->'name')::text)
            when trim(both '"' from (i.ident->'protocol')::text) = 'OpenSearch' and i.ident ? 'resultset'
                then 'OpenSearch:Resultset'
            when trim(both '"' from (i.ident->'protocol')::text) = 'OGC' and i.ident ? 'service'
                then 'OGC:' || trim(both '"' from (i.ident->'service'->'name')::text) || ' ' || trim(both '"' from (i.ident->'service'->'request')::text)
            when trim(both '"' from (i.ident->'protocol')::text) = 'OGC' and i.ident ? 'dataset'
                then 'OGC:' || trim(both '"' from (i.ident->'dataset'->'name')::text) || ' ' || trim(both '"' from (i.ident->'dataset'->'request')::text)
            when trim(both '"' from (i.ident->'protocol')::text) = 'OGC' and i.ident ? 'resultset'
                then 'OGC:CSW Resultset'
        else trim(both '"' from (i.ident->'protocol')::text)
        end as protocol
    from responses r join i on i.response_id = r.id
), k as (
    select j.protocol, count(distinct j.id) as total
    from j 
    group by j.protocol
)

select j.protocol, u.match_type, count(distinct j.id) as count_w_type,
    round(count(distinct j.id) / max(k.total)::numeric * 100., 2) as pct_w_type,
    max(k.total) as total_responses
from j 
    inner join unique_identifiers u on u.response_id = j.id
    join k on k.protocol = j.protocol
where u.match_type != 'url'
group by j.protocol, u.match_type
order by j.protocol, u.match_type, pct_w_type desc;