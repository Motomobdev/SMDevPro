/**********************************************************/
// Created by: José Elias Araújo
// Created Date: 03/27/2014
// Last Modified: José Elias Araújo
// Last Modified by: 04/08/2014
//
// Description:
// This class is able to convert JSON data in a map structure.
// 
// Test Class: 
// LaunchCalCalssesTest.cls
/**********************************************************/
public class LaunchCalMotorolaCoreDirectory {
	
	public enum Type {Approver, Subscriber}
	
	LaunchCal_Motorola_Core_Directory__c launchCalMotorolaCoreDirectoryCustom;
	
	// Description:  
	// Builds a LaunchCalMotorolaCoreDirectory that is an approver
	//
	// Returns: A LaunchCalMotorolaCoreDirectory that is an approver 
	public static LaunchCalMotorolaCoreDirectory buildApprover(){
		return new LaunchCalMotorolaCoreDirectory(Type.Approver);
	}
	
	// Description:  
	// Builds a LaunchCalMotorolaCoreDirectory that is a subscriber
	//
	// Returns: A LaunchCalMotorolaCoreDirectory that is a subscriber 
	public static LaunchCalMotorolaCoreDirectory buildSubscriber(){
		return new LaunchCalMotorolaCoreDirectory(Type.Subscriber);
	}
	
	// Description:  
	// Defines the type of LaunchCalMotorolaCoreDirectory.
	//
	// Input: Type (Type of LaunchCalMotorolaCoreDirectory)
	//
	// Returns: Type representing the type of LaunchCalMotorolaCoreDirectory. 
	public Type launcherType{
		get{
			return launcherType;
		}
		set {
			launcherType = value;
		}
	}
	
	// Description:  
	// Defines the type of LaunchCalMotorolaCoreDirectory.
	//
	// Input: Type (Type of LaunchCalMotorolaCoreDirectory)
	//
	// Returns: Type representing the type of LaunchCalMotorolaCoreDirectory. 
	private LaunchCalMotorolaCoreDirectory(Type launcherType){
		launchCalMotorolaCoreDirectoryCustom = new LaunchCal_Motorola_Core_Directory__c();
		this.launcherType = launcherType;
        launchCalMotorolaCoreDirectoryCustom.Name = launcherType.name();
	}
	
	// Description:  
	// Defines the approval status of LaunchCalMotorolaCoreDirectory.
	//
	// Input: String (Approval Status of LaunchCalMotorolaCoreDirectory)
	//
	// Returns: String representing the Approval Status of LaunchCalMotorolaCoreDirectory. 
	public String approvalStatus { 
		get{
			return launchCalMotorolaCoreDirectoryCustom.Approval_Status__c;
		} 
		set{
			launchCalMotorolaCoreDirectoryCustom.Approval_Status__c = value;
		}	
	}
	
	// Description:  
	// Defines the date of flipp of LaunchCalMotorolaCoreDirectory.
	//
	// Input: Date (Date of flipp of LaunchCalMotorolaCoreDirectory)
	//
	// Returns: Date representing the Date of flipp of LaunchCalMotorolaCoreDirectory. 
	public Date flippedOn {
		get{
			return launchCalMotorolaCoreDirectoryCustom.Flipped_On__c;
		} 
		set{
			launchCalMotorolaCoreDirectoryCustom.Flipped_On__c = value;
		}			
    }
	
	// Description:  
	// Defines the MotorolaCoreDirectory who flipped the LaunchCalMotorolaCoreDirectory.
	//
	// Input: MotorolaCoreDirectory (MotorolaCoreDirectory who flipped the LaunchCalMotorolaCoreDirectory)
	//
	// Returns: MotorolaCoreDirectory representing the MotorolaCoreDirectory who flipped the LaunchCalMotorolaCoreDirectory. 
	public MotorolaCoreDirectory flippedBy { 
		get{
			return flippedBy;
		} 
		set{
			if (value != null){
            	flippedBy = value;
				launchCalMotorolaCoreDirectoryCustom.Flipped_By__c = flippedBy.getSObject().ID;	
			}else{
				launchCalMotorolaCoreDirectoryCustom.Flipped_By__c = null;
			}	
		}			
    }		
	
	// Description:  
	// Defines the notes of LaunchCalMotorolaCoreDirectory.
	//
	// Input: String (Notes of LaunchCalMotorolaCoreDirectory)
	//
	// Returns: String representing the Notes of LaunchCalMotorolaCoreDirectory. 
	public String notes { 
		get{
			return launchCalMotorolaCoreDirectoryCustom.Notes__c;
		} 
		set{
			launchCalMotorolaCoreDirectoryCustom.Notes__c = value;
		}		
    }
    
    // Description:  
	// Defines the Unique ID of LaunchCalMotorolaCoreDirectory.
	//
	// Input: String (Unique ID of LaunchCalMotorolaCoreDirectory)
	//
	// Returns: String representing the Unique ID of LaunchCalMotorolaCoreDirectory. 
	public String uniqueID { 
		get{
			return launchCalMotorolaCoreDirectoryCustom.Unique_ID__c;
		} 
		set{
			launchCalMotorolaCoreDirectoryCustom.Unique_ID__c = value;
		}		
    }
	
	// Description:  
	// Defines the name of LaunchCalMotorolaCoreDirectory.
	//
	// Input: String (Name ID of LaunchCalMotorolaCoreDirectory)
	//
	// Returns: String representing the name of LaunchCalMotorolaCoreDirectory. 
	public String name { 
		get{
			return launchCalMotorolaCoreDirectoryCustom.Name;
		} 
		set{
            if (!value.trim().equals('')){
				launchCalMotorolaCoreDirectoryCustom.Name = launcherType.name() + ' - ' + value;
            }
		}		
    }	    
	
	// Description:  
	// Defines the SObject of LaunchCalMotorolaCoreDirectory.
	//
	// Input: LaunchCal_Motorola_Core_Directory__c (SObject of LaunchCalMotorolaCoreDirectory)
	public LaunchCal_Motorola_Core_Directory__c getSObject(){
		return launchCalMotorolaCoreDirectoryCustom;
	}

}