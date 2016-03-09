/**********************************************************/
// Created by: Luiz Borba
// Created Date: 03/27/2014
//
// Description:
// This class is able to convert a map structure for the manipulation of data.
// 
// Test Class: 
// JsonObjectTest.cls
/**********************************************************/
public class JsonObject {

    private Map<String, Object> jsonMap;
    
    // Description:  
    // Constructor method.
    //
    // Input: Map object created from a json document
    //
    // Returns: A new JsonObject instance
	// 
    public JsonObject(Map<String, Object> jsonMap) {
        this.jsonMap = jsonMap;
    }
    
	// Description:
	// This method returns the value associated with a key from the internal map
	// representation. This method accepts keys with list index. For example, 
	// "listofsomething[0]" will return the first element of "listofsomething" key.
	//
	// Inputs: String key of map, Map<String, Object> of internal representation of Json document 
	//
	// Returns: Object of element associated with the key.
	//
    private Object getValueFromMap(String key, Map<String, Object> internalMap) {
        String index = key.substringBetween('[', ']');
        if (index != null && !index.equals('')) {
            List<Object> lista = (List<Object>) internalMap.get(key.substringBefore('['));
            return lista.get(Integer.valueOf(index));
        } else {
            return internalMap.get(key);
        }
    }
    
	// Description:
	// This method returns the internal associated with a key path. Key path is a
	// representation of nested element in the internal map. For example, using
	// "firstlevel.nested" key, this method will get the firstlevel element and
	// then will get the nested element from firstlevel. It will be equivalent to
	// internalMap.get("firstlevel").get("nested").
	//
	// Inputs: String with keypath representation
	//
	// Returns: Object of element associated with the key path.
	//
    private Object getInternalValue(String keyPath) {
        Object result = null;
        Map<String, Object> internalMap = jsonMap;
        if (keyPath != null && keyPath.indexOf('.') != -1) {
            String[] keys = keyPath.split('\\.');
            for (integer i=0; i<keys.size()-1; i++) {
                internalMap = (Map<String, Object>) getValueFromMap(keys[i], internalMap);
            }
            result = getValueFromMap(keys[keys.size()-1], internalMap);
        } else {
            result = getValueFromMap(keyPath, internalMap);
        }
        return result;
    }
    
	// Description:
	// This method returns the element associated with a key path casted as String.
	//
	// Inputs: String with keypath representation
	//
	// Returns: Object of element associated with the key path casted as String.
	//
    public String getString(String keyPath) {
        return (String) getInternalValue(keyPath);
    }
    
	// Description:
	// This method returns the element associated with a key path casted as List.
	//
	// Inputs: String with keypath representation
	//
	// Returns: Object of element associated with the key path casted as List.
	//
    public List<Object> getList(String keyPath) {
        return (List<Object>) getInternalValue(keyPath);
    }

	// Description:
	// This method returns the element associated with a key path casted as Map.
	//
	// Inputs: String with keypath representation
	//
	// Returns: Object of element associated with the key path casted as Map.
	//
    public Map<String, Object> getMap(String keyPath) {
        return (Map<String, Object>) getInternalValue(keyPath);
    }
    
	// Description:
	// This method returns the element associated with a key path casted as a Map
	// and encapsulated in JsonObject.
	//
	// Inputs: String with keypath representation
	//
	// Returns: Object of element associated with the key path casted as a Map
	// and encapsulated in JsonObject.
	//
    public JsonObject getJsonObject(String keyPath) {
        return new JsonObject((Map<String, Object>) getMap(keyPath));
    }
}