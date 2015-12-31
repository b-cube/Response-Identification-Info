-- distribution protocols by host
with j as 
(
    select response_id, element_value, count(id) as num_values
    from iso_onlineresources
    where element_key = 'protocol'
        and tags ilike '%/distributionInfo%'
    group by element_key, response_id, element_value
)
select element_value, 
    r.host,
    count(distinct j.response_id) as num_responses
from j join responses r on j.response_id = r.id
group by r.host, element_value
order by element_value, r.host, num_responses DESC;