-- with i as 
-- (
--     select d.response_id, jsonb_array_elements(d.identity::jsonb) ident
--     from identities d
--     where d.identity is not null
-- ), a as (
-- 	select extract(year from metadata_age) as the_year,
-- 		count(id) as responses_per_year
-- 	from responses
-- 	where metadata_age is not null
-- 	group by the_year
-- )
-- select r.id, r.host, a.the_year, a.responses_per_year,
--     array_length(v.errors, 1) as number_of_errors,
--     i.ident->'protocol' as protocol
-- from responses r 
--     right outer join validations as v on v.response_id = r.id
--     left outer join i on i.response_id = r.id
--     left outer join a on a.the_year = extract(year from r.metadata_age)
-- where v.valid = False and (i.ident->>'protocol' = 'ISO' or i.ident->>'protocol' = 'FGDC');

with i as 
(
    select d.response_id, jsonb_array_elements(d.identity::jsonb) ident
    from identities d
    where d.identity is not null
), a as (
	select extract(year from metadata_age) as the_year,
		count(id) as responses_per_year
	from responses
	where metadata_age is not null
	group by the_year
)
select a.the_year, 
	round(count(r.id) / min(a.responses_per_year)::numeric * 100.0, 2) as pct_per_year_w_error,
    sum(array_length(v.errors, 1)) as number_of_errors,
    i.ident->'protocol' as protocol
from responses r 
    right outer join validations as v on v.response_id = r.id
    left outer join i on i.response_id = r.id
    left outer join a on a.the_year = extract(year from r.metadata_age)
where v.valid = False 
	and (i.ident->>'protocol' = 'ISO' or i.ident->>'protocol' = 'FGDC')
	and the_year is not null
group by protocol, the_year
order by the_year ASC, protocol;