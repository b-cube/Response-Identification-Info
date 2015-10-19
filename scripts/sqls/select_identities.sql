-- query by protocol
-- with i
-- as (
-- 	select d.response_id, jsonb_array_elements(d.identity::jsonb) ident
-- 	from identities d
-- 	where d.identity is not null
-- )
-- 
-- select r.source_url, i.ident->'protocol' as protocol
-- from responses r join i on i.response_id = r.id
-- where i.ident->>'protocol' = 'FGDC';


-- group by protocol
with i
as (
	select d.response_id, jsonb_array_elements(d.identity::jsonb) ident
	from identities d
	where d.identity is not null
)

select i.ident->'protocol' as protocol, count(i.ident->'protocol') as cnt
from i
group by i.ident->'protocol';