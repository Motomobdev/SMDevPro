public class contractExt {
    
    public contractExt() {
        contract = new Contract();
    }
    
    ContractDeviceAssoc__c devicelookup;
   
    public ContractDeviceAssoc__c getDevicelookup()
    {
        if(devicelookup == null)
        devicelookup = new ContractDeviceAssoc__c();
        return devicelookup;
    }        
    
    String searchText;
    public Contract contract;
    public List<Contract> contractValues {get; set;}
    public Contact contact {get; set;}
    public String partner {get; set;}
    public String coreid;
    public String errorMessage;
    public String errorMessageDate {get; set;}
    public String errorMessageVolume {get; set;}
    public String errorMessageLifetime {get; set;}
    public String errorMessageNRE {get; set;}
    public String errorMessageDevice {get; set;}
    public String errorMessageContract {get; set;}
    public Boolean errorFlag {get; set;}
    public Account acct {get; set;}
    public User usr {get; set;}
    public String confidential {get; set;}
    public String financeAppr {get; set;}
  
    public Contract getContract()
    {
        if(contract == null)
        contract = new Contract();
        return contract;
    } 
   
    public void setContract(Contract ct) {
        contract = ct;
    }    

    public String getSearchText() {
        return searchText;
    }
   
    public void setSearchText(String s) {
        searchText = s;
    }
  
    public String getCoreid() {
        return coreid;
    }
   
    public void setCoreid(String s) {
        coreid = s;
    }
  
    public String getErrorMessage() {
        return errorMessage;
    }
   
    public void setErrorMessage(String s) {
        errorMessage = s;
    }
  
    public PageReference display() {
 
        contractValues = [Select Name, ContractNumber From Contract Where Contract.Account.Id=:contract.AccountId];
        return null;
    }
  
    String partnermgr; 
    String vpname;
    
    public PageReference page2() {

        if(contract.Name == '' || contract.Name == null){         
            errorMessageContract='Must enter a value for Contract Name';
            return null;
        }
        errorMessageContract=null;
        acct =[Select Owner.Id From Account LIMIT 1][0]; 
        usr = [Select User.Name, User.User_External_Unique_ID__c From User Where Id=:acct.Owner.Id limit 1][0];
        partner=usr.Name;
        partnermgr=usr.User_External_Unique_ID__c;
        return Page.contractrequest2;

    }
   
    public PageReference prePage1() {
        return Page.contractrequest1;
    }

    public PageReference page3() {
     
        if(coreid == '' || coreid == null){         
            errorFlag=true;
            errorMessage='Must enter a value for Core ID';
            return null;
        }
        else {

            try {
                String ContractCreator = [Select Name From User Where User_External_Unique_ID__c=:coreid limit 1].Name;
            }    catch (System.QueryException e) {            
                errorFlag=true;
                errorMessage='Must enter a valid value for Core ID';
                return null;
            }
           
            errorFlag=false;
            errorMessage='';           
        }
             
        return Page.contractrequest3;
    }
  
    public PageReference prePage2() {
        return Page.contractrequest2;
    }  
  
    public PageReference page4() {        
        if(contract.Requested_Completion_Date__c == null){
            errorMessageDate = 'Must Enter a valid Date';
            return null;
        }
       
        String deviceName = devicelookup.Device__c;
        if(deviceName == null || deviceName == ''){
            errorMessageDevice = 'Must Enter a valid value';
            return null;
        }
       
        if(contract.Expected_Volume__c == null || contract.Expected_Volume__c == ''){
            errorMessageVolume = 'Must Enter a valid value';
            return null;
        }
       
        if(contract.Lifetime_Contract_Value__c == null){
            errorMessageLifetime = 'Must Enter a valid value';
            return null;
        }
       
        errorMessageDate = null;
        errorMessageVolume = null;
        errorMessageLifetime = null;
        return Page.contractrequest4;
    }
   
    public PageReference prePage3() {
        return Page.contractrequest3;
    }  
   
   public PageReference submit() {
      
        if(contract.NRE_Cost__c == null){
            errorMessageNRE = 'Must Enter a valid Currency value';
            return null;
        }
        else {
            errorMessageNRE = null;
        }
      
        Contract savecontract = new Contract();
      
        savecontract.Accountid =contract.Accountid;
        savecontract.Name =contract.Name;
        savecontract.StartDate =contract.Requested_Completion_Date__c;
        savecontract.BusinessUnit__c =contract.BusinessUnit__c;
        savecontract.Legal_Owner__c =contract.Legal_Owner__c;
        //savecontract.VP_Project__c =contract.VP_Project__c;
        savecontract.Business_Need__c =contract.Business_Need__c;
      
        If (confidential == 'True'){
            savecontract.Confidential_Information__c = true;
        }
        else {
            savecontract.Confidential_Information__c = false;
        }       
      
        savecontract.Requested_Completion_Date__c =contract.Requested_Completion_Date__c;
        savecontract.Alternative_Source__c =contract.Alternative_Source__c;
        savecontract.Expected_Volume__c =contract.Expected_Volume__c;
        savecontract.Lifetime_Contract_Value__c =contract.Lifetime_Contract_Value__c;
        savecontract.NRE_Cost__c =contract.NRE_Cost__c;
        savecontract.License_Fee__c =contract.License_Fee__c;
        savecontract.Maintenance_Support_Cost__c =contract.Maintenance_Support_Cost__c;
        savecontract.Prepay_Amount__c =contract.Prepay_Amount__c;
        savecontract.Other_Costs__c =contract.Other_Costs__c;
        savecontract.Other_Costs_Details__c =contract.Other_Costs_Details__c;
        savecontract.Finance_Owner__c = contract.Finance_Owner__c;
      
        If (financeAppr == 'True'){
            savecontract.Finance_Approved__c = true;          
        } 
        else {
            savecontract.Finance_Approved__c = false;
        }
      
        savecontract.Project_Requirement__c =contract.Project_Requirement__c;
        savecontract.Status='Draft';
        savecontract.Contract_Status__c='NOT DRAFTED';
        savecontract.Contract_Phase__c='0 - Investigating';
      
      
    
        insert savecontract;
      
        ContractDeviceAssoc__c devicelkup = new ContractDeviceAssoc__c();
        devicelkup.Contract__c=savecontract.Id;
      
        Device__c deviceTemp=[Select Id From Device__c Where Id=:devicelookup.Device__c];
        devicelkup.Device__c=deviceTemp.Id;
        devicelkup.Lead_Device__c=true;
      
        upsert devicelkup;
      
      
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
        String domain = '@motorola.com';
        String toAddress = coreid+domain;
        String[] addresses = new String[] {toAddress};
  
        Contract savedContract = [Select Name, ContractNumber from Contract 
                                                Where Contract.Id=:savecontract.Id Limit 1];
    
        Account savedacc = [Select Name from Account Where Account.Id=:savecontract.AccountId Limit 1];
        User Requestor = [Select Name From User Where User_External_Unique_ID__c=:coreid Limit 1];
        // Sets the paramaters of the email 
        String aname = 'Your contract request has been submitted - Contract Number: ';
        String subject = aname+savedContract.ContractNumber;
    
        String body1 = 'Your contract request from bd.mot.com for the account "'+savedacc.Name+'" has been received. Your new contract number is '+savedContract.ContractNumber;    
        String body2 = 'A new contract request from bd.mot.com for the account "'+savedacc.Name+'" has been received. The contract number is '+savedContract.ContractNumber;
    
        email.setSubject( subject );
        email.setToAddresses( addresses );
        email.setHtmlBody(Requestor.Name+',<br /><br />'+body1+'<br /><br />'+'<a href=https://cs3.salesforce.com/'+savecontract.Id+'>Click here to view and edit your contract </a>'+'<br /><br />Partner Management<br />bd.mot.com');
        email.setReplyTo('brianc@motorola.com');
        email.setSenderDisplayName('Partner Management');
   
        // Sends the email 
        Messaging.SendEmailResult [] r = 
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email}); 
    
        //Send Email to Account Owner
        email.setSubject('New contract request has been submitted - Contract Number: '+savedContract.ContractNumber);
        toAddress = partnermgr+domain;
        String[] partneraddress = new String[] {toAddress};
  
        email.setToAddresses( partneraddress );
        email.setHtmlBody(partner+',<br /><br />'+body2+'<br /><br />'+'<a href=https://cs3.salesforce.com/'+savecontract.Id+'>Click here to view and edit your contract </a>'+'<br /><br />Partner Management<br />bd.mot.com');
        Messaging.SendEmailResult [] r2 = 
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
    
        return Page.contractrequest5;
    }
   
    public PageReference home() {
        PageReference phome = new PageReference('http://motorolamobility.lrb.cs3.force.com/contractrequest');
        return phome;
    }    
   
    public String getPartnermgr() {
        return partnermgr;
    }
   
    public void setPartnermgr(String s) {
        partnermgr = s;
    }    
  
    public String getVpname() {
        return vpname;
    }
   
    public void setVpname(String s) {
        vpname = s;
    } 
    public PageReference displaycoreid() {
    //    contractValues = [Select Name, ContractNumber From Contract Where Contract.Account.Id='sample'];
  
        return null;
    }
  
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('True','Yes')); 
        options.add(new SelectOption('False','No')); 
        return options; 
    }
    
    public static testMethod void LBInitialDealController_Test()
    {
        Account a = new Account(Name='ContractRequestAccount', Tier__c ='1');
        insert a;
        Contract c = new Contract(Name='CATest', AccountId=a.Id, startDate=Date.today());
        insert c;
        
        contractExt contractExtInstance = new contractExt();
        contractExtInstance.contract.AccountId = a.Id;
        PageReference pf = contractExtInstance.display();
        
        contractExtInstance.contract.Name = 'CATest';
        pf = contractExtInstance.page2();
        contractExtInstance.contract.Name = 'CATest2';
        pf = contractExtInstance.page2();
                
        
        ContractDeviceAssoc__c conDevice = contractExtInstance.getDevicelookup();
        c = contractExtInstance.getContract();
    }
}