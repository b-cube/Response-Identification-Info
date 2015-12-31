# counts of elements by the two patterns seen for the fgdc mapping to a comment string
with i as (
    select id, response_id, tags, extracted_info, 'not mapped' as code
    from blended_metadatas
    where source_standard = 'ISO'
        and extracted_info ilike '%FGDC content not mapped to ISO. From Xpath: %'

    union all
    
    select id, response_id, tags, extracted_info, 'translated' as code
    from blended_metadatas
    where source_standard = 'ISO'
        and extracted_info ilike '%translated from % to %'
)
select tags, code, count(code) as num_per_tag
from i
group by tags, code
order by tags, num_per_tag;