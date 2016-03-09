/**********************************************************/
// Created by: José Elias Araújo
// Created Date: 03/14/2014
// Last Modified: José Elias Araújo
// Last Modified by: 03/20/2014
//
// Description:
// This class represents an launch registered on LaunchCal
// application. 
// 
// Test Class: 
// LaunchCalClassesTest.cls
/**********************************************************/
public class LaunchCal{
	
	private LaunchCal__c launchCalCustom;
	
	// Description:  
	// Constructor method.
	//
	// Input: none
	//
	// Returns: none
	public LaunchCal(){		
		launchCalCustom = new LaunchCal__c();
     	approvers = new List<LaunchCalMotorolaCoreDirectory>();	
	}
	
	// Description:  
	// Defines the launchCal version value.
	//
	// Input: version (Version value)
	//
	// Returns: String representing the launchCal version. 
	public String version { 
		get{
			return launchCalCustom.Version__c;
		} 
		set{
			launchCalCustom.Version__c = value;
		}
	}
	
	// Description:  
	// Defines the status of launchCal.
	//
	// Input: status (Status of launchCal)
	//
	// Returns: String representing the launchCal status. 	
	public String status { 
		get{
			return launchCalCustom.Status__c;
		} 
		set{
			launchCalCustom.Status__c = value;
		}
 	}
	
	// Description:  
	// Defines the name of launchCal.
	//
	// Input: name (Name of launchCal)
	//
	// Returns: String representing the Name of LaunchCal. 		
	public String name { 
		get{
			return launchCalCustom.Name;
		} 
		set{
			String nameValue = value;
			if (value.length() > 80){
				nameValue = value.substring(0, 80);
			}
			launchCalCustom.Name = nameValue;
		}		
	 }
	
	// Description:  
	// Defines the description of launchCal.
	//
	// Input: description (Description of launchCal)
	//
	// Returns: String representing the description of LaunchCal. 		
	public String description {  
		get{
			return launchCalCustom.Description__c;
		} 
		set{
			launchCalCustom.Description__c = value;
		}	
	}
	
	// Description:  
	// Defines the creation date of launchCal.
	//
	// Input: created (Creation date  of launchCal)
	//
	// Returns: String representing the creation date of LaunchCal. 	
	public Date created  { 
		get{
			return launchCalCustom.created_Date__c;
		} 
		set{
			launchCalCustom.created_Date__c = value;
		}			
	 }
	 
	// Description:  
	// Defines the launch date of launchCal.
	//
	// Input: launchDate (Launch date  of launchCal)
	//
	// Returns: String representing the launch date of LaunchCal. 	 
	public Date launchDate  { 
		get{
			return launchCalCustom.Launch_Date__c;
		} 
		set{
			launchCalCustom.Launch_Date__c = value;
		}			
	 }	 
		
	// Description:  
	// Defines the unique identification of launchCal.
	//
	// Input: uniqueId (Unique identification  of launchCal)
	//
	// Returns: String representing the unique identification of LaunchCal. 			
	public String uniqueId  {
		get{
			return launchCalCustom.Unique_Id__c;
		} 
		set{
			launchCalCustom.Unique_Id__c = value;
		}	
	}
	
	// Description:  
	// Defines the product manager of launchCal.
	//
	// Input: productManager (Product manager  of launchCal)
	//
	// Returns: String representing the product manager  of LaunchCal.	
	public String productManager  { 
		get{
			return launchCalCustom.Product_Manager__c;
		} 
		set{
			launchCalCustom.Product_Manager__c = value;
		}			
	 }	 
    
	// Description:  
	// Defines the application related to launchCal.
	//
	// Input: application (Application related to launchCal)
	//
	// Returns: String representing application related to LaunchCal.    
    public Application application {		
    	get{
			return application;
		} 
		set{
			application = value;
			launchCalCustom.Application__c = application.getSObject().ID;
		}	
	}
    
    
	// Description:  
	// Defines the responsible to create the launchCal.
	//
	// Input: createdBy (Responsible to create the launchCal)
	//
	// Returns: String representing responsible to create the LaunchCal.      
	public MotorolaCoreDirectory createdBy  {
    	get{
			return createdBy;
		} 
		set{
			createdBy = value;
			launchCalCustom.CreatedBy__c = createdBy.getSObject().ID;
		}	
	}
    
	// Description:  
	// Defines a list of LaunchCalMotorolaCoreDirectory  that
	// represents a subscriber or approver.
	//
	// Input: approvers (List of approver or subscriber)
	//
	// Returns: List<LaunchCalMotorolaCoreDirectory> of approvers or subscribers. 
    public List<LaunchCalMotorolaCoreDirectory> approvers { get; set; }
    

	// Description:  
	// Builds an LaunchCal__c custom object with
	// all fields filled.
	//
	// Input: none
	//
	// Returns: LaunchCal__c custom object.      
    public LaunchCal__c getSObject(){
    	return launchCalCustom;
    }
    
    
	
	
	

}