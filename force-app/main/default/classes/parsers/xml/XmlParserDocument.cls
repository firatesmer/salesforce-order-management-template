/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 10/04/2021
* @description XML parser document class
*   suppress reason : //TODO needs refactor
*/
@suppressWarnings('PMD.CognitiveComplexity, PMD.CyclomaticComplexity, PMD.StdCyclomaticComplexity, PMD.NcssMethodCount')
public class XmlParserDocument {
    private Integer count = 0;

    /*
    * @description Everything in the dom is found as childNodes under this root element
    */
    public Element root = new Element('#document');

    /**
     * @description Constructor to set input
     * @param input String input
     */
    public XmlParserDocument(String input) { 
        parseFromString(input); 
    }

    /**
    * @description Xml reader
    * @param parent Xml element
    * @param xmlStreamReader Xml stream reader
    */
    public void parseXmlReader(Element parent, XmlStreamReader xmlStreamReader) {
        while(xmlStreamReader.hasNext()) {
            if (xmlStreamReader.getEventType() == XmlTag.START_ELEMENT) {
                Element child = new Element(xmlStreamReader.getLocalName());
                
                for (Integer i = 0; i < xmlStreamReader.getAttributeCount(); i++) { 
                    child.attributes.put(xmlStreamReader.getAttributeLocalName(i), xmlStreamReader.getAttributeValueAt(i));
                }

                for (Integer j = 0; j < xmlStreamReader.getNamespaceCount(); j++) { 
                    String prefix = 'xmlns';

                    if (xmlStreamReader.getnamespaceprefix(j)!=null) {
                        prefix = xmlStreamReader.getnamespaceprefix(j); 
                    }
                        
                    child.attributes.put(prefix, xmlStreamReader.getnamespaceuriat(j));
                } 

                parent.appendChild(child); 

                if (child.nodeName.equalsIgnoreCase('item')) { 
                    count++; 
                }

                if (child.nodeName.equalsIgnoreCase('entry')) { 
                    count++; 
                }

                // to avoid a bug in XML Stream Reader   
                if (count > 10) {
                     return; 
                }              
                
                if (xmlStreamReader.hasNext()) {
                    xmlStreamReader.next();
                }

                else {
                    return;
                }

                parseXmlReader(child, xmlStreamReader);
                
            } else if (xmlStreamReader.getEventType() == XmlTag.END_ELEMENT) {   
                xmlStreamReader.next();
                return;               
            } 
            
            else if (xmlStreamReader.getEventType() == XmlTag.CHARACTERS) {
                if (!xmlStreamReader.isWhitespace()) { 
                    parent.nodeValue += xmlStreamReader.getText();
                }

                xmlStreamReader.next();         
            }

            else { 
                xmlStreamReader.next(); 
            }   
        }
    }   

    /**
    * @description Access nodes
    * @param tagName Tag name
    * @return List of elements
    */
    public List<Element> getElementsByTagName(String tagName) {
        return root.getElementsByTagName(tagName); 
    }

    /**
    * @description Dom function
    * @return Element
    */
    public Element ownerDocument() { 
        return root; 
    }

    private void parseFromString(String input) {   
        XmlStreamReader xmlStreamReader = new XmlStreamReader(input);
        xmlStreamReader.setCoalescing(true);

        parseXmlReader(root, xmlStreamReader); 
    }

    /**
    * @description Element class to be used in parsing
    */
    public class Element {
        public Element parentNode = null;
        public String nodeName = ''; 
        public String nodeValue = ''; 
        public List<Element> childNodes = new List<Element>();
        public Map<String, String> attributes = new Map<String, String>();

        /**
        * @description Constructor to set node
        * @param nodeName Name of the node
        */
        public Element(String nodeName) {
            this.nodeName = nodeName; 
        } 

        /**
        * @description Appends Xml child
        * @param element Element
        */
        public void appendChild(Element element) {
            element.ParentNode = this; 
            this.childNodes.add(element);     
        }

        /**
        * @description Gets Xml element by tag name
        * @param tagName Tag name
        * @return List of elements
        */
        public Element getElementByTagName(String tagName) {
            List<Element> elements = getElementsByTagName(tagName);

            if (elements.isEmpty()) {
                return null;
            }

            return elements[0];
        }

        /**
        * @description Gets Xml elements by tag name
        * @param tagName Tag name
        * @return List of elements
        */
        public List<Element> getElementsByTagName(String tagName) { 
            List<Element> elements = new List<Element>{};

            if (tagName.equalsIgnoreCase(this.nodeName)) {
                elements.add(this);
            }

            for (Element childNode: this.childNodes) { 
                elements.addAll(childNode.getElementsByTagName(tagName));
            }

            return elements;
        }
    }
}