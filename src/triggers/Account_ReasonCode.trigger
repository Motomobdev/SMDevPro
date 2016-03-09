/*******************************
Modified By: Neel Desai
Modified On: 24-Aug-2012
Reference: VHD Ticket # 44023
*******************************/

trigger Account_ReasonCode on Account (before update) 
{
    List<Contract> Contracts = [SELECT Id, Account.Id FROM Contract WHERE Account.Id IN :Trigger.New];
  	List<Contract> contractsToUpdate = New List<Contract>();
	
   	for(Integer i=0; i<trigger.new.size(); i++)
	{ 
    	for(Contract c: Contracts)
		{
    		if(Trigger.New[i].Id == c.Account.Id)
			{
				// Updated Account Info (updated account name)
	            if(Trigger.New[i].Name  != Trigger.Old[i].Name)
	            {
	                c.Reason_Code__c = 'VC';
	                c.Reason_Code_Last_Modified_Date__c = DateTime.now();
	                contractsToUpdate.add(c);
				}
        		else if(Trigger.New[i].eGVM_Number__c != Trigger.Old[i].eGVM_Number__c)
				{
            		c.Reason_Code__c = 'TC';
	                c.Reason_Code_Last_Modified_Date__c = DateTime.now();
            		contractsToUpdate.add(c);
				}
	            // Updated Countries (updated account billing country)
	            else if(Trigger.New[i].Billing_Country__c != Trigger.Old[i].Billing_Country__c)
	            {
	                c.Reason_Code__c = 'CC';
	                c.Reason_Code_Last_Modified_Date__c = DateTime.now();
            		contractsToUpdate.add(c);
	            }
        		else if(Trigger.New[i].Tax_Withholding__c != Trigger.Old[i].Tax_Withholding__c)
        		{
            		c.Reason_Code__c = 'TX';
	                c.Reason_Code_Last_Modified_Date__c = DateTime.now();
            		contractsToUpdate.add(c);
        		}
        		else if(Trigger.New[i].Valid_W_8BEN__c != Trigger.Old[i].Valid_W_8BEN__c)
        		{
            		c.Reason_Code__c = 'WB';
	                c.Reason_Code_Last_Modified_Date__c = DateTime.now();
            		contractsToUpdate.add(c);  
        		}   
        		else if(Trigger.New[i].OwnerId != Trigger.Old[i].OwnerId)
        		{   
            		c.Reason_Code__c = 'PM';
	                c.Reason_Code_Last_Modified_Date__c = DateTime.now();
            		contractsToUpdate.add(c);
        		}
    		}   
		}
	}
	
    update contractsToUpdate;
}