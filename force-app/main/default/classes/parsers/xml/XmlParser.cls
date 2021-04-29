/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 10/04/2021
* @description XML parser class
*/
@SuppressWarnings('PMD.CognitiveComplexity')
public class XmlParser {
    private Boolean serializeNulls = true;
    private String rootElement;
    private Set<String> deserializeAsArrayNodes = new Set<String>();

    /**
    * @description Serializes the object passed to XML string
    * @param objectToSerialize Apex object to serialize into Xml
    * @return Xml String
    */
    public String serialize(Object objectToSerialize) {        
        Object deserialized = JSON.deserializeUntyped(JSON.serialize(objectToSerialize));               
        return !string.isEmpty(rootElement) 
            ? Wrap(rootElement, serialize((Map<String, Object>)deserialized)) 
            : serialize((Map<String, Object>)deserialized);     
    }

    /**
    * @description Serializes the object passed to XML string
    * @param objectToSerialize Apex object to serialize into Xml
    * @param suppressApexObjectNulls if true, it will not serialize empty elements to Xml
    * @param addRootElementName Name of the root element to wrap serialized string with
    * @return Xml String
    */
    public String serialize(Object objectToSerialize, Boolean suppressApexObjectNulls, String addRootElementName) {
        this.serializeNulls = !suppressApexObjectNulls;
        this.rootElement = addRootElementName;
        return serialize(objectToSerialize);
    }

    /**
    * @description Converts JSON string to Xml String
    * @param jsonString Json string
    * @return Xml String
    */
    public String jsonToXML(String jsonString) {
        Object deserialized = JSON.deserializeUntyped(jsonString);               
        return !string.isEmpty(rootElement) 
            ? Wrap(rootElement,serialize((Map<String, Object>)deserialized)) 
            : serialize((Map<String, Object>)deserialized);
    }

    /**
    * @description Converts JSON string to Xml String
    * @param jsonString Json string
    * @param suppressNulls Ignores empty Json elements, if true
    * @return Xml String
    */
    public String jsonToXML(String jsonString, Boolean suppressNulls) {
        this.serializeNulls = !suppressNulls;       
        return jsonToXML(jsonString);
    }

    /**
    * @description Deserializes Xml into the object of ApexType
    * @param xmlString Xml String to deserialize
    * @param apexType Type of object to deserialize to
    * @return Object of ApexType
    */
    public Object deserialize(String xmlString, System.Type apexType) {   
        String json = XMLToJson(xmlString); 
        return System.JSON.deserialize(json, apexType);  		
    }

    /**
    * @description Deserializes Xml into the object of ApexType
    * @param xmlString Xml String to deserialize
    * @param apexType Type of object to deserialize to
    * @param deserializeNodesAsArray Collection of node names to 
    *   deserialize as array (Even if xml representation is not an array)
    * @return Object of ApexType
    */
    public Object deserialize(String xmlString, System.Type apexType, Set<String> deserializeNodesAsArray) {   
        this.deserializeAsArrayNodes = toLower(deserializeNodesAsArray);
        return deserialize(xmlString, apexType);		
    }    

    /**
    * @description Deserializes Xml string into collection of primitive data types
    * @param xmlString Xml string
    * @return Collection of primitive data types
    */
    public Object deserializeUnTyped(String xmlString) {  
        return xmlToUnTyped(xmlString);  		
    }

    /**
    * @description Deserializes Xml string into collection of primitive data types
    * @param xmlString Xml string
    * @param deserializeNodesAsArray Collection of node names to 
    *   deserialize as array (Even if xml representation is not an array)
    * @return Collection of primitive data types
    */
    public Object deserializeUnTyped(String xmlString, Set<String> deserializeNodesAsArray) {  
        this.deserializeAsArrayNodes = toLower(deserializeNodesAsArray);
        return xmlToUnTyped(xmlString);  		
    }

    /**
    * @description Converts Xml string to Json string
    * @param xmlString Xml string
    * @return Json String
    */
    public String xmlToJson(String xmlString) {
        return System.JSON.serialize(XMLToUnTyped(xmlString));
    } 

    /**
    * @description Converts Xml string to Json string
    * @param xmlString Xml string
    * @param deserializeNodesAsArray Collection of node names to 
    *   deserialize as array (Even if xml representation is not an array)
    * @return Json String
    */
    public String xmlToJson(String xmlString, Set<String> deserializeNodesAsArray) {  
        this.deserializeAsArrayNodes = toLower(deserializeNodesAsArray);
        return System.JSON.serialize(XMLToUnTyped(xmlString));
    }   

