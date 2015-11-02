-- select avg(array_length(errors, 1)), min(array_length(errors, 1)), max(array_length(errors, 1))
-- from validations
-- where valid = False;

-- 79.7300650111904508;1;68376

with i as 
(
	select d.response_id, jsonb_array_elements(d.identity::jsonb) ident
	from identities d
	where d.identity is not null
)
select r.id, r.host, r.metadata_age,
	array_length(v.errors, 1) as number_of_errors,
	i.ident->'protocol' as protocol
from responses r 
	right outer join validations as v on v.response_id = r.id
	left outer join i on i.response_id = r.id
where v.valid = False;