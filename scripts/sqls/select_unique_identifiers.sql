-- -- average number of things per response
-- with i as 
-- (
-- 	select response_id, match_type, count(potential_identifier) as num
-- 	from unique_identifiers
-- 	group by response_id, match_type
-- )
-- 
-- select match_type, round(avg(num), 2) avg_ids
-- from i
-- group by match_type
-- order by avg_ids DESC;

-- how many have one identifier and it's a url and it's the source url?
-- with j as (
-- 	with i as 
-- 	(
-- 		select response_id, count(potential_identifier) as potentials
-- 		from unique_identifiers
-- 		group by response_id
-- 	)
-- 	select r.id, r.source_url, i.potentials, u.potential_identifier, u.match_type
-- 	from responses r 
-- 		join i on i.response_id = r.id
-- 		join unique_identifiers u on u.response_id = r.id
-- 	where i.potentials = 1 and u.match_type = 'url'
-- )
-- select j.id, j.source_url
-- from j
-- where j.source_url = j.potential_identifier;

-- with i as 
-- (
-- 	select response_id, tag, match_type, count(potential_identifier) as num
-- 	from unique_identifiers
-- 	where match_type != 'url' and tag != ''
-- 		and (
-- 			tag ilike 'MI_Metadata/%'
-- 			or tag ilike 'MD_Metadata/%'
-- 			or tag ilike 'metadata/%'
-- 			or tag ilike 'OAI-PMH/%'
-- 			or tag ilike 'SensorML/%'
-- 			or tag ilike '%_Capabilities/%'
-- 			or tag ilike 'Capabilities/%'
-- 			or tag ilike 'DescribeSensorResponse/%'
-- 			or tag ilike 'DIF/%'
-- 			or tag ilike 'DS_Series/%'
-- 			or tag ilike 'eml/%'
-- 			or tag ilike 'GetRecordByIdResponse/%'
-- 			or tag ilike 'GetRecordsResponse/%'
-- 		)
-- 	group by response_id, tag, match_type
-- )
-- 
-- select tag, match_type, round(avg(num), 2) as avg_ids
-- from i
-- group by tag, match_type
-- order by tag, avg_ids DESC;


select tag, match_type, count(potential_identifier) as num
from unique_identifiers
where match_type != 'url' and tag != ''
	and (
		tag ilike 'MI_Metadata/%'
		or tag ilike 'MD_Metadata/%'
		or tag ilike 'metadata/%'
		or tag ilike 'OAI-PMH/%'
		or tag ilike 'SensorML/%'
		or tag ilike '%_Capabilities/%'
		or tag ilike 'Capabilities/%'
		or tag ilike 'DescribeSensorResponse/%'
		or tag ilike 'DIF/%'
		or tag ilike 'DS_Series/%'
		or tag ilike 'eml/%'
		or tag ilike 'GetRecordByIdResponse/%'
		or tag ilike 'GetRecordsResponse/%'
	)
group by tag, match_type
order by tag, num DESC;