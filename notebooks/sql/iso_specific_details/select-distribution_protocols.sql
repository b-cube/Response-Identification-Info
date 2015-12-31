-- looking at the protocols in the distribution elements
select element_value, count(element_value) as num_elems
from iso_onlineresources
where element_key = 'protocol' and tags ilike '%/distributionInfo%'
group by element_key, element_value
order by element_key, element_value, num_elems DESC;