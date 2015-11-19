-- select avg(array_length(errors, 1)), min(array_length(errors, 1)), max(array_length(errors, 1))
-- from validations
-- where valid = False;

-- 79.7300650111904508;1;68376

with i as 
(
	select d.response_id, (e.value->'protocol')::text as ident
   	from identities d, jsonb_array_elements(d.identity::jsonb) e
	where d.identity is not null 
		and (e.value->>'protocol' = 'ISO' or e.value->>'protocol' = 'FGDC')
)
select r.id, 
	r.host, 
	r.metadata_age::date as age, 
	extract('year' from r.metadata_age) as the_year,
	array_length(v.errors, 1) as number_of_errors,
	trim(both '"' from i.ident) as protocol
from responses r 
	right outer join validations as v on v.response_id = r.id
	left outer join i on i.response_id = r.id
where v.valid = False;