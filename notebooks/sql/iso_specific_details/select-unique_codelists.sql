-- unique iso codelist references
with a as
(
    select replace(left(codelist, strpos(codelist, '#')), '#', '') as codelist
    from codelists
)
select distinct codelist
from a
where codelist != ''
order by codelist;