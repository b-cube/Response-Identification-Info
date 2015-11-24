with j as (
	select i.response_id, k.*
	from identities i, jsonb_array_elements(i.identity::jsonb) k
)
select j.response_id, r.source_url, j.value,
	trim(both '"' from (j.value->'protocol')::text) as protocol,
	case 
		when trim(both '"' from (j.value->'protocol')::text) = 'OpenSearch' and j.value ? 'service'
			then trim(both '"' from (j.value->'service'->'name')::text)
		when trim(both '"' from (j.value->'protocol')::text) = 'OpenSearch' and j.value ? 'resultset'
			then 'Resultset'
		when trim(both '"' from (j.value->'protocol')::text) = 'OGC' and j.value ? 'service'
			then trim(both '"' from (j.value->'service'->'name')::text) || ':' || trim(both '"' from (j.value->'service'->'request')::text)
		when trim(both '"' from (j.value->'protocol')::text) = 'OGC' and j.value ? 'dataset'
			then trim(both '"' from (j.value->'dataset'->'name')::text) || ':' || trim(both '"' from (j.value->'dataset'->'request')::text)
	end as description
from j
	join responses r on j.response_id = r.id
where (j.value->>'protocol')::text = 'OGC' or (j.value->>'protocol')::text = 'OpenSearch';