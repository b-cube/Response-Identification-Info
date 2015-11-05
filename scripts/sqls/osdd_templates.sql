-- osdd template queries

-- with a as (
-- 	select id, 
-- 		case when url_templates is not null and url_templates::text != '[]'::text then True else False end as has_templates
-- 	from osdds
-- )
-- select has_templates, cnt, round(100.0*cnt/(sum(cnt) OVER ()), 2) as pct
-- from (select has_templates, count(*) as cnt from a group by has_templates) foo;

-- -- let's see about what has what kind of urls
-- with t 
-- as (
-- 	select o.id, x.*
-- 	from osdds o, 
-- 		jsonb_to_recordset(o.url_templates::jsonb) 
-- 			as x(
-- 				default_url text,
-- 				search_url text,
-- 				example_url text,
-- 				responses jsonb,
-- 				parameters jsonb,
-- 				param_defs jsonb,
-- 				accept_type text
-- 			)
-- 	where url_templates is not null and url_templates::text != '[]'::text
-- )
-- 
-- select distinct kvps
-- from t,
-- 	jsonb_each_text(parameters) as kvps
-- order by kvps;
--- - where parameters ? 'dataset';
-- -- where default_url is not null and default_url != '';

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
				accept_type text
			)
	where url_templates is not null and url_templates::text != '[]'::text
)

select distinct t.search_url, t.accept_type, search_response->'status' as status_code, 
	search_response->'total' as total, 
	search_response->'subset' as subset, 
	search_response->'has_content' as has_content, 
	search_response->'error' as error,
	case when search_response->>'search_rels' != '{}' then True else False end as has_nested_search_urls
from t,
	jsonb_to_recordset(responses) as y(
		search_response jsonb,
		example_response jsonb,
		default_response jsonb
	)
where search_response->>'status' != '{}'
;
