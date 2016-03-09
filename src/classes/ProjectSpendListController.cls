/***************************
// Created By: Gram Bischof
// Last Modified: 6/7/2014
// Description:
// Controller class for the
// ProjectSpendList.page
//
// Test Class:
// TestProjectSpendListController.cls
****************************/
public class ProjectSpendListController {

	public String MMID {get;set;}
    public String TypeName {get;set;}
	public Boolean verified {get;set;}
	private Motorola_Core_Directory__c MMIDusr;
	public List<Project_Spend__c> projects {get;set;}
	

	public ProjectSpendListController(){
		verified = false;
		projects = new List<Project_Spend__c>();
		MMID = ApexPages.CurrentPage().getParameters().get('MMID');
		if(MMID != null) verified = validateMMID(MMID);
        TypeName = ApexPages.CurrentPage().getParameters().get('Type');
	}
	
	public void validateMMIDInput(){
		verified = validateMMID(MMID);
	}
	
	// Copied from ContractRequestFormCtr.cls
	public Boolean validateMMID(String MMIDInput) 
    {
        try
        {
            MMIDInput = MMIDInput.toUpperCase();
                
            Motorola_Core_Directory__c[] usr = [SELECT Id,
                                                       Name,
                                                       MMID__c,
                                                       MobilePhone__c,
                                                       WorkPhone__c,
                                                       OrgLevel1__c, 
                                                       OrgLevel2__c, 
                                                       OrgLevel3__c
                                                FROM   Motorola_Core_Directory__c
                                                WHERE  MMID__c = :MMIDInput AND
                                                       DirectoryStatus__c = 'A'];
            if(usr.size() == 1)
            { 
            	MMIDusr = usr.get(0);
            	projects = [Select id,Name,Name__c,SSR_Status__c From Project_Spend__c Where Requester__c = :MMIDUsr.id];
                return true;
            }
            else
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'MMID is invalid or inactive.'));
            }
            
        }
        catch(Exception ex)
        {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()); 
        	ApexPages.addMessage(msg);
        }
        
        return false;
    }
   
}