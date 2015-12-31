-- token existence and validation
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
select r.host, v.valid,
    round(avg(pct_expected), 2) as avg_completed,
    min(pct_expected) as min_expected,
    max(pct_expected) as max_expected
from k
    join responses r on k.response_id = r.id
    left outer join validations v on v.response_id = r.id
group by r.host, v.valid
order by r.host, avg_completed DESC;