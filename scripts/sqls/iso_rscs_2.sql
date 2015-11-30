-- with j as 
-- (
-- 	select response_id, element_value, count(id) as num_values
-- 	from iso_onlineresources
-- 	where element_key = 'function_code'
-- 		and tags ilike '%/distributionInfo%'
-- 	group by element_key, response_id, element_value
-- ), i as (
-- 	select d.response_id, (e.value->'protocol')::text as protocol
-- 	from identities d, jsonb_array_elements(d.identity::jsonb) e
-- 	where d.identity is not null and e.value->>'protocol' = 'ISO'
-- ), k as (
-- 	select y.host, count(distinct y.id) as total_per_host
-- 		from responses y join i on i.response_id = y.id
-- 		group by y.host
-- )
-- select element_value,
-- 	r.host,
-- 	count(distinct j.response_id) as num_responses,
-- 	max(k.total_per_host) as total_per_host,
-- 	round(
-- 		count(distinct j.response_id) / max(k.total_per_host)::numeric * 100., 2
-- 	) as pct
-- from j join responses r on j.response_id = r.id
-- 	join k on k.host = r.host
-- group by r.host, element_value
-- order by element_value, r.host, num_responses DESC;

with j as (
	select response_id, id, lower(element_value) as eval, element_key
	from iso_onlineresources
	where tags ilike '%%/distributionInfo%%' and element_key = 'function_code'
)
select j.eval,
    count(j.id) as num_vals,
    count(distinct j.response_id) as num_responses,
    round(count(distinct j.response_id)/19689. * 100., 2) as pct_responses
from j
group by j.eval
order by num_vals DESC;