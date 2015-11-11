-- select round(status, -2) as code, count(status)
-- from service_linkrot
-- group by code
-- order by code;

-- -- binned by protocol
-- with i
-- as (
--     select d.response_id, jsonb_array_elements(d.identity::jsonb) ident
--     from identities d
--     where d.identity is not null
-- )
-- select i.ident->'protocol' as protocol,
-- 	round(status, -2) as code,
-- 	count(r.id) as count_per_code
-- from service_linkrot s join i on i.response_id = s.response_id
-- 	join responses r on r.id = s.response_id
-- group by protocol, code
-- order by protocol, code;


-- counts by protocol, status, date
with i
as (
    select d.response_id, jsonb_array_elements(d.identity::jsonb) ident
    from identities d
    where d.identity is not null
)

select i.ident->'protocol' as protocol,
	date_trunc('month', r.initial_harvest_date)::date as harvest_month, 
	round(status, -2) as code,
	count(status)
from service_linkrot s join i on i.response_id = s.response_id
	join responses r on r.id = s.response_id
group by protocol, code, harvest_month
order by protocol, code, date_trunc('month', r.initial_harvest_date)::date ASC;

-- -- linkrot by protocol and harvest month
-- with i
-- as (
--     select d.response_id, jsonb_array_elements(d.identity::jsonb) ident
--     from identities d
--     where d.identity is not null
-- )
-- 
-- select i.ident->'protocol' as protocol, count(i.ident->'protocol'),
-- 	date_trunc('month', r.initial_harvest_date)::date as harvest_month
-- from responses r join i on r.id = i.response_id
-- where i.ident->>'protocol' = 'OGC' or i.ident->>'protocol' = 'OpenSearch'
-- group by protocol, harvest_month
-- order by protocol, date_trunc('month', r.initial_harvest_date)::date ASC;

-- -- links by harvest month
-- with i
-- as (
--     select d.response_id, jsonb_array_elements(d.identity::jsonb) ident
--     from identities d
--     where d.identity is not null
-- )
-- 
-- select i.ident->'protocol' as protocol,
-- 	date_trunc('month', r.initial_harvest_date)::date as harvest_month, 
-- 	r.source_url,
-- 	round(s.status, -2) as status_code
-- from responses r join i on r.id = i.response_id
-- 	join service_linkrot s on s.response_id = r.id
-- where i.ident->>'protocol' = 'OGC' or i.ident->>'protocol' = 'OpenSearch'
-- order by protocol, date_trunc('month', r.initial_harvest_date)::date ASC;


-- -- -- issues with ogc and head requests
-- with i
-- as (
--     select d.response_id, jsonb_array_elements(d.identity::jsonb) ident
--     from identities d
--     where d.identity is not null
-- )
-- 
-- select date_trunc('month', r.initial_harvest_date)::date as harvest_month, 
-- 	r.source_url,
-- 	round(s.status, -2) as status_code
-- from responses r join i on r.id = i.response_id
-- 	join service_linkrot s on s.response_id = r.id
-- where i.ident->>'protocol' = 'OGC' and round(s.status, -2) > 200 and round(s.status, -2) < 900 
-- order by date_trunc('month', r.initial_harvest_date)::date ASC;