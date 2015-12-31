-- identified by host but with more than 10 docs and no opensearch (wouldn't meet the >10 anyway)
with i
as (
    select d.response_id, jsonb_array_elements(d.identity::jsonb) ident
    from identities d
    where d.identity is not null
), h as (
    select r.host, count(r.host) as total_for_host
    from responses r
    where r.host is not null and r.host != ''
    group by r.host
)
select r.host,
    count(i.ident->'protocol') as num_identified_by_protocol,
    i.ident->'protocol' as protocol,
    min(h.total_for_host) as total_for_host
from responses r join i on i.response_id = r.id
    join h on h.host = r.host
where h.total_for_host > 1 and i.ident->>'protocol' != 'OpenSearch'
group by r.host, protocol
order by r.host asc, protocol desc;