-- unique codelists that are likely links
with a as
(
    select lower(replace(left(codelist, strpos(codelist, '#')), '#', '')) as codelist
    from codelists
)
select distinct codelist
from a
where codelist ilike 'http%'
order by codelist;