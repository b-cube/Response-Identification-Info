from datetime import datetime
import json as js  # name conflict with sqla
import sqlalchemy as sqla
from sqlalchemy.orm import sessionmaker
from sqlalchemy import and_, or_, not_
from mpp.models import Response
from mpp.models import BagOfWords
from semproc.timed_command import TimedCmd

'''
wrapper for the singleton bag of words cli
mostly to kill any wonky regex

note: if the process is terminated, the bag
is empty - no partial resultset
'''


conf = '../local/big_rds.conf'
cmd = 'python word_count_cli.py -c %(config)s -i %(response_id)s'
timeout = 120  # in seconds, more than 2minutes seems like an eternity

with open(conf, 'r') as f:
    config = js.loads(f.read())

# our connection
engine = sqla.create_engine(config.get('connection'))
Session = sessionmaker()
Session.configure(bind=engine)
session = Session()

clauses = [
    Response.format == 'xml',
    not_(or_(
        Response.cleaned_content.startswith("<rdf"),
        Response.cleaned_content.startswith("<RDF")
    ))
]

# get a count of the xml responses
TOTAL = session.query(Response).filter(
    and_(*clauses)).count()
START = 0
LIMIT = 100

with open('bow_fails.txt', 'w') as f:
    f.write('bag of words failures\n\n'.format(datetime.now().isoformat()))

for i in xrange(START, TOTAL, LIMIT):
    response_ids = session.query(Response.id).filter(
        and_(*clauses)).limit(LIMIT).offset(i).all()

    for response_id, in response_ids:
        tc = TimedCmd(cmd % {"config": conf, "response_id": response_id})
        try:
            status, output, error = tc.run(timeout)
        except:
            print 'failed extraction: ', response_id
            with open('bow_fails.txt', 'a') as f:
                f.write('extract fail: \n'.format(response_id))
            continue

        if error:
            print 'error from cli: ', response_id, error
            with open('bow_fails.txt', 'a') as f:
                f.write('cli fail: \n'.format(response_id))
            continue

        bag = BagOfWords(
            generated_on=datetime.now(),
            bag_of_words=output.split(),
            method="basic",
            response_id=response_id
        )

        try:
            session.add(bag)
            session.commit()
        except Exception as ex:
            print 'failed commit: ', response_id, ex
            with open('bow_fails.txt', 'a') as f:
                f.write('commit fail: \n'.format(response_id))
            session.rollback()

session.close()
