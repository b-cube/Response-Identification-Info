-- identifiers by type for other known EO xml types
with i as 
(
    select response_id, tag, match_type, count(potential_identifier) as num
    from unique_identifiers
    where match_type != 'url' and tag != ''
        and (
            tag ilike 'MI_Metadata/%%'
            or tag ilike 'MD_Metadata/%%'
            or tag ilike 'metadata/%%'
            or tag ilike 'OAI-PMH/%%'
            or tag ilike 'SensorML/%%'
            or tag ilike '%%_Capabilities/%%'
            or tag ilike 'Capabilities/%%'
            or tag ilike 'DescribeSensorResponse/%%'
            or tag ilike 'DIF/%%'
            or tag ilike 'DS_Series/%%'
            or tag ilike 'eml/%%'
            or tag ilike 'GetRecordByIdResponse/%%'
            or tag ilike 'GetRecordsResponse/%%'
        )
    group by response_id, tag, match_type
)

select tag, match_type, round(avg(num), 2) as avg_ids
from i
group by tag, match_type
order by tag, avg_ids DESC;