-- count per host
with i as (
    select id, response_id, tags, 
        trim(leading ' ' from unnest(string_to_array(regexp_replace(extracted_info, E'[\n\r]+', ' | ', 'g'), '|'))) as the_comment
    from blended_metadatas
    where source_standard = 'ISO'
        and (extracted_info ilike '%FGDC content not mapped to ISO. From Xpath: %' or extracted_info ilike '%translated from % to %')
)
select r.host, count(r.host) as host_count, the_comment
from i join responses r on r.id = i.response_id
where the_comment != '' and the_comment not like '%ORIGIN%' and left(the_comment, 1) != '<' and left(the_comment, 1) != '2'
group by the_comment, r.host
order by r.host, host_count desc, the_comment;