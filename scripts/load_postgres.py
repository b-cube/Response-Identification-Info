# load the solr docs into the remote rds

from optparse import OptionParser


def main():
    op = OptionParser()
    op.add_option('--config', '-c')

    options, arguments = op.parse_args()
    pass

if __name__ == '__main__':
    main()
