-- dois by host
with k as (
    select host, count(distinct id) as total
    from responses 
    group by host
)
select j.host, count(distinct j.id) as count_w_doi,
    round(count(distinct j.id) / max(k.total)::numeric * 100., 2) as pct_w_doi,
    max(k.total) as total_responses
from responses j 
    inner join unique_identifiers u on u.response_id = j.id
    join k on k.host = j.host
where u.match_type = 'doi' and k.total > 10
group by j.host
order by pct_w_doi desc;