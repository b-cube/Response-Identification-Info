##Metadata Analysis Notebooks

This set of Jupyter notebooks, prefixed with "Analysis - ", contains most of the code and data analysis in support of the BCube Semantics effort (see Citation below).

Notebooks found in the <code>data-processing</code> subdirectory contain reference code and some data munging code for the analyses. 

###Dependencies

For the most part, the processing and analysis code relies on lxml, pandas, sqlalchemy, and requests. Some notebooks may require other BCube modules:

[OwsCapable](https://github.com/b-cube/OwsCapable) : a fork of geopython's OWSLib, updated to harmonize the GetCapabilities handling across services. 

[metadata-pg-pipeline](https://github.com/b-cube/metadata-pg-pipeline) : wrappers for the intermediate Postgres database for the analysis

[semantics-pipeline](https://github.com/b-cube/semantics_pipeline) : Luigi tasks for document identification, document clean-up and triplestore population

[semantics-preprocessing](https://github.com/b-cube/semantics-preprocessing) : module for most of the document processing (in the pipeline or standalone).

or, if not required, these modules were used during the data processing at some point. For example, the semantics-pipeline code is not called directly from a notebook but was used to execute the document identification process, the results of which are used in the notebooks.

###Table of Contents

**Blended Metadata:** analysis of any questions related to blended documents, i.e. ISO-19115 elements found in FGDC-CSDGM documents or JSON embedded in XML documents. [link](https://github.com/b-cube/Response-Identification-Info/blob/master/notebooks/Analysis%20-%20Blended%20Metadata.ipynb)

**Duplicate Detection:** demonstration of TF-IDf against different metadata representations of the same dataset and a vector near-duplicate/similarity algorithm against the kinds of identifier representations often found in the documents. [link](https://github.com/b-cube/Response-Identification-Info/blob/master/notebooks/Analysis%20-%20Duplicate%20Detection.ipynb)

**Identifiers:** [link]()

**ISO Specific Details:** [link]()

**Metadata Metrics Fine-grained:** [link]()

**Metadata Metrics:** [link]()

**OGC Tokens:** [link]()

**OpenSearch:** [link]()

**Schemas:** [link]()

**Service Linkrot:** [link]()

**Validation Metrics:** [link]()

The SQL found in the notebooks can be found in the <code>sql</code> subdirectory, with subdirectories labeled by notebook name. The individual references are in the notebooks as necessary. The output of these SQL queries can be found in the <code>sql_output</code> subdirectory, again with references in the notebooks.

The entire Postgres database is available as a SQL dump: [responses database]()

####Local Notebook Access

The notebooks require a Postgres connection, via sqlalchemy. As the BCube Semantics project has ended, we will not be able to provide access to Postgres hosted by our team. However, you can still use the notebooks (and any of the SQL or any other analyses of interest) by running your own Postgres instance populated by the provided SQL dump. 

Once you have the database set up with appropriate permissions and accounts, you need to create a configuration file with the connection string.

Anywhere you see this code in a notebook: 

```
# grab the clean text from the rds
with open('../local/big_rds.conf', 'r') as f:
    conf = js.loads(f.read())

# our connection
engine = sqla.create_engine(conf.get('connection'))
```

you will need to update the file path to this configuration file. The configuration file is a simple JSON structure:

```
{
    "connection": "postgresql://my_user:my_password@my_database.url.com:5432/my_database"
}
```

The connection value is a properly formed Postgres connection string. 

###Citation

On the Need for Self-describing Data and Services on the Web. Scott, S., R. Duerr, S.J.S. Khalsa. [Currently in progress]. 

