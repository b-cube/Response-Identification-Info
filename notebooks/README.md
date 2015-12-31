##Metadata Analysis Notebooks

This set of Jupyter notebooks, prefixed with "Analysis - ", contains most of the code and data analysis in support of the BCube Semantics effort (see Citation below).

Notebooks found in the <pre>data-processing</pre> subdirectory contain reference code and some data munging code for the analyses. 

###Dependencies

For the most part, the processing and analysis code relies on lxml, pandas, sqlalchemy, and requests. Some notebooks may require other BCube modules:

[OwsCapable](https://github.com/b-cube/OwsCapable)

[metadata-pg-pipeline](https://github.com/b-cube/metadata-pg-pipeline)

[semantics-pipeline](https://github.com/b-cube/semantics_pipeline)

[semantics-preprocessing](https://github.com/b-cube/semantics-preprocessing)

or, if not required, these modules were used during the data processing at some point. For example, the semantics-pipeline code is not called directly from a notebook but was used to execute the document identification process, the results of which are used in the notebooks.

###Table of Contents

Blended Metadata: 

Duplicate Detection: demonstration of TF-IDf against different metadata representations of the same dataset and a vector near-duplicate/similarity algorithm against the kinds of identifier representations often found in the documents.

Identifiers:

ISO Specific Details:

Metadata Metrics Fine-grained:

Metadata Metrics:

OGC Tokens:

OpenSearch:

Schemas:

Service Linkrot:

Validation Metrics:



###Citation

On the Need for Self-describing Data and Services on the Web. Scott, S., R. Duerr, S.J.S. Khalsa. [Currently in progress]. 

