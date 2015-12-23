with k as (
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
				then 'OpenSearch:Resultset'
			when trim(both '"' from (j.value->'protocol')::text) = 'OAI-PMH' and j.value ? 'service'
				then 'OAI-PMH:Identify'
			when trim(both '"' from (j.value->'protocol')::text) = 'OGC' and j.value ? 'service'
				then trim(both '"' from (j.value->'service'->'name')::text) || ':' || trim(both '"' from (j.value->'service'->'request')::text)
			when trim(both '"' from (j.value->'protocol')::text) = 'OGC' and j.value ? 'dataset'
				then trim(both '"' from (j.value->'dataset'->'name')::text) || ':' || trim(both '"' from (j.value->'dataset'->'request')::text)
		else trim(both '"' from (j.value->'protocol')::text)
		end as description
	from j
		join responses r on j.response_id = r.id
)
select k.description, v.valid, count(distinct k.response_id) as num
from k join validations v on v.response_id = k.response_id
group by k.description, v.valid
order by k.description, v.valid;