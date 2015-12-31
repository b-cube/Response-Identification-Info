-- count of responses with just the harvest url as identifier
with j as (
    with i as 
    (
        select response_id, count(potential_identifier) as potentials
        from unique_identifiers
        group by response_id
    )
    select r.id, r.source_url, i.potentials, u.potential_identifier, u.match_type
    from responses r 
        join i on i.response_id = r.id
        join unique_identifiers u on u.response_id = r.id
    where i.potentials = 1 and u.match_type = 'url'
)
--select j.id, j.source_url
select count(j.id) as num
from j
where j.source_url = j.potential_identifier;