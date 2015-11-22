select m.response_id as source_id, 
	u.response_id as found_id,
	m.potential_identifier, 
	m.protocol as source_protocol,
	r.source_url as source_url,
	k.source_url as found_url
from doi_identifiers_in_md m
	inner join doi_identifiers u on m.potential_identifier = u.potential_identifier
	join responses r on m.response_id = r.id
	join responses k on u.response_id = k.id
where m.potential_identifier != 'http://dx.doi.org/';