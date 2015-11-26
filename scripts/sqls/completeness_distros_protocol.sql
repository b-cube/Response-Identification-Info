-- with i as (
-- 	select d.response_id, (e.value->'protocol')::text as protocol
-- 	from identities d, jsonb_array_elements(d.identity::jsonb) e
-- 	where d.identity is not null 
-- 		and (e.value->>'protocol' = 'ISO' or e.value->>'protocol' = 'FGDC')
-- ), j as (
-- 	select protocol, count(distinct i.response_id) as total_per_protocol
-- 	from i
-- 	group by protocol
-- )
-- select 
-- -- 	m.response_id, 
-- -- 	date_trunc('year', r.metadata_age)::date as age,
-- 	trim(both '"' from i.protocol) as protocol,
-- -- 	sum(json_array_length(m.distributions->'nondigital')) as num_nondigital,
-- -- 	sum(json_array_length(m.distributions->'offline')) as num_offline,
-- 	sum(json_array_length(m.distributions->'online')) as num_online,
-- 	round(avg(json_array_length(m.distributions->'online')), 2) as avg_per_response_online,
-- 	sum(
-- 		case when json_array_length(m.distributions->'online') > 0 then 1 else 0 end
-- 	) as num_records_with_online,
-- 	max(j.total_per_protocol) as total_per_protocol,
-- 	round(
-- 		sum(
-- 			case when json_array_length(m.distributions->'online') > 0 then 1 else 0 end
-- 		) / max(j.total_per_protocol)::numeric * 100., 2
-- 	) as pct_w_offline
-- from metadata_completeness m
-- 	join responses r on r.id = m.response_id
-- 	join i on i.response_id = m.response_id
-- 	join j on i.protocol = j.protocol
-- group by i.protocol
-- order by num_online DESC;

-- for status codes by metadata age
-- this is a ridicks number of ctes for really no reason
with m as (
	select response_id, 
		case 
			when (online->>'status')::text::int BETWEEN 200 and 399 then 'Available'
			when (online->>'status')::text::int >= 400 then 'Unavailable'
		end as availability
-- 	round(
-- 		case when (online->>'status')::text::int = 999 then 900
-- 		else (online->>'status')::text::int end, 
-- 	-2) as status_code
	from metadata_completeness,
		json_array_elements(distributions->'online') online
), a as (
	select extract(year from metadata_age) as the_year,
		count(id) as responses_per_year
	from responses
	where metadata_age is not null
	group by the_year
), i as (
	select d.response_id, trim(both '"' from (e.value->'protocol')::text) as protocol
	from identities d, jsonb_array_elements(d.identity::jsonb) e
	where d.identity is not null 
		and (e.value->>'protocol' = 'ISO' or e.value->>'protocol' = 'FGDC')
)
, j as (
	select protocol, extract(year from k.metadata_age) as the_year,
		count(distinct i.response_id) as total_per_protocol
	from i join responses k on i.response_id = k.id
	group by protocol, the_year
)
select a.the_year, 
	i.protocol, 
	m.availability, 
	count(m.availability) as num_available,
	count(distinct r.id) as responses_per_status,
	max(j.total_per_protocol) as responses_per_year,
	round(
		count(distinct r.id) / max(j.total_per_protocol)::numeric * 100., 2
	) as pct_protocol
from responses r join m on m.response_id = r.id
	join a on a.the_year = extract(year from r.metadata_age) 
	join i on i.response_id = m.response_id
    	join j on i.protocol = j.protocol and j.the_year = a.the_year
where r.metadata_age is not null and a.the_year > 1995 and a.the_year < 2016
group by a.the_year, i.protocol, m.availability
order by a.the_year, i.protocol, m.availability ASC;