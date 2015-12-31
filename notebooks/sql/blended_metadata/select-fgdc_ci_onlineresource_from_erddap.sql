# is it all from erddap server?
select r.host, count(r.host), case when r.source_url ilike '%erddap%' then 'ERDDAP' else 'OTHER' end as is_it_dap
from blended_metadatas b join responses r on r.id = b.response_id
where source_standard = 'FGDC' and tags ilike '%networka%'
group by is_it_dap, r.host
order by r.host DESC;