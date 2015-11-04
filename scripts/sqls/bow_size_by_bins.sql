-- -- PULL ALL records with an identity
-- with i
-- as (
-- 	select d.response_id, jsonb_array_elements(d.identity::jsonb) ident
-- 	from identities d
-- 	where d.identity is not null
-- )
-- 
-- select r.source_url, i.ident->'protocol' as protocol, r.metadata_age, array_length(b.bag_of_words, 1) as bow_size
-- from responses r join i on i.response_id = r.id
-- 	join bags_of_words b on b.response_id = r.id;


-- -- Let's look at the ISO/FGDC buckets over time
-- with i
-- as (
-- 	select d.response_id, jsonb_array_elements(d.identity::jsonb) ident
-- 	from identities d
-- 	where d.identity is not null
-- )
-- 
-- select extract(year from r.metadata_age) as year, avg(array_length(b.bag_of_words, 1))::int as annual_avg_bow_size
-- from responses r join i on i.response_id = r.id
-- 	join bags_of_words b on b.response_id = r.id
-- where i.ident->>'protocol' = 'FGDC' and r.metadata_age is not null
-- group by year
-- order by year;

-- -- Let's look at the ISO/FGDC buckets over time, grouped by protocol
-- with i
-- as (
-- 	select d.response_id, jsonb_array_elements(d.identity::jsonb) ident
-- 	from identities d
-- 	where d.identity is not null
-- )
-- 
-- select i.ident->'protocol' as protocol,
-- 	extract(year from r.metadata_age) as year,
-- 	avg(array_length(b.bag_of_words, 1))::int as annual_avg_bow_size
-- from responses r join i on i.response_id = r.id
-- 	join bags_of_words b on b.response_id = r.id
-- where r.metadata_age is not null
-- group by protocol, year
-- order by protocol, year;

-- -- we can't bin by year for ogc and opensearch
-- -- so just average the things
-- with i
-- as (
-- 	select d.response_id, jsonb_array_elements(d.identity::jsonb) ident
-- 	from identities d
-- 	where d.identity is not null
-- )
-- 
-- select i.ident->'protocol' as protocol, avg(array_length(b.bag_of_words, 1))::int as annual_avg_bow_size
-- from responses r join i on i.response_id = r.id
-- 	join bags_of_words b on b.response_id = r.id
-- group by protocol;


-- -- and bin by host, no identities, no dates
select r.host, count(r.host) as records_per_host,
	avg(array_length(b.bag_of_words, 1))::int as avg_bow_size,
	min(array_length(b.bag_of_words, 1))::int as min_bow_size,
	max(array_length(b.bag_of_words, 1))::int as max_bow_size
from responses r join bags_of_words b on b.response_id = r.id
where r.host is not null and r.host != ''
group by r.host
having count(r.host) > 10
order by records_per_host desc;



	