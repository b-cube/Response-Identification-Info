-- distinct strings per element, excluding contacts
with t as (
    select id, response_id, 
        trim(both '"' from (j.value->'tag')::text) as original_tag, 
        (string_to_array(trim(both '"' from (j.value->'tag')::text), '/'))[array_upper(string_to_array(trim(both '"' from (j.value->'tag')::text), '/'), 1)] as tag,
        trim(both '"' from (j.value->'values')::text) as tokens
    from ogc_tokens, json_array_elements(tokens) j
)
select distinct t.tag, t.tokens, count(t.tokens) as num_per_tag
from t
where t.original_tag not ilike '%%/Contact%%' and t.tag != '@href'
group by t.tag, t.tokens
having count(t.tokens) >= 10
order by t.tag, num_per_tag DESC
;