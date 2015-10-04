import os
import glob
import json

content_types = set()
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
        content_types.add(content_type)

with open('unique_content_types.txt', 'w') as f:
    f.write('\n'.join(content_types))
