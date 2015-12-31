with i as (
	select d.response_id, (e.value->'protocol')::text as ident
	from identities d, jsonb_array_elements(d.identity::jsonb) e
	where d.identity is not null 
		and (e.value->>'protocol' = 'ISO' or e.value->>'protocol' = 'FGDC')
)

select trim(both '"' from i.ident) as protocol, 
	date_trunc('year', metadata_age)::date as age, 
	count(r.id) as num_responses
from responses r join i on i.response_id = r.id
group by protocol, age
order by protocol, age desc;

--""FGDC"";26299 | 26299
--""ISO"";14132 | 19689
