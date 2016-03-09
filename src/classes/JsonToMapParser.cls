/**********************************************************/
// Created by: José Elias Araújo
// Created Date: 03/27/2014
// Last Modified: José Elias Araújo
// Last Modified by: 04/01/2014
//
// Description:
// This class is able to convert JSON data in a map structure.
// 
// Test Class: 
// JsonToMapParserTest.cls
/**********************************************************/
public class JsonToMapParser{ 

	public Map<String, Object> parse(String jsonStr){
		return parse(null, jsonStr);	
	}

    public Map<String, Object> parse(String objectName, String jsonStr){
        JSONParser parser = JSON.createParser(jsonStr); 
        Map<String, Object> result = new Map<String, Object>();
        if (objectName != null){
        	while (parser.nextToken() != null) {
        		if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText().equals(objectName))) {
        			result = convertObject(parser);
        		}         	
        	}
        }else{
        	result = convertObject(parser);
        }
        return result;
    }
    	
	Map<String, Object> convertObject(JSONParser parser){    	        
        Map<String, Object> mapping = new Map<String, Object>();
		while (parser.getCurrentToken() != JSONToken.END_OBJECT) {
		    if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
		    	String key = parser.getText();
		    	parser.nextToken(); 
		    	if (parser.getCurrentToken() == JSONToken.START_OBJECT){
			    	Map<String, Object> value = convertObject(parser);
			    	mapping.put(key, value);    		
		    	}else if (parser.getCurrentToken() == JSONToken.START_ARRAY){
			    	List<Object> value = convertArray(parser);
			    	mapping.put(key, value);    		
		    	}else{
			    	String value = parser.getText();
			    	mapping.put(key, value);    				    		
		    		
		    	}		    	
    		}   
    		parser.nextToken();      
        }
        
        return mapping;
    }
    
	List<Object> convertArray(JSONParser parser){    	        
        List<Object> mapping = new List<Object>();
		while (parser.nextToken() != JSONToken.END_ARRAY) {
		    if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
				mapping.add(convertObject(parser));		    	
    		}else if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
    			mapping.add(convertArray(parser));    			
    		}else{
			    String value = parser.getText();
			    mapping.add(value);    			
    		}        
        }
        
        return mapping;
    } 
}