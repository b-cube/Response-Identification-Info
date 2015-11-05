-- select *
-- from metadata_completeness
-- limit 2;

with a 
as (
	select response_id, j.*
	from metadata_completeness, 
		jsonb_to_recordset(wordcounts::jsonb)
		as j(
			lineage jsonb,
			data_quality jsonb,
			attributes jsonb
		)
)

select 