import os
import glob
import json
from dateutil.parser import *
from datetime import datetime

content_types = {}
for f in glob.glob('/Users/sparky/Documents/solr_responses/solr_20150922_docs/*.json'):
    with open(f, 'r') as g:
        data = json.loads(g.read())

    headers = data.get('response_headers', [])
    if not headers:
        continue

    headers = dict(
        (k.strip().lower(), v.strip()) for k, v in (h.split(':', 1) for h in headers)
    )
    content_type = headers.get('content-type', '')
    if content_type:
        d = content_types.get(content_type, [])
        d.append(parse(data.get('tstamp')))
        # content_types.add(content_type)
        content_types[content_type] = d

with open('unique_content_types_by_date.txt', 'w') as f:
    for k, v in content_types.iteritems():
        f.write('|'.join([k, min(v).isoformat(), max(v).isoformat()])+'\n')
