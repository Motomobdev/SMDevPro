/**********************************************************/
// Created by: José Elias Araújo
// Created Date: 02/26/2014
// Last Modified: José Elias Araújo
// Last Modified by: 09/11/2014
//
// Description:
// This class is responsible to pull information about 
// applications registered in Emporium tool.
// 
// Test Class: 
// EmporiumDataHandlerTest.cls 
/**********************************************************/
public class EmporiumDataHandler{
    private Http http;        
	private Map<String, String> authParameters = new Map<String, String>();
    private CalloutClass callout;
    private GoogleClientLogin clientLogin;
    
    private String API_SALESFORCE_LIST_URL;
    private String API_SALESFORCE_DETAILS_URL;
               
    // Description:  
    // Constructor method.
    //
    // Input: none
    //
    // Returns: none
	// 
    public EmporiumDataHandler(){
        API_SALESFORCE_LIST_URL = 'https://moto-emporium.appspot.com/api/salesforce/list';
        API_SALESFORCE_DETAILS_URL = 'https://moto-emporium.appspot.com/api/salesforce/details';
        
        String emporiumGoogleAccount;
        try{
            clientLogin = new GoogleClientLogin();
            
            if (!Test.isRunningTest()){        
          		callout = new EmporiumCallout();
                emporiumGoogleAccount = 'EmporiumGoogleAccount';
            }else{
          		callout = new EmporiumCalloutStub();                   
                emporiumGoogleAccount = 'TestAccount';                
            }
            
        	Map<String, EmporiumGoogleAccount__c> accounts = EmporiumGoogleAccount__c.getAll();
 
        	if (accounts.size() > 0){ 
				List<String> accountsNames = new List<String>();
				accountsNames.addAll(accounts.keySet());
				String email = null;    
	   		    String password = null; 
        		boolean hasGoogleAccount = false;
			    for (String accountName : accountsNames) {
                    if (accountName.equals(emporiumGoogleAccount)){
			        	EmporiumGoogleAccount__c account = accounts.get(accountName);
				    	email = account.email__c;
          	        	password = account.password__c;
                        hasGoogleAccount = true;
                    }
			    }
            
                if (!hasGoogleAccount){
                	throw new EmporiumException('There is no custom setting entry called ' +  emporiumGoogleAccount);                 
                }
                
	     	    http = new Http();                   
		     	
                authParameters = clientLogin.login(email,password,'moto-emporium');                   
                
            }else{
	            throw new EmporiumException('There is no custom setting entry called ' +  emporiumGoogleAccount);                 
            }
        }catch(Exception e){
            throw new EmporiumException(e.getMessage() +  ' - ' + e.getStackTraceString());     
        }
    }

    // Description:  
    // Retrieve a list of application ids. 
    // These values can be used to pull
    // the list of information with all fields.
    //
    // Input: none
    //
    // Returns: List<String> of application names.
    // the database
    public List<String> getApplicationNames(){
        try{
            String setCookieHeader = authParameters.get('cookie');
			Map<String, String> headers = new Map<String, String>();
            headers.put('cookie', setCookieHeader);
            
	    	HttpResponse respose = callout.getRequest(API_SALESFORCE_LIST_URL, headers);            
        	String appIdsJSON = respose.getBody();
		    List<String> apps = EmporiumDataParser.parseApplicationNames(appIdsJSON);   
            
	        return apps;
        }catch(Exception e){
            throw new EmporiumException(e.getMessage() +  ' - ' + e.getStackTraceString());    
        }
    }
        
    // Description:  
    // Retrieve a list of applications according to 
    // their ids values
    // passed as argument.
    //
    // Input: List<String> of application names.
    //
    // Returns: List<EmporiumApplication> of 
    // applications registered in emporium.
    //     
	public List<EmporiumApplicationDownloadStats> getApplicationDetails(List<String> appIds){	
        try{
            List<Map<String, String>> listIds = new List<Map<String, String>>();
	        String setCookieHeader = authParameters.get('cookie');            
            
	        Map<String, String> ids = null;
       		for(String appId : appIds){
            	ids = new Map<String, String>(); 
        		ids.put('Id', appId); 
    	     	listIds.add(ids);
	        } 
             
	        String idsJson = JSON.serialize(listIds); 
            Map<String, String> headers = new Map<String, String>();
            headers.put('cookie', setCookieHeader);            
            callout.setTimeout(50000);
	    	HttpResponse res = callout.postRequest(API_SALESFORCE_DETAILS_URL, headers, idsJson);
            String pulledData = res.getBody();           
            
		    List<EmporiumApplicationDownloadStats> appList = EmporiumDataParser.parse(pulledData);
            System.debug(appList.get(0));
	        return appList;
        }catch(Exception e){
            throw new EmporiumException(e.getMessage() +  ' - ' + e.getStackTraceString());    
        }        
    }
        
    // Description:  
    // Method to pull data from emporium and then 
    // save then into safesforce database.
    //
    // Input: none
    //
    // Returns: none
    //    
   	@future (callout=true)
    public static void pullAndSave() {
        try{
            EmporiumDataHandler handler = new EmporiumDataHandler();
        
	        List<String> names = handler.getApplicationNames();
			
    		List<EmporiumApplicationDownloadStats> apps = handler.getApplicationDetails(names);

	        EmporiumPersistence model = new EmporiumPersistence();
	      	model.save(apps);    
        }catch(EmporiumException e){
            EmailManager.send('Error while pulling data from Emporium', e.getMessage());
        }
    }
}