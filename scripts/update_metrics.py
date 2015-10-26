import glob
import sqlalchemy as sqla
from sqlalchemy.orm import sessionmaker
from sqlalchemy.orm.attributes import flag_modified
import json as js
from mpp.models import Metric

with open('big_rds.conf', 'r') as f:
    conf = js.loads(f.read())

# our connection
engine = sqla.create_engine(conf.get('connection'))
Session = sessionmaker()
Session.configure(bind=engine)
session = Session()

# it's under scripts (forgot, but ephemera)
files = glob.glob('outputs/online_refs/*.json')

for f in files[:5]:
    response_id = int(f.split('/')[-1].replace('.json', ''))
    print response_id
    with open(f, 'r') as g:
        data = js.loads(g.read())

    metric = session.query(
        Metric
    ).filter(
        Metric.response_id == response_id
    ).first()

    if not metric:
        print 'failed query', response_id
        continue

    metric.completeness.update({"extracted_online_refs": data})
    flag_modified(metric, "completeness")
    try:
        session.commit()
    except Exception as ex:
        print ex
        session.rollback()
