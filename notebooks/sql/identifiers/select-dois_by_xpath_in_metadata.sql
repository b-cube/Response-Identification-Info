-- doi xpaths just in the metadata (fgdc or iso)
select tag, protocol, count(distinct response_id) as num
from doi_identifiers_in_md
group by tag, protocol
order by protocol, num desc, tag;