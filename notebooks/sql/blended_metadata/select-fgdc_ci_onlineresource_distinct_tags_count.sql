select b.tags, count(b.response_id) as num_per_tag
from blended_metadatas b
where source_standard = 'FGDC'
group by b.tags
order by num_per_tag DESC;