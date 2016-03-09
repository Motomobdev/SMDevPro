public class NewDealController {
        
    public Account acct {get;set;}
    public List<Account> accts {get; set;}
    public Opportunity oppt {get;set;}
    public Quote qt {get; set;}
    public Boolean pageIsValid {get;set;}
    
    // cmunoz@levementum.com. 09/18/14. Description: Check whether a deal is created from an opportunity or an Account
    public Boolean OpportunityCreation {get; set;}
    public String oppId {get; set;}
    public String associatedAccount {get; set;}
    public List<Account> accountObj = null;
    public List<Opportunity> oppObj {get; set;}
    public String updatedYear {get; set;}
    public String updatedQuarter {get; set;}
    
    // cmunoz@levementum.com. 09/19/14. Description: Added Executive Summary
    public Note execNote {get; set;} 
    public Id opptId = null;
    
    //cmunoz@levementum.com. 09/24/14. Account Read only based on creation process (i.e. from Account or from Opportunity)
    public Boolean readOnlyAccount {get; set;}
    public Boolean fromOpportunity {get; set;}
    public String opptYear {get; set;}
    public String opptQuarter {get; set;}
     
    public NewDealController(){ 
        pageIsValid = true;
        qt = new Quote();
       oppt = new Opportunity();
       execNote = new Note();
       acct = new Account();
       opptYear = 'NA';
       opptQuarter = 'NA';
        //Make sure there is an ID query param
        if(ApexPages.currentPage().getParameters().get('ID') != null){
            //Make sure the ID is to an actual existing account
            List<Account> accts = [select name,id from account where id = :ApexPages.currentPage().getParameters().get('ID') limit 1];
            if(accts.size() == 1)
            {
                    fromOpportunity = false; // not created form Opportunity
                    acct = accts[0];
                    opportunityCreation = true;
                    acct.Name = accts[0].Name;
                    readOnlyAccount = true;  
            }
            // cmunoz@levementum.com. 09/18/14. Description: Get current opportunity Id.  
            else
            {
                fromOpportunity = true;
                oppId = ApexPages.currentPage().getParameters().get('ID');
                opportunityCreation = false;
                
                oppObj = new List<Opportunity>([SELECT AccountId, Name, Year__c, Quarter__c FROM Opportunity where id=:oppId limit 1]); 
                String accId = ''; 
                if(oppObj.size() > 0)
                {           
                    accId = oppObj[0].AccountId;
                    opptYear = oppObj[0].Year__c;
                    opptQuarter = oppObj[0].Quarter__c;
                }
                accountObj = new List<Account>([SELECT Name FROM Account where id=:accId limit 1]);
                if(accountObj.size() > 0)
                {
                    acct = accountObj[0];
                    associatedAccount = accountObj[0].Name;
                }
                else
                {
                    associatedAccount = 'No Account Selected';
                }
                if(accts.size() <= 0 && accountObj.size() > 0)
                {
                    acct.Name = accountObj[0].Name;
                    readOnlyAccount = true;  
                }
                
                if(opptYear == null || opptQuarter == null)
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, 'Please make sure your opportunity has a year and a quarter.'));
                    pageIsValid = false;
                }   
            }                             
        }
        else{
            System.debug('No ID Query Parameter was found');
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, 'An unexpected error has occurred.'));
            pageIsValid = false;
        }
    }
    
    public pageReference createDeal(){
        pageReference pr = null;
        if(pageIsValid){
            opptId = null;
            // cmunoz@levementum.com. 09/18/14. Description: Check whether a deal is created from an opportunity or an Account
            if(opportunityCreation)
            {
                opptId = createOppt();
            }
            else
            {
                opptId = oppId;
            }
            if(opptId != null){
                Id quoteId = createQuote(opptId);
                addExecutiveNote(quoteId);
                if(quoteId != null){
                    pr = new pageReference('/apex/DealView?qId='+quoteId);
                }
                else{
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'An unexpected error has occurred. Please contact your administrator'));
                }
            }
            else{
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'An unexpected error has occurred. Please contact your administrator'));
            }
        }
        return pr;
    }
    
    /**
     * @author: Cuauhtemoc Munoz
     * @date:   09/19/14
     * @email:  cmunoz@levementum.com
     * @description:    Adds executive note to be used on DealView.page under Summary Tab
     */
    public void addExecutiveNote(Id quoteId)
    {
        try
        {
            execNote.IsPrivate = false;
            execNote.Title = 'Executive Summary';
             if(execNote.parentId != null)
             {
                update execNote;
            }
            else
            {
                execNote.parentId = quoteId;
                execNote.OwnerId = UserInfo.getUserId();
                insert execNote; //insert the record
            }
        }
        catch(Exception ex)
        {
            system.debug('ERROR ADD NOTE ' + ex.getMessage());
        }
    }
    
    public pageReference cancel(){
        //If we now the account to send them back to send them, if not send them to the home page
         string loc = acct != null ? '/'+acct.Id : '../home/home.jsp';
        PageReference pageRef = new PageReference(loc);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    private Id createOppt(){
        Id opptId = null;
        Id rtid = [select id from recordtype where sobjecttype = 'Opportunity' and developername = 'Deal' limit 1].Id;

        oppt.RecordTypeId = rtid;
        oppt.AccountId = acct.Id;
        oppt.CloseDate = Date.today().AddYears(1);
        oppt.StageName = '1. Prospecting';
        //awilkinson@levementum.com 3/26/15 defaulting to USD
        oppt.CurrencyIsoCode = 'USD';
        // jescamilla@levementum.com 9/4/14 Description: Adding Pricebook Entry to Avoid Field Integrity When quote is being created.
        Pricebook2 standardPb = [select id, name, isActive from Pricebook2 where isStandard=true];
        oppt.Pricebook2Id = standardPb.Id;
        
        try{
            insert oppt;
            opptId = oppt.Id;
        }
        catch(exception e){
            system.debug(e.getMessage() + 'createOppt()');
        }

        return opptId;
    }
    
    private Id createQuote(Id opptId){
        Id quoteId = null;
        try
        {
            // jescamilla@levementum.com 1/25/15 Description: When bundle deals were activated we need to specify to quote that deal recordtype is required.
            Id qtDealRecTypeId = [SELECT id FROM recordtype WHERE sobjecttype = 'Quote' AND developername = 'Deal' limit 1].Id;
            if(qtDealRecTypeId != null){
                qt.recordTypeId = qtDealRecTypeId;
            }
            qt.OpportunityId = opptId;       
             // cmunoz@levementum.com. 09/18/14. Description: Get opportunity name based on query quote id. 
            if(!opportunityCreation)
            {
                if(oppObj.size() > 0)
                {
                    qt.Name = oppObj[0].Name;
                    qt.Account__c = oppObj[0].AccountId;
                }
                else
                {
                    qt.Name = 'NA';
                }
            }
            else
            {
                qt.Name = oppt.Name;
            }                    
            
            // cmunoz@levementum.com. 09/18/14. Description: Account available as long as we create a deal from Accounts
            if(opportunityCreation)
            {
                qt.Account__c = acct.Id;
            }
            
            // jescamilla@levementum.com 9/4/14 Description: Adding Pricebook Entry to Avoid Field Integrity When quote is being created.
            Pricebook2 standardPb = [select id, name, isActive from Pricebook2 where isStandard=true];
            qt.Pricebook2Id = standardPb.Id;
            qt.ExecutiveSummary__c = execNote.body;

            try{
                insert qt;
                quoteId = qt.Id;
                
                // cmunoz@levementum.com. 09/18/14. Description: Updates current opportunity with selected year and quarter
                if(!opportunityCreation)
                {
                    
                    /*List<Opportunity> oppObj = new List<Opportunity>([Select Year__c, Quarter__c from Opportunity where id =: opptId]);
                    if(oppObj.size() > 0)
                    {
                        oppObj[0].Year__c = oppt.Year__c;
                        oppObj[0].Quarter__c = oppt.Quarter__c;
                        system.debug(oppObj[0].Year__c  + ' ' + oppObj[0].Quarter__c);
                        upsert oppObj;
                    }*/
                }
            }
            catch(exception e){
                system.debug(e.getMessage() + ' createQuote()');
            }
        }
        catch(Exception ex)
        {
            system.debug(ex.getMessage() + ' createQuote()');
        }
        return quoteId;
    }
}