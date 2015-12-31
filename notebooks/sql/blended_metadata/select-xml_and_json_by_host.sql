-- count per host of xml with json
select r.host, count(r.source_url) as responses_with_json 
from responses r 
    join xml_with_jsons x on x.file = r.source_url_sha
group by r.host
order by responses_with_json DESC;