-- let's look at variability across the children, ie is "download" used for every string?
with j as (
    select response_id, id, lower(element_value) as eval, element_key
    from iso_onlineresources
    where tags ilike '%/distributionInfo%'
)
select j.eval, array_agg(distinct j.element_key) as keys, count(j.id) as num_vals
from j
group by j.eval
having array_length(array_agg(distinct j.element_key), 1) > 1 
    and array_agg(distinct j.element_key)::text[] <> ARRAY['description', 'name']
order by num_vals DESC;