-- select a.potential_identifier, a.response_id, b.response_id
-- from unique_identifiers a 
-- 	left outer join unique_identifiers b on b.potential_identifier = a.potential_identifier
-- where a.match_type = 'doi' and a.response_id != b.response_id;

-- let's just cut out a bunch of things we're not interested in
-- select * into doi_identifiers from unique_identifiers where match_type = 'doi';

select a.potential_identifier, a.response_id, b.response_id
from doi_identifiers a
	left outer join doi_identifiers b on b.potential_identifier = a.potential_identifier
where b.response_id != a.response_id;