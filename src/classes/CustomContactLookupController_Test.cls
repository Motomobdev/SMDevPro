@isTest
private class CustomContactLookupController_Test{
    static testmethod void fnTest() {
     test.startTest();
     Account objAcc = new Account();
     objAcc.Name = 'test acc';
     insert objAcc;
     Contact objCont = new Contact();
     objCont.AccountId = objAcc.Id;
     objCont.Email = 'test@motorola.com';
     objCont.LastName = 'Test Negotiation';
     objCont.Title = 'Test';
     insert objCont;                

    //ApexPages.StandardController controller = new ApexPages.StandardController(New Contact());
     
     Pagereference pageRef = Page.CustomContactLookup;
     pageRef.getParameters().put('lksrch','Test');        
     pageRef.getParameters().put('accid',objAcc.id);    
     Test.setCurrentPageReference(pageRef);
     CustomContactLookupController ccl=new CustomContactLookupController();
     ccl.searchString = 'Test';
     ccl.searchAccount = objAcc.id;
     
     ccl.search();
     //ccl.runSearch();
     ccl.saveContact();
     ccl.getFormTag();
     ccl.getTextBox();
     //ccl.performSearch(searchString, searchAccount);
     test.stopTest();
    }
}