-- how many of those search urls aren't wordpress osdd links
with t 
as (
    select o.id, o.url, x.*
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

select distinct t.search_url, t.accept_type, 
    t.url,
    trim(both '"' from (v.value->'link_url')::text) as search_rel_osdd
from t,
    jsonb_to_recordset(responses) as y(
        search_response jsonb
    ), 
    jsonb_array_elements(search_response->'search_rels') v
where search_response->>'status' != '{}' and search_response->>'search_rels' != '{}'
    and position(trim(both '"' from (v.value->'link_url')::text) in t.url) < 1
    and trim(both '"' from (v.value->'link_url')::text) != 'https://wordpress.com/opensearch.xml'
;