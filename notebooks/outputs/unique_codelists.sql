with uris as (
    select left(codelist, position('#' in codelist)) as uri
    from codelists
)

select uri, count(uri)
from uris
group by uri
order by uri;