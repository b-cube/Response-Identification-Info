##Processing Scripts and Tools

###Command Line Tools

Three CLIs are provided for a) extracting unique identifiers from an XML document, b) extracting a bag of words array from an XML document, and c) validating an XML document. These are not standalone tools as they assume access to the analysis database (see the <code>postgres</code> directory for more information).

The bag of words and unique identifier CLIs have three parts:

    1. a small CLI for processing one XML document;
    2. a CLI wrapper for initiating any bulk processing through a database call (depends on \#1);
    3. a second CLI wrapper for initiating bulk processing via files (depends on \#1 and one or more files containing Response ID values, one per line).

The validation CLI does not include the first CLI described above - that is effectively the StdInParse call. The nesting is mainly to handle hung processes, especially with the XML validation, such that after some specified time, the process is killed. The default timeout for these subprocess calls is 120 seconds but can be modified as necessary.

Note: the unique identifier extraction basic CLI is not wired into the other two systems (it is not geared to handle all of the encoding issues from the real-world harvest). 

Options for the DB-based wrapper CLI:

* start (s): integer (0), start value for paging
* end (e): integer (100), end value for paging
* interval (i): integer (100), number of responses to return

(Note: the RDS configuration and timeout variables are not currently available through the CLI arguments.)

Options for the file-based wrapper CLI:

* files (f): a comma-delimited list of files, relative or full paths. a file contains one response identifier (the integer primary key) per line, no other delimiter, no quotes.

Options for the standalone CLI:

* url (u): (specific to unique identifier extraction where the harvest URL is itself an identifier) the harvest URL of the document
* file (f): the XML document (on disk, as temporary file or not)

To execute the unique identifier extraction:

```
# to run via paged database access
user$ python run_uniqueidentifiers.py -s 0 -e 10 -i 2

# to run via file access
user$ python run_uniqueidentifiers_file.py -f 'files_to_run/aaa.txt,files_to_run/aab.txt'
```

Note: certain patterns to exclude from the result set are found in the code, as hard-coded patterns or as references to provided corpora. Modify these as needed with the understanding that the corpora is provided through the semantics-preprocessing module (edit and rebuild).

To execute the bag of words extraction:

```
# to run via paged database access
user$ python run_wordcount.py -s 0 -e 10 -i 2

# to run via file access
user$ python run_wordcount_file.py -f 'files_to_run/aaa.txt,files_to_run/aab.txt'
```

Note: certain patterns to exclude from the result set are found in the code. Modify these as needed.

To validate an XML document with the CLI:

```
# to run via paged database access
user$ python validate_cli.py -s 0 -e 10 -i 2

# to run via file access
user$ python validate_file_cli.py -f 'files_to_run/aaa.txt,files_to_run/aab.txt'
```

Note: the config argument for the validation CLI is not used.