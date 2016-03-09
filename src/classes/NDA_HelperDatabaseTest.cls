@isTest
private class NDA_HelperDatabaseTest {
    static testMethod void fnTest(){
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
        objNDA.Category__c = 'Premium';
        objNDA.NDA_Specialist__c = 'cmwf84@motorola.com';
        objNDA.Disclosure_Purpose__c = 'test Disclosure'; 
        objNDA.Modification_Text__c = 'mod test';
        objNDA.MCR_Content__c = 'show';
        objNDA.Prototype__c = 'show';
        objNDA.NDAStatus__c = 'Pending';
        
        insert objNDA;
        NDA__c objResultNDAID = Database.query(NDA_HelperDatabase.fnAllColumnsById('NDA__c', objNDA.Id));
        NDA__c objResultNDAField = Database.query(NDA_HelperDatabase.fnAllColumnsByFieldName('NDA__c', 'NDARegion__c', 'Asia Pac - English'));
        String strWherClause;
        strWherClause=' ,company__r.name, vp_Name__r.vp_Name__c from NDA__c WHERE ID = \'' + objNDA.id +'\'' ; 
        NDA__c objResultNDA = Database.query(NDA_HelperDatabase.fnAllColumnsByCustomQuery('NDA__c', strWherClause));
        list<SelectOption> lstValues = NDA_HelperDatabase.fnPicklistValues('NDA__c', 'Category__c');
        list<NDA_Notifier__c> lstNotifier = NDA_HelperDatabase.fnShowIndividualList(objNDA.id);
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