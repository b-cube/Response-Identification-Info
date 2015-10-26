select count(id)
from metadata_age_metrics
where completeness::jsonb->>'extracted_online_refs' != '[]';