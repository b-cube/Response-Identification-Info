-- select s.status_code, s.schema, r.id, r.source_url, r.schemas
-- from responses r
-- 	join schema_status s on s.schema = ANY(r.schemas)
-- where r.format = 'xml' and r.schemas is not null and r.schemas != '{}';

-- how many responses contain a reference to a linkrot schema
select s.status_code, count(distinct r.id) as num_responses --, r.source_url, r.schemas
from responses r
	join schema_status s on s.schema = ANY(r.schemas)
where r.format = 'xml' and r.schemas is not null and r.schemas != '{}'
	and s.status_code >= 400
group by s.status_code;