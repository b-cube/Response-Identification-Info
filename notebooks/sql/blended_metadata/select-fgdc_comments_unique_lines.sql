# get the unique comment lines
with b as (
    with i as (
        select id, response_id, tags, regexp_replace(extracted_info, E'[\n\r]+', ' | ', 'g') as the_comment, 'not mapped' as code
        from blended_metadatas
        where source_standard = 'ISO'
            and extracted_info ilike '%FGDC content not mapped to ISO. From Xpath: %'

        union all

        select id, response_id, tags, regexp_replace(extracted_info, E'[\n\r]+', ' | ', 'g') as the_comment, 'translated' as code
        from blended_metadatas
        where source_standard = 'ISO'
            and extracted_info ilike '%translated from % to %'
    )
    -- select id, response_id, trim(leading ' ' from unnest(string_to_array(the_comment, '|')))
    select trim(leading ' ' from unnest(string_to_array(the_comment, '|'))) as a_comment, 
        count(trim(leading ' ' from unnest(string_to_array(the_comment, '|')))) as comment_count
    from i
    group by a_comment
)
select a_comment, comment_count
from b
where left(a_comment, 1) != '<' and a_comment not ilike '%%ORIGIN%%'
order by comment_count DESC;