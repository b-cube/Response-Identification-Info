import json as js
import requests
from rfc3987 import parse as uparse
import sqlalchemy as sqla
from sqlalchemy.orm import sessionmaker
from datetime import datetime
import os
from lxml import etree

# load the postgres connection file
with open('big_rds.conf', 'r') as f:
    conf = js.loads(f.read())

# our connection
engine = sqla.create_engine(conf.get('connection'))
Session = sessionmaker()
Session.configure(bind=engine)
session = Session()

sketchy_sql = '''with i
as (
    select d.response_id, jsonb_array_elements(d.identity::jsonb) ident
    from identities d
    where d.identity is not null
)

select r.id, r.source_url, r.source_url_sha, r.cleaned_content, i.ident->'protocol' as protocol
from responses r join i on i.response_id = r.id
where (i.ident->>'protocol' = 'ISO' or i.ident->>'protocol' = 'FGDC') and r.format = 'xml'
limit %s
offset %s;
'''

# 26300 for fgdc
# 19700 for ISO

LIMIT = 500
END = 19700+26300
# END = 5
# LIMIT=5
for i in xrange(0, END, LIMIT):
    sql = sketchy_sql % (LIMIT, i)
    result = session.execute(sql)
    for r in result:
        if os.path.exists('outputs/online_refs/%s.json' % r['id']):
            continue
        
        try:
            xml = etree.fromstring(r['cleaned_content'].encode('utf-8'))
        except Exception as ex:
            print 'xml fail', r['id']
            continue

        if r['protocol'] == '"ISO"':
            xp = '//*/*[local-name()="MD_DigitalTransferOptions"]/*[local-name()="onLine"]/*[local-name()="CI_OnlineResource"]/*[local-name()="linkage"]/*[local-name()="URL"]'
        elif r['protocol'] == '"FGDC"':
            xp = 'distinfo/stdorder/digform/digtopt/onlinopt/computer/networka/networkr'
        else:
            print r['id'], r['protocol']
            continue
        
        refs = []
        elems = xml.xpath(xp)
        for elem in elems:
            text = elem.text
            if not text:
                continue
            
            text = text.strip()
            
            # is it a valid URL and, you know, we're here so let's 
            # just make a little HEAD request to ask
            ref = {
                "url": text,
                "checked": datetime.now().isoformat()
            }
            
            try:
                u = uparse(text, rule='URI')
                
                if u['scheme'] == 'file':
                    ref['error'] = 'file path'
                    refs.append(ref)
                    continue
            except:
                # it's not a valid scheme://location/path (http or otherwise)
                ref["error"] = 'probable local path'
                refs.append(ref)
                continue
            
            try:
                rsp = requests.head(text, timeout=30)
            except:
                ref["error"] = "HEAD request failed"
                refs.append(ref)
                continue
            
            # just get the status code
            ref['status'] = rsp.status_code
            
            refs.append(ref)
            
            
        with open('outputs/online_refs/%s.json' % r['id'], 'w') as g:
            g.write(js.dumps(refs, indent=4))