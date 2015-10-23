select octet_length(cleaned_content::text) / 1048576.0 as mb
from responses
where format = 'xml'
order by mb desc;