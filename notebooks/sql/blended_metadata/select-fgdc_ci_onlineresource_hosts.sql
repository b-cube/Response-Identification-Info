select distinct r.host, date_trunc('month', r.metadata_age)::date as date_bin
from blended_metadatas b join responses r on r.id = b.response_id
where source_standard = 'FGDC'
order by r.host DESC, date_bin ASC;