# -*- coding: utf-8 -*-

from optparse import OptionParser
import sys
import re
import dateutil.parser as dateparser
from itertools import chain

from semproc.bag_parser import BagParser
from semproc.nlp_utils import *

import warnings
warnings.filterwarnings('ignore')

'''
a little cli for the bag of words
count to handle the race conditions
in the regex
'''


def convert_header_list(headers):
    '''
    convert from the list of strings, one string
    per kvp, to a dict with keys normalized
    '''
    return dict(
        (k.strip().lower(), v.strip()) for k, v in (
            h.split(':', 1) for h in headers)
    )


def strip_dates(text):
        # this should still make it an invalid date
        # text = text[3:] if text.startswith('NaN') else text
        try:
            d = dateparser.parse(text)
            return ''
        except ValueError:
            return text
        except OverflowError:
            return text


def strip_filenames(text):
    # we'll see
    exts = ('png', 'jpg', 'hdf', 'xml', 'doc', 'pdf', 'txt', 'jar', 'nc', 'XSL', 'kml', 'xsd')
    return '' if text.endswith(exts) else text


def strip_identifiers(texts):
    # chuck any urns, urls, uuids
    _pattern_set = [
        ('url', ur"""(?i)\b((?:https?:(?:/{1,3}|[a-z0-9%])|[a-z0-9.\-]+[.](?:com|net|org|edu|gov|mil|aero|asia|biz|cat|coop|info|int|jobs|mobi|museum|name|post|pro|tel|travel|xxx|ac|ad|ae|af|ag|ai|al|am|an|ao|aq|ar|as|at|au|aw|ax|az|ba|bb|bd|be|bf|bg|bh|bi|bj|bm|bn|bo|br|bs|bt|bv|bw|by|bz|ca|cc|cd|cf|cg|ch|ci|ck|cl|cm|cn|co|cr|cs|cu|cv|cx|cy|cz|dd|de|dj|dk|dm|do|dz|ec|ee|eg|eh|er|es|et|eu|fi|fj|fk|fm|fo|fr|ga|gb|gd|ge|gf|gg|gh|gi|gl|gm|gn|gp|gq|gr|gs|gt|gu|gw|gy|hk|hm|hn|hr|ht|hu|id|ie|il|im|in|io|iq|ir|is|it|je|jm|jo|jp|ke|kg|kh|ki|km|kn|kp|kr|kw|ky|kz|la|lb|lc|li|lk|lr|ls|lt|lu|lv|ly|ma|mc|md|me|mg|mh|mk|ml|mm|mn|mo|mp|mq|mr|ms|mt|mu|mv|mw|mx|my|mz|na|nc|ne|nf|ng|ni|nl|no|np|nr|nu|nz|om|pa|pe|pf|pg|ph|pk|pl|pm|pn|pr|ps|pt|pw|py|qa|re|ro|rs|ru|rw|sa|sb|sc|sd|se|sg|sh|si|sj|Ja|sk|sl|sm|sn|so|sr|ss|st|su|sv|sx|sy|sz|tc|td|tf|tg|th|tj|tk|tl|tm|tn|to|tp|tr|tt|tv|tw|tz|ua|ug|uk|us|uy|uz|va|vc|ve|vg|vi|vn|vu|wf|ws|ye|yt|yu|za|zm|zw)/)(?:[^\s()<>{}\[\]]+|\([^\s()]*?\([^\s()]+\)[^\s()]*?\)|\([^\s]+?\))+(?:\([^\s()]*?\([^\s()]+\)[^\s()]*?\)|\([^\s]+?\)|[^\s`!()\[\]{};:'".,<>?«»“”‘’])|(?:(?<!@)[a-z0-9]+(?:[.\-][a-z0-9]+)*[.](?:com|net|org|edu|gov|mil|aero|asia|biz|cat|coop|info|int|jobs|mobi|museum|name|post|pro|tel|travel|xxx|ac|ad|ae|af|ag|ai|al|am|an|ao|aq|ar|as|at|au|aw|ax|az|ba|bb|bd|be|bf|bg|bh|bi|bj|bm|bn|bo|br|bs|bt|bv|bw|by|bz|ca|cc|cd|cf|cg|ch|ci|ck|cl|cm|cn|co|cr|cs|cu|cv|cx|cy|cz|dd|de|dj|dk|dm|do|dz|ec|ee|eg|eh|er|es|et|eu|fi|fj|fk|fm|fo|fr|ga|gb|gd|ge|gf|gg|gh|gi|gl|gm|gn|gp|gq|gr|gs|gt|gu|gw|gy|hk|hm|hn|hr|ht|hu|id|ie|il|im|in|io|iq|ir|is|it|je|jm|jo|jp|ke|kg|kh|ki|km|kn|kp|kr|kw|ky|kz|la|lb|lc|li|lk|lr|ls|lt|lu|lv|ly|ma|mc|md|me|mg|mh|mk|ml|mm|mn|mo|mp|mq|mr|ms|mt|mu|mv|mw|mx|my|mz|na|nc|ne|nf|ng|ni|nl|no|np|nr|nu|nz|om|pa|pe|pf|pg|ph|pk|pl|pm|pn|pr|ps|pt|pw|py|qa|re|ro|rs|ru|rw|sa|sb|sc|sd|se|sg|sh|si|sj|Ja|sk|sl|sm|sn|so|sr|ss|st|su|sv|sx|sy|sz|tc|td|tf|tg|th|tj|tk|tl|tm|tn|to|tp|tr|tt|tv|tw|tz|ua|ug|uk|us|uy|uz|va|vc|ve|vg|vi|vn|vu|wf|ws|ye|yt|yu|za|zm|zw)\b/?(?!@)))"""),
        # a urn that isn't a url
        ('urn', ur"(?![http://])(?![https://])(?![ftp://])(([a-z0-9.\S][a-z0-9-.\S]{0,}\S:{1,2}\S)+[a-z0-9()+,\-.=@;$_!*'%/?#]+)"),
        ('uuid', ur'([a-f\d]{8}(-[a-f\d]{4}){3}-[a-f\d]{12}?)'),
        ('doi', ur"(10[.][0-9]{4,}(?:[/][0-9]+)*/(?:(?![\"&\\'])\S)+)"),
        ('md5', ur"([a-f0-9]{32})")
    ]
    for pattern_type, pattern in _pattern_set:
        for m in re.findall(re.compile(pattern), texts):
            m = max(m) if isinstance(m, tuple) else m
            try:
                texts = texts.replace(m, '')
            except Exception as ex:
                print ex
                print m

    files = ['cat_interop_urns.txt', 'mimetypes.txt', 'namespaces.txt']
    for f in files:
        texts = remove_tokens(f, texts)
    return texts.split()


def clean(text):
    text = strip_dates(text)
    text = remove_numeric(text).strip()
    text = remove_punctuation(text.strip()).strip()
    text = strip_terminal_punctuation(text.strip()).strip()
    text = strip_filenames(text).strip()

    return text


def main():
    op = OptionParser()
    op.add_option('--xml_as_string', '-x')

    options, arguments = op.parse_args()

    if not options.xml_as_string:
        op.error('No xml')

    exclude_tags = ['schemaLocation', 'noNamespaceSchemaLocation']

    bp = BagParser(options.xml_as_string.encode('utf-8'), True, False)
    if bp.parser.xml is None:
        sys.stderr.write('Failed xml parse')
        sys.exit(1)

    stripped_text = [b[1].split() for b in bp.strip_text(exclude_tags) if b[1]]
    stripped_text = list(chain.from_iterable(stripped_text))
    cleaned_text = [clean(s) for s in stripped_text]
    bow = strip_identifiers(' '.join([c for c in cleaned_text if c]))
    print ' '.join([b.encode('utf-8') for b in bow if b])


if __name__ == '__main__':
    main()
