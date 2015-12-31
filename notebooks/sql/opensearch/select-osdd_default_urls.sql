-- osdds with default urls
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

select round((default_response->'status')::text::int, -2) as code,
    t.accept_type,
    count(distinct t.default_url) as num
from t,
    jsonb_to_recordset(responses) as y(
        search_response jsonb,
        example_response jsonb,
        default_response jsonb
    )
where default_response->>'status' != '{}'
group by code, t.accept_type
order by code asc, t.accept_type
;