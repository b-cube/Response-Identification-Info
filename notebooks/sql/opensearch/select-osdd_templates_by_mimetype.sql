-- templates by accept mimetype
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

select t.accept_type, count(t.id)
from t
group by accept_type;