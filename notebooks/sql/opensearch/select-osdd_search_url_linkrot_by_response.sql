-- search url linkrot by response count
with t 
as (
    select o.id, x.*
    from osdds o, 
        jsonb_to_recordset(o.url_templates::jsonb) 
            as x(
                search_url text,
                example_url text,
                responses jsonb,
                accept_type text
            )
    where url_templates is not null and url_templates::text != '[]'::text
)
select count(distinct t.id) as responses
from t,
    jsonb_to_recordset(responses) as y(
        search_response jsonb,
        example_response jsonb,
        default_response jsonb
    )
where search_response->>'status' != '{}'
    and round((search_response->'status')::text::int, -2) = 200
;