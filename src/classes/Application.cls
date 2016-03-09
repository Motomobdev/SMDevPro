/**********************************************************/
// Created by: José Elias Araújo
// Created Date: 03/14/2014
// Last Modified: José Elias Araújo
// Last Modified by: 03/20/2014
//
// Description:
// This class represents an application registered on Emporium. 
// 
// Test Class: 
// 
/**********************************************************/
public class Application{
    
    private Application__c sObjectApplication;
    private String name;
    private String packageName;
    private String applicationId;

    // Description:  
	// Contructor method
    //
	// Input: none
	//
	// Returns: none
    public Application(){
        sObjectApplication = new Application__c();
    }
        
    // Description:  
	// Sets the ID of application used in salesforce.
    //
	// Input: id (Id of application in salesforce)
	// 
	// Returns: none    
    public void setApplicationID(String id){
        this.applicationId = id;        
    }

    // Description:  
	// Gets the id of application used in salesforce.
    //
	// Input: none
	//
	// Returns: id of application used in salesforce       
    public String getApplicationID(){
        return applicationId;
    }
    

    // Description:  
	// Sets the name of application.
    //
	// Input: name (Name of application)
	//
	// Returns: none    
    public void setName(String name){
        this.name = name;
    }

    // Description:  
	// Gets the name of application.
    //
	// Input: none
	//
	// Returns: String of application name       
    public String getName(){
        return name;
    }

    // Description:  
	// Sets the name of package.
    //
	// Input: packageName (name of package)
	//
	// Returns: none
    public void setPackageName(String packageName){
        this.packageName = packageName;
    }

    // Description:  
	// Gets the name of package.
    //
	// Input:  none
	//
	// Returns: String of package name    
    public String getPackageName(){
        return packageName;
    }            

    // Description:  
	// Constructor method.
    //
	// Input: application (Custom object of application)
	//
	// Returns: none
    public Application(Application__c application){
        name = application.Name;
        packageName = application.Package_Name__c;
        applicationId = application.Application_ID__c;
        sObjectApplication = application;
    }
    
    // Description:  
	// Gets custom object of application.
    //
	// Input: none
	//
	// Returns: Application__c of application    
    public Application__c getSObject(){
        sObjectApplication.Name = name;
		sObjectApplication.Package_Name__c = packageName;
		//sObjectApplication.Application_ID__c = applicationId;
        return sObjectApplication;
    }
                       
}