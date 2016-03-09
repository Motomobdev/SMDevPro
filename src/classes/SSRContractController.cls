public class SSRContractController{

    public Contract newContract {get;set;}
    public Project_Spend__c SSR {get;set;}
    public Boolean closed {get;set;}
    
    public SSRContractController(ApexPages.StandardController stdController){
    	closed = false;
        SSR = (Project_Spend__c) stdController.getRecord();
        System.debug(SSR);
        if(SSR.Contract__c != null) closed=true;
        if(ApexPages.currentPage().getURL().contains('AddSSRContract')){
        	newContract = new Contract();
            newContract.Name = SSR.Name__c;
            newContract.AccountId = SSR.Vendor__c;
            newContract.StartDate = SSR.Start_Date__c;
            newContract.EndDate = SSR.End_Date__c;
            newContract.NRE_Cost__c = SSR.Estimated_Spend__c;
            newContract.Contract_Type__c = 'SOW';
            newContract.Let_Expire__c = true;
            newContract.Contract_Status__c = 'Fully Executed';
            newContract.Contract_Phase__c = 'Execution and Processing';
        }
    }
    
    public void save(){
       	insert newContract;
        SSR.Contract__c = newContract.id;
        update SSR;
        closed = true;
    }
    
    public PageReference refresh(){
        closed = true;
        return null;
    }
    
}