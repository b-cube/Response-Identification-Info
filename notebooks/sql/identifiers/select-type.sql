-- unique identifiers binned by type
select match_type,
    round(count(distinct response_id) / 608968. * 100., 2) as pct_of_all_responses
from unique_identifiers
group by match_type;