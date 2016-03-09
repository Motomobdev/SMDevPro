/**********************************************************/
// Created by: José Elias Araújo
// Created Date: 03/14/2014
// Last Modified: José Elias Araújo
// Last Modified by: 03/14/2014
//
// Description:
// This class is able to handle information about a 
// motorolan.
// 
// Test Class: 
// 
/**********************************************************/
public class MotorolaCoreDirectory{
   
    private Motorola_Core_Directory__c sObjectCoreDirectory;
    
    // Description:  
	// Constructor method.
	//
	// Input: none
	//
	// Returns: none
    public MotorolaCoreDirectory(){
        sObjectCoreDirectory = new Motorola_Core_Directory__c();
    }
    
    // Description:  
	// Constructor method.
	//
	// Input: coreDirectory (An instance of 
    // Motorola_Core_Directory__c)
	//
	// Returns: none    
    public MotorolaCoreDirectory(Motorola_Core_Directory__c coreDirectory){
        sObjectCoreDirectory = coreDirectory;
    }
    
    // Description:  
	// Gets sn instance of custom object with all
    // information saved in the current instance.
	//
	// Input: none
	//
	// Returns: Motorola_Core_Directory__c with all 
    //			information saved in the current instance.
    public Motorola_Core_Directory__c getSObject(){
        return sObjectCoreDirectory;
    }
    
    // Description:  
	// Sets the email address value.
	//
	// Input: email (The email value)
	//
	// Returns: none    
    public void setEmail(String email){
        sObjectCoreDirectory.mail__c = email;
    }
    
    // Description:  
	// Gets the email address value.
	//
	// Input: none
	//
	// Returns: String of email address.        
    public String getEmail(){
        return sObjectCoreDirectory.mail__c;
    }
    
}