import json as js  # name conflict with sqla
import sqlalchemy as sqla
from sqlalchemy import exc
from sqlalchemy import event
from sqlalchemy import select
from sqlalchemy.orm import sessionmaker
from sqlalchemy import and_
from mpp.models import Response
from mpp.models import UniqueIdentifier
from semproc.timed_command import TimedCmd
from optparse import OptionParser
import tempfile
from os import write, close, unlink
import traceback


# TODO: some issue with an integer being too large for python.

def main():
    op = OptionParser()
    op.add_option('--files', '-f')

    options, arguments = op.parse_args()

    conf = 'big_rds.conf'
    cmd = 'python unique_identifier_cli.py -f {0} -u "{1}"'
    timeout = 120  # in seconds, more than 2minutes seems like an eternity

    with open(conf, 'r') as f:
        config = js.loads(f.read())

    # our connection
    engine = sqla.create_engine(config.get('connection'), pool_timeout=360)
    Session = sessionmaker()
    Session.configure(bind=engine)
    session = Session()

    @event.listens_for(engine, "engine_connect")
    def ping_connection(connection, branch):
        if branch:
            return
        try:
            connection.scalar(select([1]))
        except exc.DBAPIError as err:
            if err.connection_invalidated:
                connection.scalar(select([1]))
            else:
                raise

    for f in options.files.split(','):
        with open(f, 'r') as g:
            data = [int(a.strip()) for a in g.readlines() if a]

        for d in data:
            response = session.query(Response).filter(Response.id == d).first()

            print '\tready'
            response_id = response.id

            if response.identifiers:
                continue

            print '\tgo'
            cleaned_content = response.cleaned_content

            # put it in a tempfile to deal with
            # very long files and paper over the
            # encoding, escaping junk
            handle, name = tempfile.mkstemp(suffix='.xml')
            write(handle, cleaned_content)
            close(handle)

            tc = TimedCmd(cmd.format(name, response.source_url))
            try:
                status, output, error = tc.run(timeout)
            except Exception as ex:
                print '******propagated failed extraction: ', response_id
                # traceback.print_exc()
                print
                continue
            finally:
                unlink(name)

            if error:
                print '******error from cli: ', response_id
                print error
                print
                continue

            commits = []
            for i in output.split('\n'):
                if not i:
                    continue
                ident = js.loads(i)

                identifier = UniqueIdentifier(
                    response_id=response_id,
                    tag=ident.get('tag'),
                    extraction_type=ident.get('extraction_type'),
                    match_type=ident.get('match_type'),
                    original_text=ident.get('original_text'),
                    potential_identifier=ident.get('potential_identifier')
                )
                commits.append(identifier)

            try:
                session.add_all(commits)
                session.commit()
            except Exception as ex:
                print '**********failed commit: ', response_id
                print ex
                print
                session.rollback()

            print '\tcommitted'
    session.close()


if __name__ == '__main__':
    main()
