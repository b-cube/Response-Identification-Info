# -*- coding: utf-8 -*-

from optparse import OptionParser
import json as js
import traceback

import sys

from semproc.unique_identifiers import IdentifierExtractor

import warnings
warnings.filterwarnings('ignore')

'''
a little cli for extracting unique
identifiers. same regex findall hangups
'''


def main():
    op = OptionParser()
    op.add_option('--url', '-u')
    op.add_option('--file', '-f')
    op.add_option('--debug', '-d', default='False')

    options, arguments = op.parse_args()

    if not options.url:
        op.error('No url')
    if not options.file:
        op.error('No xml file')

    debug = bool(options.debug)

    with open(options.file, 'r') as f:
        xml_as_string = f.read()

    extractor = IdentifierExtractor(options.url, xml_as_string)

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
