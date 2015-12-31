-- where in the xml do we find the json?
select x.xpath, count(x.xpath) as xpaths 
from responses r 
    join xml_with_jsons x on x.file = r.source_url_sha
group by x.xpath
order by xpaths DESC;