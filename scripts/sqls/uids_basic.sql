-- select match_type, round(count(distinct response_id) / 608968. * 100., 2) as pct_of_all_responses
-- from unique_identifiers
-- group by match_type;

-- select valid, cnt, 100.0*cnt/(sum(cnt) OVER ()) as pct
-- from (select valid, count(*) as cnt from validations group by valid) foo;
-- 
-- select count(distinct response_id) 
-- from unique_identifiers;

-- with i as (
-- 	select d.response_id, (e.value->'protocol')::text as ident
-- 	from identities d, jsonb_array_elements(d.identity::jsonb) e
-- 	where d.identity is not null
-- )
-- 
-- select trim(both '"' from i.ident) as protocol, r.host, count(u.potential_identifier) as num
-- from responses r 
-- 	join i on i.response_id = r.id
-- 	inner join unique_identifiers u on u.response_id = r.id
-- where u.match_type = 'doi'
-- group by protocol, r.host
-- order by num desc;

-- with i as (
-- 	select d.response_id, (e.value->'protocol')::text as ident
-- 	from identities d, jsonb_array_elements(d.identity::jsonb) e
-- 	where d.identity is not null
-- ), j as 
-- (
-- 	select r.id, r.host, trim(both '"' from i.ident) as protocol
-- 	from responses r join i on i.response_id = r.id
-- ), k as (
-- 	select j.host, j.protocol, count(distinct j.id) as total
-- 	from j 
-- 	group by j.host, j.protocol
-- )
-- 
-- select j.protocol, j.host, count(distinct j.id) as count_w_doi,
-- 	round(count(distinct j.id) / max(k.total)::numeric * 100., 2) as pct_w_doi,
-- 	max(k.total) as total_responses
-- from j 
-- 	inner join unique_identifiers u on u.response_id = j.id
-- 	join k on k.host = j.host and k.protocol = j.protocol
-- where u.match_type = 'doi'
-- group by j.protocol, j.host
-- order by j.host, j.protocol, pct_w_doi desc;

-- with j as (
-- 	with i as 
-- 	(
-- 		select response_id, count(potential_identifier) as potentials
-- 		from unique_identifiers
-- 		group by response_id
-- 	)
-- 	select r.id, r.source_url, i.potentials, u.potential_identifier, u.match_type
-- 	from responses r 
-- 		join i on i.response_id = r.id
-- 		join unique_identifiers u on u.response_id = r.id
-- 	where i.potentials = 1 and u.match_type = 'url'
-- )
-- select count(j.id) as num
-- from j
-- where j.source_url = j.potential_identifier;


with i as (
	select d.response_id, (e.value->'protocol')::text as ident
	from identities d, jsonb_array_elements(d.identity::jsonb) e
	where d.identity is not null
), j as 
(
	select r.id, r.host, trim(both '"' from i.ident) as protocol
	from responses r join i on i.response_id = r.id
), k as (
	select j.host, j.protocol, count(distinct j.id) as total
	from j 
	group by j.host, j.protocol
)

select j.protocol, j.host, u.match_type, count(distinct j.id) as count_w_type,
	round(count(distinct j.id) / max(k.total)::numeric * 100., 2) as pct_w_type,
	max(k.total) as total_responses
from j 
	inner join unique_identifiers u on u.response_id = j.id
	join k on k.host = j.host and k.protocol = j.protocol
where u.match_type != 'url' and k.total > 10
group by j.protocol, j.host, u.match_type
order by j.host, j.protocol, u.match_type, pct_w_type desc;

