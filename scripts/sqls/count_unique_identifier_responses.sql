﻿select count(distinct response_id), current_timestamp
from unique_identifiers;


-- 219974
-- just one instance
-- 219983;"2015-11-12 23:56:05.258745+00"
-- 220100;"2015-11-13 00:36:35.57615+00"
-- 220171;"2015-11-13 00:51:36.546689+00"
-- 220251;"2015-11-13 01:15:43.507983+00"
-- 220460;"2015-11-13 01:55:57.23846+00"
-- starting a second instance
-- 220765;"2015-11-13 03:25:55.909572+00"
-- 220870;"2015-11-13 03:39:07.896522+00"
-- 221240;"2015-11-13 03:56:31.180453+00"
-- starting a third instance
-- 222196;"2015-11-13 04:41:21.076578+00"
-- starting four and five
-- 222461;"2015-11-13 04:51:46.213133+00"
-- 222903;"2015-11-13 05:10:16.861255+00"
-- 223026;"2015-11-13 05:17:22.523616+00"
-- 223566;"2015-11-13 05:51:32.016539+00"
-- 223767;"2015-11-13 06:00:55.970058+00"
-- 224139;"2015-11-13 06:18:46.601304+00"
-- 225726;"2015-11-13 07:37:56.66582+00"
-- 226421;"2015-11-13 08:17:25.585636+00"
-- 233677;"2015-11-13 15:30:46.163786+00"
-- 234629;"2015-11-13 16:27:05.530423+00"
-- 236222;"2015-11-13 18:04:10.291593+00"
-- 241220;"2015-11-13 22:50:07.848376+00"
-- plus two of the smaller ec2s
-- 241764;"2015-11-13 23:20:58.331912+00"
-- 241873;"2015-11-13 23:26:59.900368+00"
-- 241960;"2015-11-13 23:32:06.823773+00"
-- adding last two
-- 242416;"2015-11-14 00:02:51.25499+00"
-- fyi: part of the slow add speed is chunking
-- through the set already completed
-- 242727;"2015-11-14 00:28:43.476384+00"
-- 243009;"2015-11-14 00:44:17.254819+00"
-- 244070;"2015-11-14 01:53:08.423185+00"
-- 245737;"2015-11-14 03:58:48.653806+00"
-- 247794;"2015-11-14 06:01:59.044368+00"
-- 256699;"2015-11-14 17:24:30.268645+00"
-- 258263;"2015-11-14 19:04:51.250534+00"