    /**
    * @description Reset options to default
    */
    public void resetDefaults() {
        this.serializeNulls = true;
        this.rootElement = null;
        this.deserializeAsArrayNodes.clear();
    }

    /**
    * @description Serialize method
    * @param objectMap Map of String and objects
    * @return Xml string
    */
    private String serialize(Map<String, Object> objectMap) {
        String xmlString = '';    

        for(String key:objectMap.keySet()) {  
            Object o = objectMap.get(key);
            
            if(o == null) 
            { 
                if(this.SerializeNulls) 
                {
                    xmlString += wrap(key, null); 
                }
            }        
            else if(o InstanceOf List<object>) 
            {
                xmlString += serialize((List<Object>)o,key);
            }
            else if(o InstanceOf Map<string,object>)
            {
                xmlString += wrap(key,serialize((Map<String, Object>)o));
            }
            else
            {
                xmlString += wrap(key,string.valueOf(o));
            }
        }

        return xmlString;
    }

    /**
    * @description Serialize method
    * @param objectList List of objects
    * @param key To wrap all elements of the list with
    * @return Xml string
    */
    private String serialize(List<Object> objectList, String key) {
        String xmlString = '';      

        for(object o: objectList) 
        {    
            if (o InstanceOf string)
            { 
                xmlString += wrap(key,string.valueOf(o));
            }	
            else if(o InstanceOf List<object>)
            {
                xmlString += wrap(key,serialize((List<Object>)o, key));
            }
            else
            {
                xmlString += wrap(key,serialize((Map<String, Object>)o));                
            }
        }    

        return xmlString;
    }

    /**
    * @description Wraps value with key Xml element
    * @param key Xml node name
    * @param value Xml node value
    * @return Xml string
    */
    private String wrap(String key, String value) {
        return (String.isNotBlank(value) || serializeNulls) 
            ? ('<' + key + '>' + (String.isBlank(value) ? '' : value) + '</' + key + '>') 
            : value;
    }

    /**
    * @description Deserializes Xml string into collection of primitive data types
    * @param xmlString Xml string
    * @return Collection of primitive data types
    */
    private Map<String, Object> xmlToUntyped(String xmlString) {
        XmlParserDocument xmlSerializerDocument = new XmlParserDocument(xmlString);
        XmlParserDocument.Element document = xmlSerializerDocument.ownerDocument();
        return (Map<String, Object>)parseNode(document);
    }  

    /**
    * @description Parses an Xml node
    * @param element Xml node
    * @return Object
    */
    private Object parseNode(XmlParserDocument.Element element) {
        if(element.childNodes.size() > 0) 
        {
            return complexNodeToMap(element); 
        }
        else 
        {
            return element.nodeValue;  
        }
    }

    /**
    * @description Converts complex Xml node to collection of primitive types
    * @param element Xml node
    * @return Map representation of the node
    */
    private Map<String, object> complexNodeToMap(XmlParserDocument.Element element) {       
        Map<String, Object> cNodeMap = new Map<String, object>();

        for(XmlParserDocument.Element cNode : element.childNodes) 
        {                 
            if(cNodeMap.containsKey(cNode.nodeName)) 
            {                    
                Object o = cNodeMap.get(cNode.nodeName);  

                if(o InstanceOf List<object>)
                {
                    ((List<Object>)o).add(parseNode(cNode));
                }
                else
                {
                    cNodeMap.put(cNode.nodeName,new List<Object>{ o, parseNode(cNode) });                    
                }
            }
            else
            {
                cNodeMap.put(cNode.nodeName, deserializeAsArrayNodes.contains(cNode.nodeName.toLowerCase()) ? new List<Object>{ parseNode(cNode) } : parseNode(cNode));
            }
        }

        return cNodeMap;
    } 

    /**
    * @description Converts all elements of the set to lower case
    * @param stringSet Set of strings to convert to lower case
    * @return Converted set of strings
    */
    private Set<String> toLower(Set<String> stringSet) {
        Set<String> lowerStringSet = new Set<String>();

        for(String s: stringSet) 
        {
            lowerStringSet.add(s.toLowerCase());
        }

        return lowerStringSet;
    }
}