
-- -- to get the total
-- with i
-- as (
--     select d.response_id, jsonb_array_elements(d.identity::jsonb) ident
--     from identities d
--     where d.identity is not null
-- )
-- 
-- --select r.id, r.source_url, r.initial_harvest_date, i.ident->'protocol' as protocol
-- select count(distinct r.id) as total
-- from responses r join i on i.response_id = r.id
-- where i.ident->>'protocol' = 'FGDC' or i.ident->>'protocol' = 'ISO';

-- to get things with a date
-- select count(r.id)
-- from responses r
-- where metadata_age is not null;


-- -- bin by date
-- select date_trunc('month', metadata_age)::date as mdate, count(metadata_age), 
-- from responses r
-- where metadata_age is not null
-- group by mdate
-- order by mdate ASC;

with i
as (
    select d.response_id, jsonb_array_elements(d.identity::jsonb) ident
    from identities d
    where d.identity is not null
)
select mdate, cnt --, round(100.0*(cnt/(sum(cnt) OVER ())), 2) as pct
from (
	select date_trunc('month', metadata_age)::date as mdate,
		count(*) as cnt
	from responses r join i on i.response_id = r.id
	where (i.ident->>'protocol' = 'ISO' or i.ident->>'protocol' = 'FGDC') and r.metadata_age is not null
	group by mdate
) foo
order by mdate asc;