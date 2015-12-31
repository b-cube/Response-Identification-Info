-- binned by protocol
with i as 
(
    select d.response_id, jsonb_array_elements(d.identity::jsonb) ident
    from identities d
    where d.identity is not null
)

select x.xpath, count(r.source_url) as responses_with_json, i.ident->'protocol' as protocol
from responses r 
    join xml_with_jsons x on x.file = r.source_url_sha
    join i on i.response_id = r.id
group by x.xpath, protocol
order by x.xpath, responses_with_json DESC;