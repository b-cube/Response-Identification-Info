#!/anaconda/bin/python
# -*- coding: utf-8 -*-

from optparse import OptionParser
import json
import sys
import os
from semproc.unique_identifiers import IdentifierExtractor
from semproc.nlp_utils import load_token_list

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

    # TODO: don't hardcode this
    # set up the exclude lists
    equality = []
    for f in ['namespaces.txt']:
        equality += load_token_list(f)

    contains = []
    for f in ['cat_interop_urns.txt', 'mimetypes.txt', 'namespaces.txt', 'excludes_by_contains.txt']:
        contains += load_token_list(f)

    tag_paths = [
        '@codeList',
        '@schemaLocation',
        'identifier/@type',
        'Details/Licence',
        'binding/@transport',
        '@template',
        '@uri-type',
        'rights/@resource',
        'digform/digtinfo/formspec',
        'license/@href',
        'definition/@href',
        'dateTime/formatString',
        'RDF/Description/@about',
        'Binary/Thumbnail/Data'  # to exclude base64 encoded data
    ]

    extractor = IdentifierExtractor(
        options.url,
        xml_as_string,
        equality,
        contains,
        tag_paths
    )

    identifiers = []
    try:
        for ident in extractor.process_text():
            identifiers.append(ident)
    except Exception as ex:
        if debug:
            sys.stderr.write('Failed extraction: {0}'.format(ex))
        else:
            sys.stderr.write('Failed extraction')
        sys.exit(1)

    # repack the things to send as strings back up the cli chain
    # i think as a stringified json dict, streaming json style -
    # one dict per line, one dict per identifier
    print '\n'.join([json.dumps(ident.to_json()) for ident in identifiers])


if __name__ == '__main__':
    main()
