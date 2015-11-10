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
select distinct r.response_id
from response_codelists r join codelist_statuses c on c.codelist = r.codelist
where c.status != 200;