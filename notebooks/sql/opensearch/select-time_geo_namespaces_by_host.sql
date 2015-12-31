-- count the osdds with time & geo binned by host
with a as (
    select url, response_id, 
        case when namespaces::jsonb ? 'geo' then True else False end as contains_geo,
        case when namespaces::jsonb ? 'time' then True else False end as contains_time
    from osdds
    where namespaces::jsonb ?| array['time', 'geo']
)

select r.host, count(*)
from a join responses r on r.id = a.response_id
where contains_geo = True and contains_time = True
group by r.host;