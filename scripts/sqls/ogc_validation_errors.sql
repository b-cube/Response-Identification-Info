-- binned by error string (after stdin)
-- with y as (
-- 	with x as (
-- 		select o.response_id, unnest(v.errors) as error
-- 		from validations v
-- 			join ogc_tokens o on o.response_id = v.response_id
-- 	)
-- 	select x.response_id, trim(both ' ' from right(x.error, length(x.error) - strpos(x.error, '):') - 2)) as thing
-- 	from x
-- )
-- select y.thing, count(distinct y.response_id) as num_responses_affected
-- from y
-- group by thing
-- order by num_responses_affected DESC;

with y as (
	with x as (
		select o.response_id, unnest(v.errors) as error
		from validations v
			join ogc_tokens o on o.response_id = v.response_id
	), j as (
		select x.response_id, trim(both ' ' from right(x.error, length(x.error) - strpos(x.error, '):') - 2)) as thing
		from x
	)
	select j.response_id,
		case 
			when thing like 'no declaration found for element %' then 'no declaration found for element'
			when thing like 'attribute % is not declared for element %' then 'attribute is not declared for element'
-- 			when thing like 'global element % declared more than once' or thing like 'global type % declared more than once or also declared as simpleType' then 'global element delcared more than once'
			when thing like 'value % does not match regular expression %' then 'value does not match regular expression'
			when thing like 'value % not in enumeration' then 'value not in enumeration'
			when thing like 'element % is not allowed for content model' then 'element is not allowed for content model'
			when thing like 'global % declared more than once%' then 'global OBJECT declared more than once'
			when thing like 'unable to open file %' then 'unable to open file'
			else thing end as the_error
	from j
	
)
select y.the_error, count(distinct y.response_id) as num_responses_affected
from y
group by y.the_error
order by num_responses_affected DESC;