-- bag of words (number of tokens) summary stats
select r.host, count(r.host) as records_per_host,
    avg(array_length(b.bag_of_words, 1))::int as avg_bow_size,
    min(array_length(b.bag_of_words, 1))::int as min_bow_size,
    max(array_length(b.bag_of_words, 1))::int as max_bow_size
from responses r join bags_of_words b on b.response_id = r.id
where r.host is not null and r.host != ''
group by r.host
having count(r.host) > 10
order by records_per_host desc;