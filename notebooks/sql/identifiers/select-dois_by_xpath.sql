-- xpaths for where we find the dois
select tag, count(potential_identifier) as num
from unique_identifiers
where match_type = 'doi'
group by tag
order by num desc;