with i as 
(
	select d.response_id, jsonb_array_elements(d.identity::jsonb) ident
	from identities d
	where d.identity is not null
)

select r.source_url, i.ident->'protocol' as protocol, x.extracted_json, x.xpath
from responses r 
	join xml_with_jsons x on x.file = r.source_url_sha
	join i on i.response_id = r.id
order by i.ident->>'protocol';