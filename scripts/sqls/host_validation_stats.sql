with s as (
	select id, metadata_age, host
	from responses
	where host is not null and host != ''
)

select s.host, count(s.host) as number_of_hosts, avg(array_length(v.errors,1))::int as average_errors,
	max(array_length(v.errors,1))::int as max_errors,
	min(array_length(v.errors,1))::int as min_errors
from s join validations v on v.response_id = s.id
where v.valid = False
group by s.host
order by average_errors desc;