-- select tags, element_key, element_value, count(element_value) as num_elems
-- from iso_onlineresources
-- where element_key = 'protocol' or element_key = 'application_profile'
-- group by tags, element_key, element_value
-- order by tags, element_key, element_value, num_elems DESC;

-- let's look at protocols

-- select element_key, element_value, count(element_value) as num_elems
-- from iso_onlineresources
-- where element_key = 'protocol' or element_key = 'application_profile' or element_key = 'function_code'
-- group by element_key, element_value
-- order by element_key, element_value, num_elems DESC;

-- select element_value, count(element_value) as num_elems
-- from iso_onlineresources
-- where element_key = 'function_code'
-- 	and tags ilike '%/distributionInfo%'
-- group by element_key, element_value
-- order by element_key, element_value, num_elems DESC;


-- select element_value, count(distinct response_id) as num_responses_w_one
-- from iso_onlineresources
-- where element_key = 'function_code'
-- 	and tags ilike '%/distributionInfo%'
-- group by element_key, element_value
-- order by element_key, element_value, num_responses_w_one DESC;

-- with j as 
-- (
-- 	select response_id, element_value, count(id) as num_values
-- 	from iso_onlineresources
-- 	where element_key = 'protocol'
-- 		and tags ilike '%/distributionInfo%'
-- 	group by element_key, response_id, element_value
-- )
-- select element_value, round(avg(j.num_values), 2) as avg_values
-- from j
-- group by element_value
-- ;

-- with j as 
-- (
-- 	select response_id, element_value, count(id) as num_values
-- 	from iso_onlineresources
-- 	where element_key = 'protocol'
-- 		and tags ilike '%/distributionInfo%'
-- 	group by element_key, response_id, element_value
-- ), i as (
-- 	select d.response_id, (e.value->'protocol')::text as protocol
-- 	from identities d, jsonb_array_elements(d.identity::jsonb) e
-- 	where d.identity is not null and e.value->>'protocol' = 'ISO'
-- ), y as (
-- 	select x.host, count(distinct i.response_id) as total_count
-- 	from responses x join i on i.response_id = x.id
-- 	group by x.host
-- )
-- select element_value,
-- 	r.host,
-- 	count(distinct j.response_id) as num_responses,
-- 	max(y.total_count) as total_responses,
-- 	round(count(distinct j.response_id) /max (y.total_count)::numeric * 100., 2) as pct_per_host
-- from j join responses r on j.response_id = r.id
-- 	join y on r.host = y.host
-- group by r.host, element_value
-- order by r.host, element_value, num_responses DESC;

-- -- how many have a protocol at all?
-- with j as 
-- (
-- 	select response_id, element_key, count(id) as num_values
-- 	from iso_onlineresources
-- 	where --element_key = 'name'
-- 		--and 
-- 		tags ilike '%/distributionInfo%'
-- 	group by element_key, response_id
-- ), i as (
-- 	select d.response_id, (e.value->'protocol')::text as protocol
-- 	from identities d, jsonb_array_elements(d.identity::jsonb) e
-- 	where d.identity is not null and e.value->>'protocol' = 'ISO'
-- )
-- select j.element_key, 
-- 	count(distinct j.response_id) as num_responses,
-- 	(
-- 		select count(distinct i.response_id) as total_responses
-- 		from i
-- 	) as total_responses,
-- 	round(
-- 		count(distinct j.response_id) / (
-- 			select count(distinct i.response_id)::numeric
-- 			from i
-- 		) * 100., 2
-- 	) as pct_responses
-- from j join responses r on j.response_id = r.id
-- group by j.element_key
-- order by num_responses DESC;


with j as (
	select response_id, id, lower(element_value) as eval, element_key
	from iso_onlineresources
	where tags ilike '%/distributionInfo%' and element_key != 'function_codelist'
)
select j.eval, array_agg(distinct j.element_key) as keys, count(j.id) as num_vals
from j
group by j.eval
having array_length(array_agg(distinct j.element_key), 1) > 1 and array_agg(distinct j.element_key)::text[] <> ARRAY['description', 'name']
order by num_vals DESC;