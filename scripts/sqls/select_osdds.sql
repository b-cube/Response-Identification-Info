with i
as (
	select d.response_id, jsonb_array_elements(d.identity::jsonb) ident
	from identities d
	where d.identity is not null
)

select r.source_url, i.ident->'protocol' as protocol, i.ident
from responses r join i on i.response_id = r.id
-- where i.ident->>'protocol' = 'OpenSearch';
where i.ident->>'protocol' = 'OpenSearch' and i.ident#>>'{service,name}' = 'OpenSearchDescription';