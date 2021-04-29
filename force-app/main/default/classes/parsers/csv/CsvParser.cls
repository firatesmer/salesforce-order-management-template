/**
* @author Firat Esmer <firat.esmer@osf.digital>
* @date 10/04/2021
* @description Csv parser class
*/
public class CsvParser {
    /**
     * @description Prepares serializable text from Csv input
     *      TODO: For now only String fields are accepted
     * @param csvInput Csv input
     * @param newLine Line break
     * @param delimeter Seperation
     * @param fields Field of object will to be deserialized
     * @param includesHeader If Csv input includes header row
     * @param includesFooter If Csv input includes footer row
     * @return String
     */
    @SuppressWarnings('PMD.ExcessiveParameterList')
    public static String parse(String csvInput, String newLine, String delimeter, List<String> fields, Boolean includesHeader, Boolean includesFooter) {
        Map<String, Object> objectFieldMap;
        List<Map<String, Object>> objectFieldMapList = new List<Map<String, Object>>();

        List<String> rows = csvInput.split(newLine);

        if (includesHeader) {
            rows.remove(0);
        }

        if (includesFooter) {
            rows.remove(rows.size() - 1);
        }
        
        for (String row : rows) {
            List<String> cells = row.split(delimeter);

            objectFieldMap = new Map<String, Object>();

            for (Integer i = 0; i < cells.size(); i++) {
                objectFieldMap.put(fields[i], cells[i]);
            }

            objectFieldMapList.add(objectFieldMap);
        }

        return JSON.serialize(objectFieldMapList);
    }
 }