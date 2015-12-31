-- more specific DOI exploration by host and protocol
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
    select j.host, j.protocol, count(distinct j.id) as total
    from j 
    group by j.host, j.protocol
), h as 
(
    select j.protocol, count(distinct j.id) as total
    from j 
    group by j.protocol
)

select j.protocol, j.host, 
    count(distinct j.id) as count_w_doi,
    round(count(distinct j.id) / max(k.total)::numeric * 100., 2) as pct_w_doi_per_host,
    max(k.total) as total_responses_per_host,
    round(count(distinct j.id) / max(h.total)::numeric * 100., 2) as pct_w_doi_per_protocol,
    max(h.total) as total_responses_per_protocol
from j 
    inner join unique_identifiers u on u.response_id = j.id
    join k on k.host = j.host and k.protocol = j.protocol
    join h on h.protocol = j.protocol
where u.match_type = 'doi' and k.total > 10
group by j.protocol, j.host
order by j.protocol, pct_w_doi_per_host desc, j.host;