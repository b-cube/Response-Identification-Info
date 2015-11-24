with j as (
	select response_id, match_type, count(potential_identifier)
	from unique_identifiers
	where response_id = 313708
	or response_id = 398877
	or response_id = 402232
	or response_id = 436829
	or response_id = 481130
	or response_id = 528861
	or response_id = 552613
	or response_id = 575004
	or response_id = 580997
	or response_id = 658072
	or response_id = 692544
	or response_id = 692862
	or response_id = 786259
	group by response_id, match_type
)
select r.id, r.host, j.match_type, j.count
from responses r join j on j.response_id = r.id;
