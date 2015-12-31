-- get the iso function codes in a distribution element
select element_value, count(element_value) as num_elems
from iso_onlineresources
where element_key = 'function_code' and tags ilike '%/distributionInfo%'
group by element_key, element_value
order by element_key, element_value, num_elems DESC;