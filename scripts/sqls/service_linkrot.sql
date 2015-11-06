﻿-- select round(status, -2) as code, count(status)
-- from service_linkrot
-- group by code
-- order by code;

-- with i
-- as (
--     select d.response_id, jsonb_array_elements(d.identity::jsonb) ident
--     from identities d
--     where d.identity is not null
-- )
-- 
-- select i.ident->'protocol' as protocol,
-- 	date_trunc('month', r.initial_harvest_date)::date as harvest_month, 
-- 	round(status, -2) as code,
-- 	count(status)
-- from service_linkrot s join i on i.response_id = s.response_id
-- 	join responses r on r.id = s.response_id
-- group by protocol, code, harvest_month
-- order by protocol, code, date_trunc('month', r.initial_harvest_date)::date ASC;


with i
as (
    select d.response_id, jsonb_array_elements(d.identity::jsonb) ident
    from identities d
    where d.identity is not null
)

select i.ident->'protocol' as protocol, count(i.ident->'protocol'),
	date_trunc('month', r.initial_harvest_date)::date as harvest_month
from responses r join i on r.id = i.response_id
where i.ident->>'protocol' = 'OGC' or i.ident->>'protocol' = 'OpenSearch'
group by protocol, harvest_month
order by protocol, date_trunc('month', r.initial_harvest_date)::date ASC;