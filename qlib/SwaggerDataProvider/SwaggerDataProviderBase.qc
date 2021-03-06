# -*- mode: qore; indent-tabs-mode: nil -*-
#! Qore SwaggerDataProvider module definition

/** SwaggerDataProviderBase.qc Copyright 2019 - 2020 Qore Technologies, s.r.o.

    Permission is hereby granted, free of charge, to any person obtaining a
    copy of this software and associated documentation files (the "Software"),
    to deal in the Software without restriction, including without limitation
    the rights to use, copy, modify, merge, publish, distribute, sublicense,
    and/or sell copies of the Software, and to permit persons to whom the
    Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
    FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
    DEALINGS IN THE SOFTWARE.
*/

#! contains all public definitions in the SwaggerDataProvider module
public namespace SwaggerDataProvider {
#! The Swagger data provider base class
public class SwaggerDataProviderBase inherits AbstractDataProvider {
    #! Returns data provider static info
    private hash<DataProviderInfo> getStaticInfoImpl() {
        return SwaggerDataProvider::ProviderInfo - "constructor_options";
    }

    #! Returns a field definition from Swagger parameters
    private addFieldsFromParameters(HashDataType rv, hash<string, AbstractParameterObject> parameters, reference<bool> required) {
        # temporary hash for fields: loc -> name -> field
        hash<string, hash<string, AbstractDataField>> params;
        # required flag map for type: loc -> bool
        hash<string, bool> req_map;
        foreach hash<auto> i in (parameters.pairIterator()) {
            switch (i.value.inLoc) {
                # body and formData parameters are handled directly under the operation
                case "query": {
                    params{i.value.inLoc}{i.value.name} = getFieldFromParameter(i.value.name, i.value.type,
                        i.value.items, i.value.desc, i.value.required);
                    # if at least one query argument is required, then we set "required" to True for the hash
                    if (i.value.required && !req_map{i.value.inLoc}) {
                        req_map{i.value.inLoc} = True;
                    }
                    break;
                }

                case "header": {
                    params{i.value.inLoc}{i.value.name} = getFieldFromParameter(i.value.name, "string", NOTHING,
                        i.value.desc, i.value.required);
                    # if at least one query argument is required, then we set "required" to True for the hash
                    if (i.value.required) {
                        if (!req_map{i.value.inLoc}) {
                            req_map{i.value.inLoc} = True;
                        }
                        if (!required) {
                            required = True;
                        }
                    }
                    break;
                }
            }
        }

        foreach hash<auto> i in (params.pairIterator()) {
            HashDataType type(req_map{i.key} ? AutoHashType : AutoHashOrNothingType);
            map type.addField($1), i.value.iterator();
            rv.addField(new QoreDataField(i.key, "Swagger " + i.key + " parameter", type));
        }
    }

    #! Returns a field definition from the Swagger parameter
    private AbstractDataField getFieldFromSchema(string name, *string desc, SchemaObject schema, bool required = True) {
        if (schema.desc) {
            if (desc) {
                desc += ": " + schema.desc;
            } else {
                desc = schema.desc;
            }
        }
        if (schema.type == "object") {
            return new QoreDataField(name, desc, getSchemaDataType(schema, required));
        }
        return getFieldFromParameter(name, schema.type, schema.items, desc, required);
    }

    #! Returns the data type for the given schema
    private AbstractDataProviderType getSchemaDataType(SchemaObject schema, bool required = True) {
        HashDataType type(required ? AutoHashType : AutoHashOrNothingType);
        map type.addField(getFieldFromSchema($1.key, NOTHING, $1.value, exists schema.required{$1.key})),
            schema.properties.pairIterator();
        if (schema.additionalProperties) {
            type.setDefaultOtherFieldType(getType(schema.additionalProperties.type));
        } else {
            # make sure that extra fields are not supported
            type.setDefaultOtherFieldType();
        }
        return type;
    }

    #! Returns a field from a Swagger parameter
    private AbstractDataField getFieldFromParameter(string name, string type, *SchemaObject arrayItems, *string desc, bool required) {
        return new QoreDataField(name, desc, getType(type, arrayItems, required));
    }

    #! Returns the data type corresponding to the values
    private AbstractDataProviderType getType(string typestr, *SchemaObject arrayItems, bool required = True) {
        hash<auto> type_options;
        if (required) {
            type_options += {"qore.no_null": True};
        }
        switch (typestr) {
            case "boolean":
                return required ? new QoreSoftBoolDataType(type_options) : new QoreBoolOrNothingDataType(type_options);

            case "file":
                return required ? new QoreSoftStringDataType(type_options) : new QoreSoftStringOrNothingDataType(type_options);

            case "array":
                return new ListDataType(getSchemaDataType(arrayItems), !required);
        }

        if (*string newname = OptimalQoreSoftDataTypeMap{typestr}) {
            typestr = newname;
        }
        if (!required && (typestr != "any" && typestr != "auto")) {
            typestr = "*" + typestr;
        }
        return AbstractDataProviderType::get(new Type(typestr), type_options);
    }

    #! Returns a field of header fields
    private AbstractDataField getFieldForHeaders(string name, hash<auto> headers) {
        HashDataType recordType();
        map recordType.addField(getFieldFromParameter($1.key, $1.value.type, $1.value.items, $1.value.desc, False)), headers.pairIterator();
        return new QoreDataField(name, "HTTP headers", recordType);
    }
}
}
