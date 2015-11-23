-- select count(j.*)
-- from ogc_tokens, json_array_elements(tokens) j;
-- 
-- select count(distinct r.host) as hosts
-- 	from responses r
-- 		join ogc_tokens o on o.response_id = r.id
-- ;

-- select round(avg(json_array_length(tokens) / expected_total::numeric * 100.), 2)
-- from ogc_tokens;

-- with t as (
-- 	select id, response_id, 
-- 		trim(both '"' from (j.value->'tag')::text) as tag, 
-- 		trim(both '"' from (j.value->'values')::text) as tokens
-- 	from ogc_tokens, json_array_elements(tokens) j
-- 	where trim(both '"' from (j.value->'tag')::text) ilike '%/Abstract' 
-- 		or trim(both '"' from (j.value->'tag')::text) ilike '%Title' 
-- 		or trim(both '"' from (j.value->'tag')::text) ilike '%/KeywordList/%'
-- )
-- select count(*) as num_elements, 
-- 	round(count(*) / 24248. * 100., 2) as pct_elements,
-- 	count(distinct t.id) as num_responses,
-- 	round(count(distinct t.id) / 3828. * 100., 2) as pct_responses
-- from t
-- where (t.tag ilike '%/Abstract' or t.tag ilike '%/Title') 
-- 	and (t.tokens ilike 'W%S' or t.tokens ='CSW' or t.tokens = 'SOS' or t.tokens ilike 'OGC:W%S');


-- with t as (
-- 	select id, response_id, 
-- 		trim(both '"' from (j.value->'tag')::text) as original_tag, 
-- 		case
-- 			when trim(both '"' from (j.value->'tag')::text) ilike '%/Abstract' then 'abstract'
-- 			when trim(both '"' from (j.value->'tag')::text) ilike '%/Title' then 'title'
-- 			when trim(both '"' from (j.value->'tag')::text) ilike '%/Keyword%' then 'keyword'
-- 		end as tag,
-- 		replace(trim(both '"' from (j.value->'values')::text), ' | ', ' ') as token_string,
-- 		regexp_split_to_array(replace(trim(both '"' from (j.value->'values')::text), ' | ', ' '), E'\\s+') as tokens
-- 	from ogc_tokens, json_array_elements(tokens) j
-- 	where trim(both '"' from (j.value->'tag')::text) ilike '%/Abstract' 
-- 		or trim(both '"' from (j.value->'tag')::text) ilike '%Title' 
-- 		or trim(both '"' from (j.value->'tag')::text) ilike '%/Keyword%'
-- )
-- select t.tag, 
-- 	round(avg(array_length(t.tokens, 1)), 2) as average_tokens,
-- 	min(array_length(t.tokens, 1)) as min_tokens,
-- 	max(array_length(t.tokens, 1)) as max_tokens
-- from t
-- where not((t.tag ilike 'abstract' or t.tag ilike 'title') 
-- 	and (t.token_string ilike 'W%S' or t.token_string ='CSW' or t.token_string = 'SOS' or t.token_string ilike 'OGC:W%S'))
-- group by t.tag
-- order by average_tokens DESC;

-- with t as (
-- 	select id, response_id, 
-- 		trim(both '"' from (j.value->'tag')::text) as original_tag, 
-- 		(string_to_array(trim(both '"' from (j.value->'tag')::text), '/'))[array_upper(string_to_array(trim(both '"' from (j.value->'tag')::text), '/'), 1)] as tag,
-- 		regexp_split_to_array(replace(trim(both '"' from (j.value->'values')::text), ' | ', ' '), E'\\s+') as tokens
-- 	from ogc_tokens, json_array_elements(tokens) j
-- )
-- select t.tag, 
-- 	round(avg(array_length(t.tokens, 1)), 2) as average_tokens,
-- 	min(array_length(t.tokens, 1)) as min_tokens,
-- 	max(array_length(t.tokens, 1)) as max_tokens
-- from t
-- group by t.tag
-- order by average_tokens DESC;

