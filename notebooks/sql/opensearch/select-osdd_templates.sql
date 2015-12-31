-- osdds with templates
with a as (
    select id, 
        case when url_templates is not null and url_templates::text != '[]'::text then True else False end as has_templates
    from osdds
)
select has_templates, cnt, round(100.0*cnt/(sum(cnt) OVER ()), 2) as pct
from (select has_templates, count(*) as cnt from a group by has_templates) foo;