select a.potential_identifier, a.response_id, b.response_id
from unique_identifiers a 
	left outer join unique_identifiers b on b.potential_identifier = a.potential_identifier
where a.match_type = 'doi' and a.response_id != b.response_id;