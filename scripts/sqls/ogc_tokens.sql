-- select round(avg(json_array_length(tokens) / expected_total::numeric * 100.), 2)
-- from ogc_tokens;

with t as (
	select id, 
		trim(both '"' from (j.value->'tag')::text) as tag, 
		trim(both '"' from (j.value->'values')::text) as tokens
	from ogc_tokens, json_array_elements(tokens) j
	where trim(both '"' from (j.value->'tag')::text) ilike '%/Abstract' 
		or trim(both '"' from (j.value->'tag')::text) ilike '%Title' 
		or trim(both '"' from (j.value->'tag')::text) ilike '%/KeywordList/%'
)

select * 
from t;