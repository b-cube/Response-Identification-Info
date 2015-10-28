# -*- coding: utf-8 -*-

from optparse import OptionParser
import json as js
import traceback

import sys
import re
import dateutil.parser as dateparser
from itertools import chain

from semproc.bag_parser import BagParser
from semproc.unique_identifiers import IdentifierExtractor
from semproc.nlp_utils import *

import warnings
warnings.filterwarnings('ignore')

'''
a little cli for extracting unique
identifiers. same regex findall hangups
'''


def main():
    op = OptionParser()
    op.add_option('--url', '-u')
    op.add_option('--xml_as_string', '-x')
    op.add_option('--debug', '-d', default='False')

    options, arguments = op.parse_args()

    if not options.url:
        op.error('No url')
    if not options.xml_as_string:
        op.error('No xml')

    debug = bool(options.debug)

    extractor = IdentifierExtractor(options.url, options.xml_as_string)

    try:
        extractor.process_text()
    except Exception as ex:
        if debug:
            sys.stderr.write('Failed extraction: {0}'.format(ex))
        else:
            sys.stderr.write('Failed extraction')
        sys.exit(1)

    # repack the things


if __name__ == '__main__':
    main()
