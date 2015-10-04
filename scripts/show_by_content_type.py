import os
import glob
import json

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
    if content_type and 'shockwave' in content_type:
        print data.get('url'), content_type, data.get('tstamp')
        
