@isTest
private class NDA_AddAdditionalIndividualsCtrTest {
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
        
        insert objNDA;
        
        Motorola_Core_Directory__c objRecord = new Motorola_Core_Directory__c();
        objRecord.SurName__c = 'Record';  
        objRecord.Name = 'NDA Record';       
        insert objRecord;         
        
        
        NDA_AddAdditionalIndividualsCtr objContr = new NDA_AddAdditionalIndividualsCtr();
        objContr.strlastName = 'Record';
        objContr.strNdaId = objNDA.id;
        objContr.fnSeacrh();
        objContr.previous();
        objContr.next();
        objContr.first();
        objContr.last();
        
        if(objContr.wrapClassList.size() != 0){
            objContr.wrapClassList[0].boolSelected = true;
            objContr.fnAdd();   
            objContr.fnAddtoIndividualList();   
        }
        objContr.fnAdd();   
        objContr.fnAddtoIndividualList();    
        objContr.fnShowIndividualList();
        
        
        NDA_Notifier__c objN = new NDA_Notifier__c();
        objN.Notifier__c = objRecord.Id;  
        objN.NDA__c = objNDA.Id;       
        insert objN; 
        objContr.strRemoveID = objN.Id;
        objContr.fnRemoveItem();
        
     /*   for(NDA_Notifier__c objN : objContr.fnShowIndividualList()){
            objContr.strRemoveID = objN.Id;
            objContr.fnRemoveItem();
        } */
        
        objContr.Refresh();
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