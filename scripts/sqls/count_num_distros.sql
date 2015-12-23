with m as (
	select response_id, count(online) as num_per_response
	from metadata_completeness,
		json_array_elements(distributions->'online') online
	group by response_id
)
select sum(m.num_per_response) as num_hrefs
from responses r join m on m.response_id = r.id
where r.host is not null;