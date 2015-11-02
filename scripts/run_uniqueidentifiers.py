from datetime import datetime
import json as js  # name conflict with sqla
import sqlalchemy as sqla
from sqlalchemy.orm import sessionmaker
from sqlalchemy import and_, or_, not_
from mpp.models import Response
from mpp.models import Identifiers
from semproc.timed_command import TimedCmd
from optparse import OptionParser
import tempfile
from os import write, close, unlink


def main():
    op = OptionParser()
    op.add_option('--start', '-s', default=0, type="int")
    op.add_option('--end', '-e', default=100, type="int")
    op.add_option('--interval', '-i', default=100, type="int")

    options, arguments = op.parse_args()

    START = options.start
    TOTAL = options.end
    LIMIT = options.interval

    conf = 'big_rds.conf'
    cmd = "python unique_identifier_cli.py -f %s"
    timeout = 120  # in seconds, more than 2minutes seems like an eternity

    with open(conf, 'r') as f:
        config = js.loads(f.read())

    # our connection
    engine = sqla.create_engine(config.get('connection'))
    Session = sessionmaker()
    Session.configure(bind=engine)
    session = Session()

    clauses = [
        Response.format == 'xml'
    ]
    