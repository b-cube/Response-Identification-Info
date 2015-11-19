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
-- 274413;"2015-11-15 16:57:45.338651+00"
-- 291734;"2015-11-16 20:02:40.738568+00"
-- 304190;"2015-11-17 17:24:38.451134+00"
-- 306844;"2015-11-17 21:46:02.744013+00"
-- 310200;"2015-11-17 22:40:40.618663+00"
-- 312893;"2015-11-17 22:44:41.422379+00"
-- 313654;"2015-11-17 22:45:50.306407+00"
-- 319774;"2015-11-17 22:53:48.116203+00"
-- 326942;"2015-11-17 23:02:38.501453+00"
-- 377198;"2015-11-18 00:09:12.683025+00"
-- 420757;"2015-11-18 01:36:28.294972+00"
-- 421009;"2015-11-18 01:52:09.550987+00"
-- 424043;"2015-11-18 02:02:16.46027+00"
-- 430367;"2015-11-18 02:18:17.360378+00"
-- 440929;"2015-11-18 02:48:51.049851+00"
-- 445740;"2015-11-18 03:51:37.090438+00"
-- reset
-- 445790;"2015-11-18 06:36:24.708421+00"
-- 448098;"2015-11-18 07:04:59.452368+00"
-- 464634;"2015-11-18 07:24:39.349782+00"
-- 468146;"2015-11-18 07:28:53.708364+00"
-- 493461;"2015-11-18 08:09:36.249939+00"

-- 608968;"2015-11-18 16:36:06.932385+00"
