select count(*), current_timestamp
from validations;
-- 
-- select valid, cnt, 100.0*cnt/(sum(cnt) OVER ()) as pct
-- from (select valid, count(*) as cnt from validations group by valid) foo;

-- 149362;"2015-10-30 03:55:16.824369+00"
-- 149385;"2015-10-30 03:56:11.951693+00"
-- 149600;"2015-10-30 04:10:04.220553+00"
-- 149712;"2015-10-30 04:18:05.423655+00"
-- 151095;"2015-10-30 05:49:54.572704+00"