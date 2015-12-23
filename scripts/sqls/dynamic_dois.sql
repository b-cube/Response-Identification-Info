select r.source_url, u.potential_identifier, u.tag
from responses r join unique_identifiers u on u.response_id = r.id
where u.match_type = 'doi' and  u.potential_identifier ilike '%?%';

-- note: these look like partial urls (thanks regex!)
--       with query params unrelated to the doi
--       but i am not checking today