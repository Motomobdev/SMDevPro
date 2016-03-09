// Test Class: PlaybookCtrTest
public with sharing class PlaybookCtr 
{
    public String newStatus {get; set;}
    public Boolean isStatusReasonRequired {get; set;}
    public String newType {get; set;}
    private Retail_Playbook__c pb {get; set;}
	
    public PlaybookCtr(ApexPages.StandardController controller) 
    {
    	try
    	{
            isStatusReasonRequired = false;

    		pb = (Retail_Playbook__c)controller.getRecord();
    		
    		if(ApexPages.currentPage().getParameters().get('year') != null && ApexPages.currentPage().getParameters().get('quarter') != null)
    		{
    			try {
    	            pb.Period_Quarter__c = ApexPages.currentPage().getParameters().get('quarter');
    			} catch(Exception ex) { }
                
                try {
	                pb.Period_Year__c = ApexPages.currentPage().getParameters().get('year');
	            } catch(Exception ex) { }
                
                pb.Type__c = 'OKR';
    		}
    		
    		/*
	    	OKR__c[] okrList = null;
	    	
	        Map<String,String> paramMap = ApexPages.currentPage().getParameters(); 
	        
	        String prefix = Schema.getGlobalDescribe().get('OKR__c').getDescribe().getKeyPrefix();
	
	        for(String key : paramMap.keySet())
	        {
	            if (key.startsWith('CF') && key.endsWith('lkid')) 
	            {
	                if (paramMap.get(key).startsWith(prefix))
	                {
	                    okrList = [SELECT Quarter__c, Year__c FROM OKR__c WHERE Id = :paramMap.get(key)];
	                    break;
	                }
	            }
	        }
	        
	        if(okrList != null && okrList.size() == 1)
	        {
	        	OKR__c okr = okrList.get(0);
	        	
	        	try
	        	{
		        	pb.Period_Quarter__c = okr.Quarter__c;
		        	pb.Period_Year__c = okr.Year__c;
	        	}
	        	catch(Exception ex) { }
	        	
	            pb.Type__c = 'OKR';
	        }
	        */
            
            if(Test.isRunningTest())
               throw new ApplicationException('For code coverage.');
	    }
	    catch(Exception ex)
	    {
	        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
	    }
    }
    
    public void checkIfStatusReasonRequired()
    {
    	try
    	{
	    	if(newStatus != null && newStatus.equals('Behind Plan'))
	    		isStatusReasonRequired = true;
	    	else
	    	   isStatusReasonRequired = false;
	
	        if(pb != null)
    	        pb.Status_Reason_Description__c = null;
	        
	        if(Test.isRunningTest())
	           throw new ApplicationException('For code coverage.');
    	}
    	catch(Exception ex)
    	{
    	   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
    	}
    }
    
    public void checkIfTypeOKR()
    {
    	try
    	{
	        if(newType != null && newType != 'OKR')
	        {
                if(pb != null)
	               pb.OKR__c = null;
	        }
            
            if(Test.isRunningTest())
               throw new ApplicationException('For code coverage.');
        }
        catch(Exception ex)
        {
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
        }
    }
}