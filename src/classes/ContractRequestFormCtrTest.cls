@isTest
private class ContractRequestFormCtrTest 
{
    static testMethod void myUnitTest() 
    {
    	Motorola_Core_Directory__c ADUser = new Motorola_Core_Directory__c(Name='Neel Desai',
					                                                       FriendlyEmailAddress__c='neeldesai@motorola.com',
					                                                       MobilePhone__c='0000',
					                                                       WorkPhone__c='0000',
					                                                       OrgLevel1__c='Lvl1', 
					                                                       OrgLevel2__c='Lvl2', 
					                                                       OrgLevel3__c='Lvl3',
					                                                       CoreID__c='MJQ764',
					                                                       MMID__c='NEELDESAI',
					                                                       DirectoryStatus__c='A');
    	
    	insert ADUser;
    	
        Test.startTest();
        
        PageReference pageRef = Page.ContractRequestForm;
        Test.setCurrentPage(pageRef);
        
        Contract_Request__c cr = new Contract_Request__c();
        ApexPages.StandardController ctr = new ApexPages.StandardController(cr);
        ContractRequestFormCtr con = new ContractRequestFormCtr(ctr);
        
        con.MMID = 'XYZ123';
        con.validateMMID();
        
        System.assertEquals(con.isVaidDirectoryUser, false);
        
        con.changeMMID();
        
        con.MMID = 'NEELDESAI';
        con.validateMMID();
        
        System.assertEquals(con.isVaidDirectoryUser, true);
        
        con.checkIfHighUrgency();
        
        con.save();
        
        con.newRequest();
        
        Test.stopTest();
    }
}