@isTest
private class PlaybookCtrTest 
{
    static testMethod void myUnitTest() 
    {
    	Account acc = new Account(Name='Test Account');
    	insert acc;
    	
    	OKR__c okr = new OKR__c(Name='Test OKR', Year__c=String.valueOf(Date.today().year()), Quarter__c='Q2');
    	insert okr;
    	
    	Retail_Playbook__c pbook = new Retail_Playbook__c();
    	//insert pbook;

    	PageReference pageRef = Page.Playbook;
        pageRef.getParameters().put('CF00Ne0000000mL9U', okr.Name);
        pageRef.getParameters().put('CF00Ne0000000mL9U_lkid', okr.Id);
        pageRef.getParameters().put('year', okr.Year__c);
        pageRef.getParameters().put('quarter', okr.Quarter__c);
        pageRef.getParameters().put('retURL', '/' + okr.Id);
        pageRef.getParameters().put('scontrolCaching', '1');
        pageRef.getParameters().put('sfdc.override', '1');
    	Test.setCurrentPage(pageRef);
    	
        ApexPages.StandardController controller = new ApexPages.StandardController(pbook);
        PlaybookCtr con = new PlaybookCtr(controller);
        
        Test.startTest();
        
        con.newStatus = null;
        con.checkIfStatusReasonRequired();
        
        con.newStatus = 'Behind Plan';
        con.checkIfStatusReasonRequired();
        
        con.newType = null;
        con.checkIfTypeOKR();
        
        con.newType = 'OKR';
        con.checkIfTypeOKR();
        
        Test.stopTest();
    }
}