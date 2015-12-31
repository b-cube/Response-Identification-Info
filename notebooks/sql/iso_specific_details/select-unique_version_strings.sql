-- unique standard name and version strings
select distinct standard_name, standard_version
from iso_versions
order by standard_name, standard_version;