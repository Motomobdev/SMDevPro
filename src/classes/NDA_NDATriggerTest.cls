@isTest
private class NDA_NDATriggerTest {
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
        objNDA.Is_this_Multiparty__c = true;    
        objNDA.Expires_On__c = date.today().addYears(3);    
        insert objNDA;
        system.debug('********after insert trigger :****'+objNDA.Expires_On__c);
        Motorola_Core_Directory__c objMCD = new Motorola_Core_Directory__c();
        objMCD.name = 'test mcd';
        objMCD.Mail__c = 'test@test.com';
        insert objMCD;
        NDA_Notifier__c objNotifier = new NDA_Notifier__c();
        objNotifier.NDA__c = objNDA.Id;
        objNotifier.Notifier__c = objMCD.id;
        insert objNotifier;
        NDA_Notifier__c objTemp = [Select id, name,Notifier_Email__c from NDA_Notifier__c where id=: objNotifier.id];
        objNotifier = objTemp;
        system.debug('********before update trigger :****'+objNDA.Expires_On__c);
        objNDA.NDAStatus__c ='Executed';    
        objNDA.amendmentSigned__c = 'true';         
        update objNDA;
                
        
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