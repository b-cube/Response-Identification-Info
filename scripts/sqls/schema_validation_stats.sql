with s as (
	select id, metadata_age, schemas
	from responses
	where schemas is not null and schemas != '{}'
)

select array_to_string(s.schemas, ' | ') as schema_set, count(s.schemas) as number_of_schemas, avg(array_length(v.errors,1))::int as average_errors,
	max(array_length(v.errors,1))::int as max_errors,
	min(array_length(v.errors,1))::int as min_errors
from s join validations v on v.response_id = s.id
where v.valid = False
group by s.schemas
order by average_errors desc;