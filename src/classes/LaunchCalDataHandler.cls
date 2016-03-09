/**********************************************************/
// Created by: José Elias Araújo
// Created Date: 03/20/2014
// Last Modified: José Elias Araújo
// Last Modified by: 05/28/2014
//
// Description:
// This class is responsible to pull information about 
// launches registered in LaunchCal tool. Basically, it uses 
// a REST API available in the tool in order to get these 
// informaiton. Before this, it is required to authenticate
// on Google service.
//
// 
// Test Class: 
// LaunchCalDataHandlerTest.cls 
/**********************************************************/ 
public class LaunchCalDataHandler{
    private Http http;        
	private Map<String, String> authParameters = new Map<String, String>();
    private CalloutClass callout;
    private GoogleLogin clientLogin; 
    private String LAUNCHCAL_METAMODEL_API_URL;
    private String LAUNCHCAL_LAUNCHES_API_URL;    
    
                
    // Description:  
    // Constructor method.
    //
    // Input: none
    //
    // Returns: none
	// 
    public LaunchCalDataHandler(){  
        LAUNCHCAL_METAMODEL_API_URL = 'http://ariane.motorola.com/api/metamodel';
        LAUNCHCAL_LAUNCHES_API_URL = 'http://ariane.motorola.com/api/launches';
        
        String googleAccount; 
        try{
            clientLogin = new LaunchCalGoogleLogin();
            
            if (!Test.isRunningTest()){        
          		callout = new EmporiumCallout();
                googleAccount = 'LaunchCalGoogleAccount';
            }else{
          		callout = new LaunchCalCalloutStub();                   
                googleAccount = 'TestAccount';                
            }
            
        	Map<String, LaunchCalGoogleAccount__c> accounts = LaunchCalGoogleAccount__c.getAll();
 
        	if (accounts.size() > 0){
				List<String> accountsNames = new List<String>();
				accountsNames.addAll(accounts.keySet());
				String email = null;    
	   		    String password = null; 
        		boolean hasGoogleAccount = false;
			    for (String accountName : accountsNames) {
                    if (accountName.equals(googleAccount)){
			        	LaunchCalGoogleAccount__c account = accounts.get(accountName);
				    	email = account.email__c;
          	        	password = account.password__c;
                        hasGoogleAccount = true;
                    }
			    }
            
                if (!hasGoogleAccount){
                	throw new LaunchCalException('There is no custom setting entry called ' +  googleAccount);                 
                }
                
	     	    http = new Http();                   
		     	authParameters = clientLogin.login(email,password);                    
                
            }else{
	            throw new LaunchCalException('There is no custom setting entry called ' +  googleAccount);                 
            }
        }catch(Exception e){
            throw new LaunchCalException(e.getMessage());     
        }
    }

    // Description:  
    // This method is responsible to access LaunchCal
    // Rest API and then to pull informaiton about
    // launches in JSON format.
    //
    // Input: none
    //
    // Returns: String of launches in json format.
    // the database
	@TestVisible List<String> getLaunchesJSON(Integer initialPosition){
        String contNumber = String.valueOf(initialPosition);
        List<String> jsonList = new List<String>();
     	String setCookieHeader = authParameters.get('cookie');
		Map<String, String> headers = new Map<String, String>();
        headers.put('cookie', setCookieHeader);   
                
        while(!contNumber.equals('null') && (Limits.getCallouts() < Limits.getLimitCallouts())){        	
	    	HttpResponse response = callout.getRequest(LAUNCHCAL_LAUNCHES_API_URL + '?cont=' + contNumber, headers);  
	    	String json;
	    	if (response.getStatusCode() == 200){ 
	       		json = response.getBody();         
	        	json = json.replace(')]}\',', '');
	        	json = json.replace('\r\n', '');        
	        	json = json.trim();
	    	}else{
            	throw new LaunchCalException('It is not possible to get information from LaunchCal tool'); 	    	
	    	}
        
			String regex = '^.*"continuationToken":"([^"]*)".*$';
			Matcher matcher = Pattern.compile(regex).matcher(json);
			if(matcher.matches()) {
				contNumber = matcher.group(1);
			}else{
				contNumber = 'null';
			}        
          
        	jsonList.add(json);
        }
          
        // The scheduler to get the next dataset is not executed if this method is invoked by a test case.  
        if (!Test.isRunningTest() && (!contNumber.equals('null') && Limits.getCallouts() == Limits.getLimitCallouts())){
        	String hour = String.valueOf(Datetime.now().hour());
			String min = String.valueOf(Datetime.now().minute() + 1); 
			String ss = String.valueOf(Datetime.now().second());

			String nextFireTime = ss + ' ' + min + ' ' + hour + ' * * ?'; 

			System.schedule('NextLaunchCalDataHandler_record_' + contNumber, nextFireTime, new LaunchCalScheduler(Integer.ValueOf(contNumber)));

        }
        return jsonList;              
	} 
        
	// Description:  
    // Perform all steps to get information from LaunchCal.
    // Basically, this method authenticates on Google service,
    // get all launcges registered in LaunchCal by using its
    // REST API, convert the json in objects and then save
    // everything in the salesforce database.
    //
    // This is a future, in order words, this methos will fire
    // all process in another thread.
    //
    // Input: initialPosition of records to be pulled. 
    //
    // Returns: none   
    @future (callout=true)    
    public static void importData(Integer initialPosition){    
    	try{		        
    		List<String> totalOfErrors = new List<String>();
            LaunchCalDataParser launchCalParser = new LaunchCalDataParser();
	    	LaunchCalDataHandler handler = new LaunchCalDataHandler();
	    	List<String> JSONLaunches = handler.getLaunchesJSON(initialPosition);
            for (String JSONLaunche : JSONLaunches){
	        	List<LaunchCal> launches = launchCalParser.getLaunches(JSONLaunche);	                                
	    		LaunchCalPersistence persistence = new LaunchCalPersistence();
	    		List<String> errors = persistence.save(launches);
	    		totalOfErrors.addAll(errors);
            }
            
            if (totalOfErrors.size() > 0){
           		String errorNotification = 'The following validation errors occured during all pulling process. The LaunchCal record set starts on position ' + initialPosition + '\r\n\r\n';
				for(String error : totalOfErrors){
    		    	errorNotification += ' - ' + error + '\r\n';
     			}	
     			EmailManager.send('Summary of validation performed when pulling data from LaunchCal tool on ' + Datetime.now().format('MMMM d, yyyy'), errorNotification);
            }
    	}catch(Exception e){
			EmailManager.send('Errors on LaunchCal integration process:\r\n\r\n', e.getMessage() +  ' - ' + e.getStackTraceString());
		} 
    }
     
}