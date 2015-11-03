from datetime import datetime
import json as js  # name conflict with sqla
import sqlalchemy as sqla
from sqlalchemy.orm import sessionmaker
from mpp.models import Response
from mpp.models import BagOfWords
from semproc.timed_command import TimedCmd
from optparse import OptionParser
import tempfile
from os import write, close, unlink

'''
wrapper for the singleton bag of words cli
mostly to kill any wonky regex

note: if the process is terminated, the bag
is empty - no partial resultset

file-based so any response id in the set of files
one id per line.
'''


def main():

    op = OptionParser()
    op.add_option('--files', '-f')

    options, arguments = op.parse_args()

    conf = 'big_rds.conf'
    cmd = "python word_count_cli.py -f %s"
    timeout = 120  # in seconds, more than 2minutes seems like an eternity

    if not options.files:
        op.error('No file list')

    with open(conf, 'r') as f:
        config = js.loads(f.read())

    # our connection
    engine = sqla.create_engine(config.get('connection'))
    Session = sessionmaker()
    Session.configure(bind=engine)
    session = Session()

    for f in options.files.split(','):
        with open(f, 'r') as g:
            data = [int(a.strip()) for a in g.readlines() if a]

        for d in data:
            response = session.query(Response).filter(Response.id == d).first()

            if response.bags_of_words:
                continue

            response_id = response.id
            cleaned_content = response.cleaned_content

            # put it in a tempfile to deal with
            # very long files and paper over the
            # encoding, escaping junk
            handle, name = tempfile.mkstemp(suffix='.xml')
            write(handle, cleaned_content)
            close(handle)

            tc = TimedCmd(cmd % name)
            try:
                status, output, error = tc.run(timeout)
            except:
                print 'failed extraction: ', response_id
                error = 'Timeout error'
            finally:
                unlink(name)

            if error:
                print 'error from cli: ', response_id, error
                bag = BagOfWords(
                    generated_on=datetime.now(),
                    failed=True,
                    method="basic",
                    response_id=response_id
                )
            else:
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
                session.rollback()

    session.close()


if __name__ == '__main__':
    main()
