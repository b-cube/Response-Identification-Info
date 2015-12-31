-- full unqualified xpath for an element referencing an inaccessible codelist
with c as 
(
    select id, codelist
    from codelist_statuses
    where status > 200
), x as
(
    select r.id as response_id, r.host, r.metadata_age,
        lower(replace(left(i.codelist, strpos(i.codelist, '#')), '#', '')) as codelist,
        i.xpath, string_to_array(i.xpath, '/') as xpath_arr
    from codelists i join responses r on r.source_url_sha = i.file
)
select count(distinct x.response_id) as num_responses, 
    x.xpath
from x join c on c.codelist = x.codelist
group by x.xpath
order by num_responses DESC;