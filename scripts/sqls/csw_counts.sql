
with i as (
	select d.response_id, e.value as ident
	from identities d, jsonb_array_elements(d.identity::jsonb) e
	where d.identity is not null
), j as 
(
	select r.id, r.host, 
		case 
			when trim(both '"' from (i.ident->'protocol')::text) = 'OGC' and i.ident ? 'service'
				then 'OGC:' || trim(both '"' from (i.ident->'service'->'name')::text) || ' ' || trim(both '"' from (i.ident->'service'->'request')::text)
			when trim(both '"' from (i.ident->'protocol')::text) = 'OGC' and i.ident ? 'dataset'
				then 'OGC:' || trim(both '"' from (i.ident->'dataset'->'name')::text) || ' ' || trim(both '"' from (i.ident->'dataset'->'request')::text)
			when trim(both '"' from (i.ident->'protocol')::text) = 'OGC' and i.ident ? 'resultset'
				then 'OGC:CSW Resultset'
			else trim(both '"' from (i.ident->'protocol')::text)
		end as protocol,
		(
			select count(i.response_id) from i where trim(both '"' from (i.ident->>'protocol')::text) = 'OGC'
		) as total_ogc
	from responses r join i on i.response_id = r.id
		where trim(both '"' from (i.ident->>'protocol')::text) = 'OGC'
)

select j.protocol, count(j.id),
	round(count(j.id)/max(j.total_ogc)::numeric * 100., 2) as pct_of_ogc
from j
group by j.protocol
order by j.protocol;