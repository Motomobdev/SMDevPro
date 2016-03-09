@isTest
private class NDA_SummaryCtrTest {
        static testMethod void fnTest3(){
        test.startTest();
        
        NDA__c objNDA = new NDA__c();
        NDA_Company__c objComp1 = createCompany('Test comp');
        NDA_Company__c objComp2 = createCompany('Test MComp');  
        objNDA.Company__c = objComp1.id;       
        objNDA.Multiparty_Company__c = objComp2.id;        
        objNDA.Company_Contact__c = createCompContact(objComp1).id;
        objNDA.NDA_Multiparty_Company_Contact__c = createCompContact(objComp2).id;                 
        objNDA.Governing_Law__c = 'Hong Kong';
        objNDA.NDARegion__c = 'Asia Pac - English';
        objNDA.Motorola_Entity__c = 'Digianswer A/S';
        objNDA.VP_Name__c = createCompContact().id;
        objNDA.IsProductNDA__c = true;
        objNDA.Premium_Products__c = true;
        objNDA.Premium_MCR__c = true;
        objNDA.Premium_Prototype__c = false;
        objNDA.Companion_Products__c = true;
        objNDA.Companion_MCR__c = true;
        objNDA.Companion_Prototype__c = false;
        objNDA.Value_Products__c = true;
        objNDA.Value_MCR__c = true;
        objNDA.Value_Prototype__c = false;
        objNDA.Software__c = true;
        objNDA.Software_MCR__c = true;
        objNDA.Software__c = false;
        objNDA.NDA_Specialist__c = 'nda@motorola.com';
        objNDA.Disclosure_Purpose__c = 'test Disclosure';
        objNDA.NDAStatus__c = 'Pending';
        objNDA.Is_this_Multiparty__c = true;        
        insert objNDA;             
        
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(objNDA);
        NDA_SummaryCtr contr = new NDA_SummaryCtr(sc);   
       
        Pagereference pageRef = Page.NDA_Summary;
        pageRef.getParameters().put('pv03','signatures');        
        pageRef.getParameters().put('pv02',objNDA.Id);
        Test.setCurrentPageReference(pageRef);
        
        contr.fnAction();
        
        pageRef = Page.NDA_Summary;
        pageRef.getParameters().put('pv03','modification');        
        pageRef.getParameters().put('pv02',objNDA.Id);
        Test.setCurrentPageReference(pageRef);
        contr.fnAction();
        
        pageRef = Page.NDA_Summary;
        pageRef.getParameters().put('pv03','update');        
        pageRef.getParameters().put('pv02',objNDA.Id);
        Test.setCurrentPageReference(pageRef);
        contr.fnAction();
        
        pageRef = Page.NDA_Summary;
        pageRef.getParameters().put('pv03','create');        
        pageRef.getParameters().put('pv02',objNDA.Id);
        Test.setCurrentPageReference(pageRef);
        contr.fnAction();
        
        pageRef = Page.NDA_Summary;
        pageRef.getParameters().put('pv03','amendment');        
        pageRef.getParameters().put('pv02',objNDA.Id);
        Test.setCurrentPageReference(pageRef);
        contr.fnAction();       
        
         test.stopTest();
    }
    
     public static NDA_Company__c createCompany(String strValue){
        NDA_Company__c objComp = new NDA_Company__c();
        objComp.Name = strValue;
        insert objComp;
        
        return objComp;
    }
    
    public static NDA_CompanyContact__c createCompContact(NDA_Company__c objNDACom){
        NDA_CompanyContact__c objCompContact = new NDA_CompanyContact__c();
        objCompContact.Email__c = 'test@test.com';
        objCompContact.NDACompany__c = objNDACom.Id;
        objCompContact.Full_Name__c = objNDACom.Name;
        insert objCompContact;
        
        return objCompContact;
    }
    
    
    public static NDA_Signatory__c createCompContact(){
        NDA_Signatory__c objSign = new NDA_Signatory__c();
        objSign.VP_Name__c = 'ABC';
        objSign.Title__c = 'test title';
        objSign.Email__c = 'abc@test.com';
        objSign.Region_Name__c = 'Asia Pac - English';
        insert objSign;
        
        return objSign;
    }
    
}