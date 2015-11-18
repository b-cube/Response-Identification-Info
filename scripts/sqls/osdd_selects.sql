

-- with a as (
-- 	select url, response_id, 
-- 		case when namespaces::jsonb ? 'geo' then True else False end as contains_geo,
-- 		case when namespaces::jsonb ? 'time' then True else False end as contains_time
-- 	from osdds
-- 	where namespaces::jsonb ?| array['time', 'geo']
-- )
-- 
-- select r.host, count(*)
-- from a join responses r on r.id = a.response_id
-- where contains_geo = True and contains_time = True
-- group by r.host;

	--and namespaces->>'default' != 'http://www.w3.org/XML/1998/namespace';

-- with ns as(
--    select url, json_each_text(namespaces) as kvps
--    from osdds
-- )
-- 
-- select kvps, count(kvps)
-- from ns
-- group by kvps;



-- select count(distinct o.id)
-- from osdds o
-- where namespaces::jsonb->>


--kvps.value = 'http://a9.com/-/opensearch/extensions/geo/1.0/' or kvps.value = 'http://a9.com/-/opensearch/extensions/time/1.0/';


-- linkrot error is an incredibly descriptive value.
-- select o.status_code, count(o.id), 
-- 	-- add the duration between checked and harvested
-- 	avg(extract(day from o.date_verified - r.initial_harvest_date))::int as avg_lifespan_in_days,
-- 	min(extract(day from o.date_verified - r.initial_harvest_date))::int as min_lifespan_in_days,
-- 	max(extract(day from o.date_verified - r.initial_harvest_date))::int as max_lifespan_in_days
-- from osdds o join responses r on r.id = o.response_id
-- group by o.status_code
-- order by o.status_code ASC;

-- with a as (
-- 	select o.id, case when o.status_code is null then 999 else o.status_code end as status
-- 	from osdds o
-- )
-- select a.status, count(a.status), r.initial_harvest_date::date
-- from osdds o join responses r on r.id = o.response_id
-- 	join a on a.id = o.id
-- group by a.status, r.initial_harvest_date::date
-- order by r.initial_harvest_date::date ASC;

-- -- let's pivot the thing and lump by month
-- with a as (
-- 	select o.id, round(case when o.status_code is null then 900 else o.status_code end, -2) as status
-- 	from osdds o
-- )
-- select a.status, count(a.status), date_trunc('month', r.initial_harvest_date)::date as months
-- from osdds o join responses r on r.id = o.response_id
-- 	join a on a.id = o.id
-- group by a.status, months
-- order by months ASC;

-- do the things have text?
select count(o.id)
	--, o.has_title, o.has_description, o.has_keywords
from osdds o
where status_code < 400 and status_code is not null
	and o.has_keywords and o.has_title and o.has_description;
