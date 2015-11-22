-- select count(j.*)
-- from ogc_tokens, json_array_elements(tokens) j;

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

with t as (
	select id, response_id, 
		trim(both '"' from (j.value->'tag')::text) as original_tag, 
		(string_to_array(trim(both '"' from (j.value->'tag')::text), '/'))[array_upper(string_to_array(trim(both '"' from (j.value->'tag')::text), '/'), 1)] as tag,
		regexp_split_to_array(replace(trim(both '"' from (j.value->'values')::text), ' | ', ' '), E'\\s+') as tokens
	from ogc_tokens, json_array_elements(tokens) j
)
select t.tag, 
	round(avg(array_length(t.tokens, 1)), 2) as average_tokens,
	min(array_length(t.tokens, 1)) as min_tokens,
	max(array_length(t.tokens, 1)) as max_tokens
from t
group by t.tag
order by average_tokens DESC;