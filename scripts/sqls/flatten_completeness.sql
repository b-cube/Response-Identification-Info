with i as 
(
	select d.response_id, jsonb_array_elements(d.identity::jsonb) ident
	from identities d
	where d.identity is not null
)
select r.source_url, r.metadata_age, i.ident->'protocol' as protocol, 
	m.completeness->'lineage' as has_lineage,
	m.completeness->'data_quality' as has_quality,
	m.completeness->'metadata_ref' as has_metadata,
	m.completeness->'data_quality_bow' as dataquality_wordcount,
	m.completeness->'lineage_bow' as lineage_wordcount,
	m.completeness->'distribution'->'online_refs' as online_distributions,
	m.completeness->'distribution'->'offline_refs' as offline_distributions,
	m.completeness->'distribution'->'nondigital_refs' as nondigital_distributions
from responses r 
	right outer join metadata_age_metrics as m on m.response_id = r.id
	join i on i.response_id = r.id;