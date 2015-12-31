-- osdd linkrot by harvest date and status code bucket
with a as (
  select o.id, round(case when o.status_code is null then 900 else o.status_code end, -2) as status
  from osdds o
)
select a.status, count(a.status) as num, date_trunc('month', r.initial_harvest_date)::date as months
from osdds o join responses r on r.id = o.response_id
  join a on a.id = o.id
group by a.status, months
order by months ASC;