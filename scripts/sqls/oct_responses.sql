select (o.response_identity->'protocol')::text as protocol,
	case 
		when o.response_identity::jsonb ? 'metadata' then (o.response_identity->'metadata'->'name')::text
		when o.response_identity::jsonb ? 'service' then 
			(o.response_identity->'service'->'name')::text || ' ' || (o.response_identity->'service'->'request')::text
	else
		'Unknown'
	end as rname,
	count(o.id)
from oct_responses o
group by protocol, rname
order by protocol, rname