-- osdd template queries

-- with a as (
-- 	select id, 
-- 		case when url_templates is not null and url_templates::text != '[]'::text then True else False end as has_templates
-- 	from osdds
-- )
-- select has_templates, cnt, round(100.0*cnt/(sum(cnt) OVER ()), 2) as pct
-- from (select has_templates, count(*) as cnt from a group by has_templates) foo;

-- let's see about what has what kind of urls
with t 
as (
	select o.id, x.*
	from osdds o, 
		jsonb_to_recordset(o.url_templates::jsonb) 
			as x(
				default_url text,
				search_url text,
				example_url text,
				responses jsonb,
				parameters jsonb,
				param_defs jsonb,
				accept_type text
			)
	where url_templates is not null and url_templates::text != '[]'::text
)

select *
from t;

