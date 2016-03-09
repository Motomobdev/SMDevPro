@isTest
private class NegotiationProfile_Test {
      static testMethod void fnTest3(){
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
        
        Negotiation_Profile__c objNegotiation = new Negotiation_Profile__c();
        objNegotiation.Company_Name__c = objAcc.id; 
        objNegotiation.Key_Contact_1__c = objCont.id;
        
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(objNegotiation);
        NegotiationController contr = new NegotiationController(sc);     
        contr.save();
        contr.cancel();
      
      test.stopTest();
    } 
}