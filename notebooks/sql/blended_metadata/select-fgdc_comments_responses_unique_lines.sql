-- number of responses containing each unique fgdc comment line
with j as (
 with i as (
     select id, response_id, tags, regexp_replace(extracted_info, E'[\n\r]+', ' | ', 'g') as the_comment
     from blended_metadatas
     where source_standard = 'ISO'
         and (extracted_info ilike '%FGDC content not mapped to ISO. From Xpath: %' or extracted_info ilike '%translated from % to %')
 )
 select id, response_id, trim(leading ' ' from unnest(string_to_array(the_comment, '|'))) as a_comment
 from i
 
)

select a_comment, count(distinct response_id) as found_in_responses
from j
where a_comment != '' and a_comment not like '%ORIGIN%' and left(a_comment, 1) != '<' and left(a_comment, 1) != '2'
group by a_comment
order by found_in_responses desc;