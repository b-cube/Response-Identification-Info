with j as
(
	with i as
	(
		select d.response_id, jsonb_array_elements(d.identity::jsonb) ident
		from identities d
		where d.identity is not null
	), a as (
		select r.host, count(r.id) as num_per_host
		from responses r join i on i.response_id = r.id
		where i.ident->>'protocol' = 'ISO'
		group by r.host
	)

	select r.id, r.host, a.num_per_host
	from responses r join i on i.response_id = r.id
		join a on a.host = r.host
	where i.ident->>'protocol' = 'ISO'
), v as 
(
	select response_id,
		standard_name || '; ' || standard_version as the_version
	from iso_versions
)

select v.the_version, j.host, count(j.id) as num_iso_responses,
	round(count(j.id) / max(j.num_per_host)::numeric * 100.0, 2) as pct_of_iso
from responses r join v on v.response_id = r.id
	join j on j.id = r.id
-- where j.host = 'www.sitr.regione.sicilia.it'
group by v.the_version, j.host
order by j.host, pct_of_iso DESC;