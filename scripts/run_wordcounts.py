from datetime import datetime
import json as js  # name conflict with sqla
import sqlalchemy as sqla
from sqlalchemy.orm import sessionmaker
from sqlalchemy import and_, or_, not_
from mpp.models import Response
from mpp.models import BagOfWords
from semproc.timed_command import TimedCmd
from optparse import OptionParser

'''
wrapper for the singleton bag of words cli
mostly to kill any wonky regex

note: if the process is terminated, the bag
is empty - no partial resultset
'''


def main():

    op = OptionParser()
    op.add_option('--start', '-s', default='0')
    op.add_option('--end', '-e', default='100')
    op.add_option('--interval', '-i', default='100')

    options, arguments = op.parse_args()

    START = int(options.start)
    TOTAL = int(options.end)
    LIMIT = int(options.interval)

    conf = 'big_rds.conf'
    cmd = 'python word_count_cli.py -x "%(xml)s"'
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
    # TOTAL = session.query(Response).filter(
    #     and_(*clauses)).count()

    with open('outputs/bow_fails.txt', 'w') as f:
        f.write('bag of words failures\n\n'.format(datetime.now().isoformat()))

    for i in xrange(START, TOTAL, LIMIT):
        responses = session.query(
            Response.id, Response.cleaned_content
        ).filter(
            and_(*clauses)
        ).limit(LIMIT).offset(i).all()

        for response_id, cleaned_content in responses:
            tc = TimedCmd(cmd % {"xml": cleaned_content})
            try:
                status, output, error = tc.run(timeout)
            except:
                print 'failed extraction: ', response_id
                with open('outputs/bow_fails.txt', 'a') as f:
                    f.write('extract fail: \n'.format(response_id))
                continue

            if error:
                print 'error from cli: ', response_id, error
                with open('outputs/bow_fails.txt', 'a') as f:
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
                with open('outputs/bow_fails.txt', 'a') as f:
                    f.write('commit fail: \n'.format(response_id))
                session.rollback()

    session.close()


if __name__ == '__main__':
    main()
