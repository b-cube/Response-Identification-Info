-- distribution applicationProfiles
select element_value, count(element_value) as num_elems
from iso_onlineresources
where element_key = 'application_profile' and tags ilike '%/distributionInfo%'
group by element_key, element_value
order by element_key, element_value, num_elems DESC;