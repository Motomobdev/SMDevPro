@isTest
private class NDA_SearchCtrTest {
    static testMethod void fnTest1(){
        test.startTest();
        NDA__c objNDA = new NDA__c();
        NDA_Company__c objComp1 = createCompany('Test comp');
        NDA_Company__c objComp2 = createCompany('Test MComp');  
        objNDA.Company__c = objComp1.id;
        objNDA.Company_Contact__c = createCompContact(objComp1).id;
        objNDA.Multiparty_Company__c = objComp2.id;
        objNDA.NDA_Multiparty_Company_Contact__c = createCompContact(objComp2).id;
        objNDA.Governing_Law__c = 'Hong Kong';
        objNDA.NDARegion__c = 'Asia Pac - English';
        objNDA.Motorola_Entity__c = 'Digianswer A/S';
        objNDA.VP_Name__c = createCompContact().id;
        objNDA.IsProductNDA__c = true;
        objNDA.Is_this_Multiparty__c = true;
        objNDA.Premium_Products__c = true;
        objNDA.Premium_MCR__c = true;
        objNDA.Premium_Prototype__c = false;
        objNDA.NDA_Specialist__c = 'cmwf84@motorola.com';
        
        insert objNDA;
        
        NDA_SearchCtr objContr = new NDA_SearchCtr();
        objContr.objNDA.Company__c = objComp1.id;
        objContr.objNDA.Multiparty_Company__c = objComp2.id;
  
        objContr.boolShowProduct = true;
        objContr.boolShowMultiCompany = true;
        //objContr.getNDACategories();
       // objContr.getNDACompanies();
        objContr.fnShowProduct();
        objContr.fnShowMultiCompany();
       // objContr.newcompanysearch();
        objContr.fnSearch();
        objContr.getNdaRecordlist();
        objContr.getResultSize();
        objContr.fnCreateNDA();
        test.stopTest();       
    }
    
     static testMethod void fnTest2(){
        test.startTest();         
        NDA_SearchCtr objContr = new NDA_SearchCtr();
        //objContr.objNDA.Company__c = null;
        objContr.boolShowProduct = false;
        objContr.boolShowMultiCompany = false;
       // objContr.getNDACompanies();
        objContr.fnShowProduct();
        objContr.fnShowMultiCompany();
       // objContr.fnSearch();
        //objContr.getNdaRecordlist();
       // objContr.getResultSize();
      //  objContr.fnCreateNDACompany();         
        test.stopTest();       
    }
    
    static testMethod void fnTest3(){
        test.startTest();           
        NDA__c objNDA = new NDA__c();
        NDA_Company__c objComp1 = createCompany('Test comp');
        NDA_Company__c objComp2 = createCompany('Test MComp');  
        objNDA.Company__c = objComp1.id;
        objNDA.Company_Contact__c = createCompContact(objComp1).id;
        objNDA.Multiparty_Company__c = objComp2.id;
        objNDA.NDA_Multiparty_Company_Contact__c = createCompContact(objComp2).id;
        objNDA.Governing_Law__c = 'Hong Kong';
        objNDA.NDARegion__c = 'Asia Pac - English';
        objNDA.Motorola_Entity__c = 'Digianswer A/S';
        objNDA.VP_Name__c = createCompContact().id;
        objNDA.IsProductNDA__c = true;
        objNDA.Is_this_Multiparty__c = true;
        objNDA.Premium_Products__c = true;
        objNDA.Premium_MCR__c = true;
        objNDA.Premium_Prototype__c = false;
        objNDA.NDA_Specialist__c = 'cmwf84@motorola.com';
        
        insert objNDA;
               
        NDA_SearchCtr objContr = new NDA_SearchCtr();
        objContr.boolShowProduct = false;
        objContr.companyone = 'Test comp';        
        objContr.boolShowMultiCompany = true;
        objContr.companytwo = 'Test MComp';
        objContr.fnShowMultiCompany();        
        objContr.fnShowProduct();            
        objContr.fnSearch();
        objContr.getNdaRecordlist();
        objContr.getResultSize();
        objContr.fnCreateNDA();
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