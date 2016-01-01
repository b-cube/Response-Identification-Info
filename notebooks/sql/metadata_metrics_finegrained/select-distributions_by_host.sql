-- online distros per host
with m as (
    select response_id, online
    from metadata_completeness,
        json_array_elements(distributions->'online') online
)
select r.host, count(m.online) as num_hrefs
from responses r join m on m.response_id = r.id
group by r.host
order by num_hrefs DESC;