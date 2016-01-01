-- distribution linkrot binned by year without shakemap
with m as (
    select response_id, round((online->>'status')::text::int, -2) as status_code
    from metadata_completeness,
        json_array_elements(distributions->'online') online
), a as (
    select extract(year from metadata_age) as the_year,
        count(id) as responses_per_year
    from responses
    where metadata_age is not null and host != 'earthquake.usgs.gov'
    group by the_year
)
select a.the_year, m.status_code, count(m.status_code) as num_per_status
from responses r join m on m.response_id = r.id
    join a on a.the_year = extract(year from r.metadata_age) 
where r.metadata_age is not null
group by a.the_year, m.status_code
order by a.the_year, m.status_code ASC;