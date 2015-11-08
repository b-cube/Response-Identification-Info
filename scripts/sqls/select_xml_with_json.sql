-- with i as 
-- (
-- 	select d.response_id, jsonb_array_elements(d.identity::jsonb) ident
-- 	from identities d
-- 	where d.identity is not null
-- )

-- select r.host, count(r.source_url) as responses_with_json --i.ident->'protocol' as protocol, 
-- --x.extracted_json, x.xpath
-- from responses r 
-- 	join xml_with_jsons x on x.file = r.source_url_sha
-- 	--join i on i.response_id = r.id
-- --order by i.ident->>'protocol';
-- 
-- group by r.host
-- order by responses_with_json DESC;


-- select x.xpath, count(x.xpath) as xpaths 
-- from responses r 
--     join xml_with_jsons x on x.file = r.source_url_sha
-- group by x.xpath
-- order by xpaths DESC;

with i as 
(
	select d.response_id, jsonb_array_elements(d.identity::jsonb) ident
	from identities d
	where d.identity is not null
)

select r.host, x.xpath,x.extracted_json, i.ident->'protocol' as protocol
--x.extracted_json, x.xpath
from responses r 
	join xml_with_jsons x on x.file = r.source_url_sha
	join i on i.response_id = r.id
--order by i.ident->>'protocol';

order by x.xpath;