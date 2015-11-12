-- get the codelist urls
-- "http://www.ngdc.noaa.gov/metadata/published/xsd/schema/resources/Codelist/gmxCodelists.xml#gmd:CI_DateTypeCode"

-- with a as
-- (
-- 	select replace(left(codelist, strpos(codelist, '#')), '#', '') as codelist
-- 	from codelists
-- )
-- select distinct codelist
-- from a
-- where codelist ilike 'http%'
-- -- where codelist != ''
-- order by codelist;

-- need to convert the original upload to response id, tidied codelist
-- and just a simple contains (not one per reference in a record)
-- with j as 
-- (
-- 	with c as 
-- 	(
-- 		select distinct file as sha_id,
-- 			lower(replace(left(codelist, strpos(codelist, '#')), '#', '')) as codelist
-- 		from codelists
-- 		where codelist ilike 'http%'
-- 	)
-- 	select r.id as response_id, c.codelist as codelist
-- 	from responses r join c on c.sha_id = r.source_url_sha
-- 	where c.codelist != ''
-- )
-- select * into response_codelists from j;

-- -- how many responses contain a bad codelist reference?
-- select count(distinct r.response_id)
-- from response_codelists r join codelist_statuses c on c.codelist = r.codelist
-- where c.status != 200;

-- where are these code lists
-- select distinct xpath
-- from codelists;

-- -- the which types of things are affected by inaccessible codelists?
-- -- don't need to worry about redirects (aren't any)
-- -- starting with a group by last xpath elem
-- with c as 
-- (
-- 	select id, codelist
-- 	from codelist_statuses
-- 	where status > 200
-- ), x as
-- (
-- 	select r.id as response_id, r.host, r.metadata_age,
-- 		lower(replace(left(i.codelist, strpos(i.codelist, '#')), '#', '')) as codelist,
-- 		i.xpath, string_to_array(i.xpath, '/') as xpath_arr
-- 	from codelists i join responses r on r.source_url_sha = i.file
-- )
-- select count(x.response_id) as num_responses, 
-- 	-- x.host, 
-- 	-- x.metadata_age::date, 
-- 	-- c.codelist,
-- 	-- x.xpath, 
-- 	x.xpath_arr[array_upper(xpath_arr, 1)] as last_x
-- from x join c on c.codelist = x.codelist
-- --order by x.codelist
-- group by last_x
-- order by num_responses DESC;

-- -- and grouped by the full xpath (just in case)
with c as 
(
	select id, codelist
	from codelist_statuses
	where status > 200
), x as
(
	select r.id as response_id, r.host, r.metadata_age,
		lower(replace(left(i.codelist, strpos(i.codelist, '#')), '#', '')) as codelist,
		i.xpath, string_to_array(i.xpath, '/') as xpath_arr
	from codelists i join responses r on r.source_url_sha = i.file
)
select count(distinct x.response_id) as num_responses, 
	-- x.host, 
	-- x.metadata_age::date, 
	-- c.codelist,
	x.xpath
from x join c on c.codelist = x.codelist
--order by x.codelist
group by x.xpath
order by num_responses DESC;
