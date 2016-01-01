-- distribution linkrot binned by host
with m as (
    select response_id, round((online->>'status')::text::int, -2) as status_code
    from metadata_completeness,
        json_array_elements(distributions->'online') online
)
select r.host, m.status_code, count(m.status_code) as num_per_status
from responses r join m on m.response_id = r.id
group by r.host, m.status_code
order by r.host, m.status_code ASC;