with i as (
	select i.response_id, k.*
	from identities i, jsonb_array_elements(i.identity::jsonb) k
), j as (
	select 
		trim(both '"' from (i.value->'protocol')::text) as protocol,
		case 
			when trim(both '"' from (i.value->'protocol')::text) = 'OpenSearch' and i.value ? 'service'
				then trim(both '"' from (j.value->'service'->'name')::text)
			when trim(both '"' from (i.value->'protocol')::text) = 'OpenSearch' and i.value ? 'resultset'
				then 'Resultset'
			when trim(both '"' from (i.value->'protocol')::text) = 'OGC' and i.value ? 'service'
				then trim(both '"' from (i.value->'service'->'name')::text) || ':' || trim(both '"' from (i.value->'service'->'request')::text)
			when trim(both '"' from (i.value->'protocol')::text) = 'OGC' and i.value ? 'dataset'
				then trim(both '"' from (i.value->'dataset'->'name')::text) || ':' || trim(both '"' from (i.value->'dataset'->'request')::text)
		end as description	

)
select 
	