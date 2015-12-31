-- average token per element
with t as (
    select id, response_id, 
        trim(both '"' from (j.value->'tag')::text) as original_tag, 
        (string_to_array(trim(both '"' from (j.value->'tag')::text), '/'))[array_upper(string_to_array(trim(both '"' from (j.value->'tag')::text), '/'), 1)] as tag,
        regexp_split_to_array(replace(trim(both '"' from (j.value->'values')::text), ' | ', ' '), E'\\\s+') as tokens
    from ogc_tokens, json_array_elements(tokens) j
)
select t.tag, 
    round(avg(array_length(t.tokens, 1)), 2) as average_tokens,
    min(array_length(t.tokens, 1)) as min_tokens,
    max(array_length(t.tokens, 1)) as max_tokens
from t
group by t.tag
order by average_tokens DESC;