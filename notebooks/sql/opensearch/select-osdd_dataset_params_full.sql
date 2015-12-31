-- osdd dataset params with the whole string
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

select distinct kvps.value
from t, jsonb_each_text(parameters) as kvps
order by kvps.value;