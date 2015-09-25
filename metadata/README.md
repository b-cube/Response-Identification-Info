** FGDC

The "plain" FGDC 1998 schema (strict validation without extensions). Use fgdc-strict-1998/fgdc-std-001-1998.xsd as the schema file. 

** FGDC-RSE

The Remote Sensing Extension for FGDC. Use fgdc-rse-2002/schema.xsd as the schema file.

** ISO 19115-2

Update any XML to use this:

xsi:schemaLocation="http://www.isotc211.org/2005/gmi ngdc_schema.xsd"

as the schema location (note that ngdc_schema.xsd is relative to the XML file).

* Validating using Xerces

Make sure that the XML to validate includes the following attributes to metadata:

```
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xsi:noNamespaceSchemaLocation="path/to/parent/schema.xsd"
```

The paths are relative to this parent XSD.

Then just run PParse:

```
PParse -v=always -n -s the_fgdc.xml
```

* Validating in Oxygen Editor, etc

Add a schema to the document (there's a button) with the path pointing to path/to/parent/schema.xsd.


####Notes regarding the standards

In some cases, these have extensions beyond the standard. Others may reflect stricter validation schemes or previous version. 

This is a modified FGDC for CORiS: http://data.nodc.noaa.gov/coris/data/CoRIS/fgdc_schema_coris/fgdc-std-001-1998.xsd

Another modified FGDC to include ISO elements (CI_OnlineResource): http://ngdc.noaa.gov/metadata/published/xsd/ngdcSchema/schema.xsd

This is the NGDC imports of the ISO 19115 found in iso-19115-2003: http://ngdc.noaa.gov/metadata/published/xsd/schema.xsd

A USGS FGDC: http://water.usgs.gov/GIS/metadata/usgswrd/fgdc-std-001-1998.xsd


 