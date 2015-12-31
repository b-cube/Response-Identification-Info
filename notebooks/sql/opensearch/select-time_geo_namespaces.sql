-- select osdd urls flagged for time/geo namespaces
select url, 
    case when namespaces::jsonb ? 'geo' then True else False end as contains_geo,
    case when namespaces::jsonb ? 'time' then True else False end as contains_time
from osdds
where namespaces::jsonb ?| array['time', 'geo'];