with v as (
	select response_id, unnest(errors) as every_error
	from validations
	where valid = False
)

select distinct every_error
from v
where every_error not like 'Error at validation CLI: timeout error'
and
	(every_error not like '% attribute % is not declared %'
	and every_error not like '% no declaration found for element %'
	and every_error not like '% element % is not allowed for content model %'
	and every_error not like '% empty content is not valid for content model %'
	and every_error not like '% missing elements in content model %'
	and every_error not like '% schemaLocation does not contain namespace-location pairs%'
	and every_error not like '% no character data is allowed by content model%'
	and every_error not like '% unable to find validator for%'
	and every_error not like '% grammar not found for namespace %'
	and every_error not like '% element % is referenced in a content model but was never declared%'
	and every_error not like '% no complete functional mapping between particles%'
	and every_error not like '% namespace for % cannot be bound to prefix other than %'
	and every_error not like '% root element name of XML Schema document must be %'
	and every_error not like '% element % must be from the XML Schema namespace%'
	and every_error not like '% namespace % is referenced without import declaration%'
	and every_error not like '% imported schema % has different target namespace %; expected %'
	and every_error not like '% schema document % has different target namespace from the one specified in instance document %'
	and every_error not like '% markup declaration expected%'
	and every_error not like '% invalid multi-byte sequence%'
	and every_error not like '% unsupported protocol in URL%'
	and every_error not like '% unterminated comment%'
	and every_error not like '% prefix % can not be resolved to namespace URI%'
	and every_error not like '% unmatched end tag detected%'
)
and (
-- remove the nots for the access errors
	every_error not like '% fatal error during schema scan%'
	and every_error not like '% reference to external entity declaration %'
	and every_error not like '% unable to open DTD document%'
	and every_error not like '% unable to connect socket for URL %'
	and every_error not like '% unable to read from socket for URL %'
	and every_error not like '% unable to open file %'
	and every_error not like '% unable to open primary document entity %'
	and every_error not like '% unable to open external entity %'
	and every_error not like '% unable to resolve host/address %'
)
and (
	every_error not like '% empty string encountered%'
	and every_error not like '% value % is invalid ENTITY%'
	and every_error not like '% value % is invalid NCName%'
	and every_error not like '% value % is invalid QName%'
	and every_error not like '% value % is invalid Name%'
	and every_error not like '% ID value % is not unique%'
	and every_error not like '% ID value % has already been used%'
	and every_error not like '% value % not in enumeration%'
	and every_error not like '% value % does not match regular expression facet%'
	and every_error not like '% invalid character encountered%'
	and every_error not like '% element % must be qualified%'
	and every_error not like '% element % must be unqualified%'
	and every_error not like '% attribute % must be unqualified%'
	and every_error not like '% missing required attribute %'
	and every_error not like '% missing % separator in dateTime value %'
	and every_error not like '% value % is invalid boolean%'
	and every_error not like '% value % does not match any member types of the union%'
	and every_error not like '% incomplete time value %'
	and every_error not like '% invalid time value %'
	and every_error not like '% invalid dateTime value %'
	and every_error not like '% value % has length % which is less than minLength facet value %'
	and every_error not like '% attribute % has already been declared%'
	and every_error not like '% ID attribute % is referenced but was never declared%'
	and every_error not like '% specified for non-nillable element %'
	and every_error not like '% element % is of simple type and cannot have elements in its content%'
	and every_error not like '% value % must be greater than or equal to minExclusive facet value %'
	and every_error not like '% value % must be greater than or equal to minInclusive facet value %'
	and every_error not like '% attribute % declared more than once in the same scope%'
	and every_error not like '% attribute % refers to unknown entity %'
	and every_error not like '% attribute % is already specified for element %'
	and every_error not like '% year value % must follow % format%'
	and every_error not like '% month value % must be between 1 and %'
	and every_error not like '% duration value % must start with %'
	and every_error not like '% value % is invalid anyURI%'
	and every_error not like '% global element % declared more than once%'
	and every_error not like '% content of element % differs from its declared fixed value%'
	and every_error not like '% whitespace must not occur between externally declared elements with element content in standalone document%'
	and every_error not like '% attribute cannot have empty value%'
	and every_error not like '% value % must be less than maxExclusive facet value %'
	and every_error not like '% value % must be less than maxInclusive facet value %'
	and every_error not like '% value % must be less than or equal to maxInclusive facet value %'
	and every_error not like '% day value % must be between 1 and %'
	and every_error not like '% global type % declared more than once or also declared as simpleType%'
	and every_error not like '% global attributeGroup % declared more than once%'
	and every_error not like '% whitespace expected%'
	and every_error not like '% simpleType % for attribute % not found%'
	and every_error not like '% element % has identity constraint key with no value%'
	and every_error not like '% type % specified as the base in simpleContent definition must not have complex content%'
	and every_error not like '% type % cannot be used in its own union, list, or restriction definition%'
	and every_error not like '% type of attribute % must be derived by restriction from type of the corresponding attribute in the base%'
	and every_error not like '% value % for attribute % does not match its type%s defined enumeration or notation list%'
	and every_error not like '% attribute % cannot appear in local element declarations%'
	and every_error not like '% type % not found%'
	and every_error not like '% attribute % has value % that does not match its #FIXED value %'
	and every_error not like '% attribute % is already defined in base%'
	and every_error not like '% element % has a type which does not derive from the type of the element at the head of the substitution group%'
	and every_error not like '% non-whitespace characters are not allowed in schema declarations other than %'
	and every_error not like '% global type % declared more than once or also declared as complexType%'
	and every_error not like '% global group % declared more than once%'
	and every_error not like '% unknown simpleType %'
	and every_error not like '% equal sign expected%' --fatal error
	and every_error not like '% expected end of tag %' --fatal error
	and every_error not like '% unexpected end of input%' --fatal error
	and every_error not like '% entity % not found%' --fatal error
	and every_error not like '% input ended before all started tags were ended; last tag started is %' --fatal error
	and every_error not like '% unmatched end tag expected %' --fatal error
	and every_error not like '% element name expected%' --fatal error
	and every_error not like '% complex type % violates the unique particle attribution rule in its components %'
	and every_error not like '% referenced element % not found%'
	and every_error not like '% invalid content in % element%'
	and every_error not like '% base type specified in complexContent definition must be a complex type%'
)
;

-- AS OF 11/1/2015, 12AM (incomplete set)
-- 2,191,018 total errors
-- no declaration found for element
-- attribute % is not declared for element
-- element % is not allowed for content model
-- empty content is not valid for content model
-- missing elements in content model
-- ( structural issues)

--    errors not attribute or element declarations, content model issues

-- fatal error during schema scan
-- reference to external entity declaration
-- unable to open DTD document 
-- schema document % has different target namespace from the one specified in instance document
-- unable to connect socket for 

--    access issues

-- format issues
-- empty string encountered
-- value % is invalid ENTITY
-- value % is invalid NCName
-- ID value % is not unique
-- value % not in enumeration
-- value % does not match regular expression facet
-- invalid character encountered
-- element % must be qualified
-- missing required attribute %
-- missing % seperator in dateTime value %
-- value % is invalid boolean
-- value % does not match any member types of the union



