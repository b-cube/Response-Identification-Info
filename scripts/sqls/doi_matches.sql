with u as 
(
	select id, response_id, potential_identifier
	from unique_identifiers
	where match_type = 'doi'
)

select a.potential_identifier, a.response_id, u.response_id
from unique_identifiers a 
	left outer join u 
		on u.potential_identifier = a.potential_identifier and u.response_id != a.response_id
;