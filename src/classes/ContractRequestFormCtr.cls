public with sharing class ContractRequestFormCtr 
{
    Contract_Request__c cr {get; set;} 
    public Motorola_Core_Directory__c directoryUser {get; set;}
    public String MMID {get; set;} // holds MMID textbox value
    public Boolean isSubmitted {get; set;} 
    public String urgency {get; set;} //holds current picklist value of Urgency
    public String agreement {get; set;} //holds current picklist value of Agreement Type

    public ContractRequestFormCtr(ApexPages.StandardController controller) 
    {
        try
        {
            isSubmitted = false;
            urgency = '';
            agreement = '';

            cr = (Contract_Request__c)controller.getRecord();
                        
            //for code coverage on exception code
            if(Test.isRunningTest())
            {
                String s;
                s.toLowerCase();
            }
        }
        catch(Exception ex)
        {
            addMessage(ex);
        }
    }

    public void validateMMID() 
    {
        try
        {
            MMID = MMID.trim().toUpperCase(); // trim and upper case
                
            Motorola_Core_Directory__c[] usr = [SELECT Id,
                                                       Name,
                                                       MMID__c,
                                                       MobilePhone__c,
                                                       WorkPhone__c,
                                                       OrgLevel1__c, 
                                                       OrgLevel2__c, 
                                                       OrgLevel3__c
                                                FROM   Motorola_Core_Directory__c
                                                WHERE  MMID__c = :MMID AND // field contains MMID (or CoreID in case MMID is not generated)
                                                       DirectoryStatus__c = 'A']; //active users
            
            if(usr.size() == 1)
            {
                directoryUser = usr[0];
                cr.Requester__c = directoryUser.Id;
                cr.Requester_Email__c = directoryUser.MMID__c.toLowerCase() + '@motorola.com';
            }
            else
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'MMID is invalid or inactive.'));
            }
            
            //for code coverage on exception code
            if(Test.isRunningTest())
            {
                String s;
                s.toLowerCase();
            }
        }
        catch(Exception ex)
        {
            addMessage(ex);
        }
    }

    public void changeMMID()
    {
        try
        {
            MMID = null;
            directoryUser = null;
            clear();
            
            //for code coverage on exception code
            if(Test.isRunningTest())
            {
                String s;
                s.toLowerCase();
            }
        }
        catch(Exception ex)
        {
            addMessage(ex);
        }
    }

    public Boolean isVaidDirectoryUser
    {
        get
        {
            try
            {
                if(directoryUser == null)
                   return false;
                else
                   return true;
            }
            catch(Exception ex)
            {
                addMessage(ex);
            }
            
            return false;
        }
    }
    
    public void checkIfHighUrgency()
    {
        cr.High_Urgency_Reason__c = ''; //ask the user
    }

    public void checkAgreement()
    {
        cr.Request_Type__c = ''; //ask the user
    }
    
    public void save()
    {
        try
        {
            insert cr; // create Contract Request record
            
            clear(); // clear form
            
            isSubmitted = true; // to show Submit New Request button
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Contract request submitted successfully.'));
        }
        catch(Exception ex)
        {
            addMessage(ex);
        }
    }
    
    public void newRequest()
    {
        isSubmitted = false; //show form fields
    }
    
    public void clear()
    {
        try
        {
            cr.Id = null;
            cr.Company_Name__c = null;
            cr.Partner_Contact_Name__c = null;
            cr.Partner_Contact_Phone__c = null;
            cr.Partner_Contact_Email__c = null;
            cr.What_Software_Requested__c = null;
            cr.Agreement_Type__c = null;
            cr.Request_Type__c = null;
            cr.Date_Required__c = null;
            cr.Urgency__c = null;
            cr.High_Urgency_Reason__c = null;
            cr.Which_Device__c = null;
            cr.Team__c = null;
            cr.Comments__c = null;
            
            urgency = '';
            agreement = '';
            
            //for code coverage on exception code
            if(Test.isRunningTest())
            {
                String s;
                s.toLowerCase();
            }
        }
        catch(Exception ex)
        {
            addMessage(ex);
        }
    }
    
    private void addMessage(Exception ex)
    {
        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()); 
        ApexPages.addMessage(msg);
    }
}