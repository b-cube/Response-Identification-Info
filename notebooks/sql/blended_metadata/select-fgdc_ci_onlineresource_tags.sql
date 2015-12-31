# where do find the CI_OnlineResource elements?
select b.response_id, b.tags, count(b.tags) as num_per_tag
from blended_metadatas b
where source_standard = 'FGDC'
group by b.response_id, b.tags
order by b.response_id, num_per_tag DESC;