-- tokens per tag with tag frequency
-- with t as (
-- 	select id, response_id, 
-- 		trim(both '"' from (j.value->'tag')::text) as original_tag, 
-- 		(string_to_array(trim(both '"' from (j.value->'tag')::text), '/'))[array_upper(string_to_array(trim(both '"' from (j.value->'tag')::text), '/'), 1)] as tag,
-- 		regexp_split_to_array(replace(trim(both '"' from (j.value->'values')::text), ' | ', ' '), E'\\s+') as tokens
-- 	from ogc_tokens, json_array_elements(tokens) j
-- )
-- , frequencies as (
-- 	select t.tag, count(id) as num_with_tag
-- 	from t
-- 	group by t.tag
-- ),
-- host_frequencies as (
-- 	select r.host, count(r.id) as responses_per_host
-- 	from responses r
-- 		join ogc_tokens o on o.response_id = r.id
-- 	group by host
-- )
-- 
-- select t.tag, r.host, max(f.num_with_tag) as freq_tag_by_response,
-- 	max(h.responses_per_host) as response_per_host,
-- 	round(avg(array_length(t.tokens, 1)), 2) as average_tokens,
-- 	min(array_length(t.tokens, 1)) as min_tokens,
-- 	max(array_length(t.tokens, 1)) as max_tokens,
-- 	-- case when max(array_length(t.tokens, 1)) = min(array_length(t.tokens, 1)) then false else true end as varies,
-- 	count(v.valid) as num_by_valid,
-- 	v.valid
-- from t join frequencies f on f.tag = t.tag
-- 	join responses r on t.response_id = r.id
-- 	join host_frequencies h on h.host = r.host
-- 	left outer join validations v on v.response_id = r.id
-- where t.original_tag not ilike '%/Contact%' and t.original_tag not ilike '%/ServiceType%' and t.tag != '@href'
-- group by t.tag, r.host, v.valid
-- having case when max(array_length(t.tokens, 1)) = min(array_length(t.tokens, 1)) then false else true end = True
-- order by freq_tag_by_response DESC; --average_tokens DESC;


-- looking for sameness in the tokens - wms or something)
-- with t as (
-- 	select id, response_id, 
-- 		trim(both '"' from (j.value->'tag')::text) as original_tag, 
-- 		(string_to_array(trim(both '"' from (j.value->'tag')::text), '/'))[array_upper(string_to_array(trim(both '"' from (j.value->'tag')::text), '/'), 1)] as tag,
-- 		trim(both '"' from (j.value->'values')::text) as tokens
-- 	from ogc_tokens, json_array_elements(tokens) j
-- )
-- select distinct t.tag, t.tokens, count(t.tokens) as num_per
-- from t
-- group by t.tag, t.tokens
-- having count(t.tokens) > 10
-- order by t.tag, num_per DESC
-- ;

with t as (
	select id, response_id, 
		trim(both '"' from (j.value->'tag')::text) as original_tag, 
		(string_to_array(trim(both '"' from (j.value->'tag')::text), '/'))[array_upper(string_to_array(trim(both '"' from (j.value->'tag')::text), '/'), 1)] as tag,
		regexp_split_to_array(replace(trim(both '"' from (j.value->'values')::text), ' | ', ' '), E'\\s+') as tokens
	from ogc_tokens, json_array_elements(tokens) j
)
, frequencies as (
	select t.tag, count(id) as num_with_tag
	from t
	group by t.tag
),
host_frequencies as (
	select r.host, count(r.id) as responses_per_host
	from responses r
		join ogc_tokens o on o.response_id = r.id
	group by host
)

select t.tag, r.host, max(f.num_with_tag) as freq_tag_by_response,
	max(h.responses_per_host) as response_per_host,
	round(avg(array_length(t.tokens, 1)), 2) as average_tokens,
	min(array_length(t.tokens, 1)) as min_tokens,
	max(array_length(t.tokens, 1)) as max_tokens,
	-- case when max(array_length(t.tokens, 1)) = min(array_length(t.tokens, 1)) then false else true end as varies,
	count(v.valid) as num_by_valid,
	v.valid
from t join frequencies f on f.tag = t.tag
	join responses r on t.response_id = r.id
	join host_frequencies h on h.host = r.host
	left outer join validations v on v.response_id = r.id
where t.original_tag not ilike '%/Contact%' and t.original_tag not ilike '%/ServiceType%' and t.tag != '@href'
group by t.tag, r.host, v.valid
having case when max(array_length(t.tokens, 1)) = min(array_length(t.tokens, 1)) then false else true end = True
order by freq_tag_by_response DESC;



with k as 
(
	with t as (
		select id, response_id, expected_total,
			trim(both '"' from (j.value->'tag')::text) as tag, 
			trim(both '"' from (j.value->'values')::text) as tokens
		from ogc_tokens, json_array_elements(tokens) j
	)
	select response_id, count(response_id) as num_tags, 
		round(count(response_id) / max(expected_total)::numeric * 100., 2) as pct_expected
	from t
	group by response_id
)
select r.host, v.valid
	round(avg(pct_expected), 2) as avg_completed,
	min(pct_expected) as min_expected,
	max(pct_expected) as max_expected
from k
	join responses r on k.response_id = r.id
	left outer join validations v on v.response_id = r.id
group by r.host, v.valid
order by r.host, avg_completed DESC;

	
-- where (t.tag ilike '%/Abstract' or t.tag ilike '%/Title') 
-- 	and (t.tokens ilike 'W%S' or t.tokens ='CSW' or t.tokens = 'SOS' or t.tokens ilike 'OGC:W%S');

