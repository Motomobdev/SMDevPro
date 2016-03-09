@isTest(SeeAllData=true)
private class DealStoplightControllerTest {
      static testMethod void fnTest(){
        test.startTest();
        
        Account objAcc = new Account();
        objAcc.Name = 'test acc';
        insert objAcc;
        
        Contact objCont = new Contact();
        objCont.AccountId = objAcc.Id;
        objCont.Email = 'test@motorola.com';
        objCont.LastName = 'test';
        objCont.Title = 'test';
        insert objCont;
        
        Opportunity objopp = new Opportunity();
        objopp.Name = 'TEST';
        objopp.StageName = 'Presenting Device';
        objopp.CloseDate = system.today();
        objopp.AccountId = objAcc.id;
        insert objopp;
        
        Quote thisQuote = new Quote();
        //thisQuote.id = '0Q0M0000000WfPgKAK';
        thisQuote.Name = 'TEST';
        thisQuote.pricebook2Id = '01s400000006B0eAAE';
        thisQuote.OpportunityId = objopp.id;
        thisQuote.Deal_Review_Date__c = system.today();
        insert thisQuote;
        
        Deal_Stoplight_Standard__c objStandard = new Deal_Stoplight_Standard__c();
        insert objStandard;
        
        Deal_Stoplight_Deviation__c objDeviation = new Deal_Stoplight_Deviation__c();
        objDeviation.Deal__c = thisQuote.id;
        insert objDeviation;
        
        Deal_Stoplight_Deviation__c objDealDeviation = new Deal_Stoplight_Deviation__c();
        Deal_Stoplight_Standard__c objDealStandard = new Deal_Stoplight_Standard__c();
        
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(objDealDeviation);
        DealStopLightController contr = new DealStopLightController(sc);        
        
        Pagereference pageRef = Page.DealStopLight;
        pageRef.getParameters().put('quoteId',thisQuote.id);        
        pageRef.getParameters().put('deviationId','');    
        Test.setCurrentPageReference(pageRef);
        
        objDealDeviation.Deal__c = thisQuote.id;
        contr.fnAction();
        contr.fnEdit();
        contr.fnCreate();
        
        contr.fnAllColumnsById('Deal_Stoplight_Deviation__c', objDeviation.id);
        contr.fnAllColumnsByQuoteId('Deal_Stoplight_Deviation__c',thisQuote.id);
        test.stopTest();
    }
}