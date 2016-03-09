/**********************************************************/
// Created by: José Elias Araújo
// Created Date: 02/13/2014
// Last Modified: José Elias Araújo
// Last Modified by: 03/20/2014
//
// Description:
// This class is able to convert the Emporium data in JSON
// format to object representation.
// 
// Test Class: 
// EmporiumDataParserTest.cls
/**********************************************************/
public class EmporiumDataParser{
    
    // Description:  
	// Convert a list of application names (in json format
    // where each object has the application namd and ID)
    // to a List<String> of IDs.
	//
	// Input: JSON with a list of application name and ID.
	//
	// Returns: List<String> of application IDs.
	public static List<String> parseApplicationNames(String jsonStr) {
        try{
    	    List<String> appList = new List<String>();
            
    		JSONParser parser = JSON.createParser(jsonStr);
			    while (parser.nextToken() != null) {
				    if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
      			  	    while (parser.nextToken() != null) {
        					if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
               				 	while (parser.nextToken() != JSONToken.END_OBJECT) {  
   				 			   		if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
										if (parser.getText().equals('Id')) {
                            		        parser.nextToken();
                                		    appList.add(parser.getText());  
	                                	}                        
	    	                        }
    	    					}
        	    			}
        				}
	    			}
				}        
   			return appList;
        }catch(Exception e){
            throw new EmporiumException(e.getMessage());    
        }
    }
    

    // Description:  
	// Convert a list of application IDs (in json format)
    // to a list of application, where each object contains
    // details about the application as name, package name,
    // identification and so on.
    // 
	//
	// Input: JSON with a list of application ID.
	//
	// Returns: List<EmporiumApplicationDownloadStats>
    // of applications that matched with the Ids passed
    // as argument.
    public static List<EmporiumApplicationDownloadStats>  parse(String jsonStr) {
        try{
            List<EmporiumApplicationDownloadStats> appList = new List<EmporiumApplicationDownloadStats>();
    	    EmporiumApplicationDownloadStats appStats = null;
	        Application app = null;
	        MotorolaCoreDirectory codeDirecory = null;
    	    JSONParser parser = JSON.createParser(jsonStr); 
			
            String categories = ''; 
            while (parser.nextToken() != null) {
				if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
        			while (parser.nextToken() != null) {                    
                    	appStats = new EmporiumApplicationDownloadStats();
	        			app = new Application();
    	    			codeDirecory = new MotorolaCoreDirectory();
                    
        				if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
            	   		 	while (parser.nextToken() != JSONToken.END_OBJECT) {  
   					 	   		if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
	                                if (parser.getText().equals('UploadedOn')){
    	                                parser.nextToken();
                                        String dateStr = parser.getText();
                                        Date dateObj = null;
                                        if(!dateStr.equals('Unknown')) {
        	                                Long statsTime = Long.valueOf(dateStr);
            	                            Datetime dt = Datetime.newInstance(statsTime);
                                            dateObj = dt.date();
                                        }
                	                    appStats.setUploadedOn(dateObj);
                    	            }else if (parser.getText().equals('DateLastDownloaded')){
    	                                parser.nextToken();
                                        String dateStr = parser.getText();
                                        Date dateObj = null;
                                        if(!dateStr.equals('0')) {
        	                                Long statsTime = Long.valueOf(dateStr);
            	                            Datetime dt = Datetime.newInstance(statsTime);
                                            dateObj = dt.date();
                                        }
                	                    appStats.setDateLastDownloaded(dateObj);
                    	            }else if (parser.getText().equals('NumberOfDownloads')) {
                        	            parser.nextToken();
	                                    appStats.setNumberOfDownloads(Integer.valueOf(parser.getText()));  
    	                            }else if (parser.getText().equals('Version')) {
        	                            parser.nextToken();
            	                        appStats.setVersion(parser.getText());
                	                }else if (parser.getText().equals('Name')) {
                    	                parser.nextToken();
                        	            app.setName(parser.getText());
                                        appStats.setName(parser.getText());
                            	    }else if (parser.getText().equals('Package')) {
	                                    parser.nextToken();
                                        String packageName = parser.getText();
    	                                appStats.setPackageName(packageName);
                        	            app.setPackageName(packageName);                                        
        	                        }else if (parser.getText().equals('Id')) {
            	                        parser.nextToken();
                	                    appStats.setUniqueID(parser.getText());
                    	            }else if (parser.getText().equals('UploadedBy')) {
                        	            parser.nextToken();
                            	        String email = parser.getText();
                                	    codeDirecory.setEmail(email);
	                                }else if (parser.getText().equals('Category')) {
                                        parser.nextToken();
                            	        appStats.setCategory(parser.getText());
                                        categories = appStats.getCategory() + ' ';
                                    }else if (parser.getText().equals('ActiveUsersByVersion')) {
                                        parser.nextToken();
                                        if(parser.getCurrentToken() == JSONToken.START_ARRAY){
                                            while (parser.nextToken() != JSONToken.END_ARRAY){
                                                parser.nextToken();
                                                String numberOfDownloads='';
                                                String version='';
                                        		while (parser.getCurrentToken() != JSONToken.END_OBJECT){
                                                    if (parser.getText().equals('NumberOfDownloads')){
                                                    	parser.nextToken();
                                                        numberOfDownloads = parser.getText();                               
                                                    }else if (parser.getText().equals('Version')){
                                                        parser.nextToken();
                                                        version = parser.getText();
                                                    } 
                                                    parser.nextToken();
                                            	}
                                                EmporiumActiveUserByApplicationVersion activeUserByVersion;
                                                activeUserByVersion = new EmporiumActiveUserByApplicationVersion();
                                                activeUserByVersion.numberOfDownloads = Integer.valueOf(numberOfDownloads);
                                                activeUserByVersion.version = version;
                                                appStats.addActiveUsersByVersion(activeUserByVersion);
                                            }                                            
                                        }
                                    }  
    	                                                     
   								}
        					}
                            //if (app.getPackageName() != null){
                                appStats.setApplication(app);                         
                                appStats.setUploadedBy(codeDirecory);
                                appList.add(appStats);   
                            //}
	            		}
    	    		}
    			}
			}
            //EmailManager.send('All categories', categories);
            System.debug(appList);
   			return appList;
	     }catch(Exception e) {
            EmailManager.send('entrou no excepetion ', e.getMessage());
            throw new EmporiumException(e.getMessage());    
        }
    }    

}