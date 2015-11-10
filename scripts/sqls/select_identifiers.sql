-- select extraction_type, match_type, potential_identifier, original_text
-- from unique_identifiers
-- where match_type != 'url'
-- order by match_type, extraction_type;

-- select extraction_type || ' - ' || match_type, count(id) as num
-- from unique_identifiers
-- group by extraction_type, match_type
-- order by num DESC;

select count(distinct response_id)
from unique_identifiers;