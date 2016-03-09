@isTest
public class SSRContractControllerTest{

    public static testMethod void testConstructorForNewSSRContractButton(){
    	Project_Spend__c SSR = new Project_Spend__c(Name__c='Test SSR');
        insert SSR;
        
        Test.setCurrentPage(new PageReference('/apex/NewSSRContractButton?id='+SSR.Id));
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(SSR);
        SSRContractController ssrcc;
        
        Test.startTest();
        	ssrcc = new SSRContractController(stdController);
        Test.stopTest();
        
        System.assertEquals(false, ssrcc.closed);
    }
    
    public static testMethod void testContructorForAddSSRContract(){
    
        Account testAccount = new Account(Name='Test Account');
        insert testAccount;
        
        Project_Spend__c SSR = new Project_Spend__c(Name__c='Test SSR',Vendor__c=testAccount.Id,Estimated_Spend__c=100,
                                                     Start_Date__c=Date.today(),End_Date__c=Date.today().addDays(1));
        insert SSR;
        
        Test.setCurrentPage(new PageReference('/apex/AddSSRContract?id='+SSR.Id));
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(SSR);
        SSRContractController ssrcc;
        
        Test.startTest();
        	ssrcc = new SSRContractController(stdController);
        	ssrcc.refresh();
        Test.stopTest();
        
        System.assertEquals(true, ssrcc.closed);
        
    }
    
    public static testMethod void testSaveForAddSSRContract(){
    
        Account testAccount = new Account(Name='Test Account');
        insert testAccount;
        
        Project_Spend__c SSR = new Project_Spend__c(Name__c='Test SSR',Vendor__c=testAccount.Id,Estimated_Spend__c=100,
                                                     Start_Date__c=Date.today(),End_Date__c=Date.today().addDays(1));
        insert SSR;
        
        Test.setCurrentPage(new PageReference('/apex/AddSSRContract?id='+SSR.Id));
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(SSR);
        SSRContractController ssrcc;
        
        Test.startTest();
        	ssrcc = new SSRContractController(stdController);
        	ssrcc.newContract.ContractTerm = 12;
        	ssrcc.save();
        Test.stopTest();
        
        System.assertEquals(true, ssrcc.closed);
        
    }
    
}