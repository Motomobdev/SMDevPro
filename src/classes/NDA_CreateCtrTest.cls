@isTest
private class NDA_CreateCtrTest {
      static testMethod void fnTest3(){
        test.startTest();
        
        Account objAcc = new Account();
        objAcc.Name = 'test acc';
        insert objAcc;
        
        Contact objCont = new Contact();
        objCont.AccountId = objAcc.Id;
        objCont.Email = 'nda@motorola.com';
        objCont.LastName = 'Mandava';
        objCont.Title = 'Developer';
        insert objCont;
        
        
        NDA__c objNDA = new NDA__c();
        NDA_Company__c objComp1 = createCompany('Test comp');
        NDA_Company__c objComp2 = createCompany('Test MComp');  
        objNDA.Company__c = objComp1.id;       
        objNDA.Multiparty_Company__c = objComp2.id;                       
        objNDA.Governing_Law__c = 'Illinois';
        objNDA.NDARegion__c = 'North America - English';
        objNDA.Motorola_Entity__c = 'Motorola Mobility LLC';
        objNDA.VP_Name__c = getNASignatory('North America - English').id;
                 
        objNDA.Disclosure_Purpose__c = 'test Disclosure';
        objNDA.Premium_Products__c = true;
        objNDA.Premium_MCR__c = true;
        objNDA.Premium_Prototype__c = true;
        objNDA.Companion_Products__c = true;
        objNDA.Companion_MCR__c = true;
        objNDA.Companion_Prototype__c = true;
        objNDA.Value_Products__c = true;
        objNDA.Value_MCR__c = true;
        objNDA.Value_Prototype__c = true;
        objNDA.Software__c = true;
        objNDA.Software_MCR__c = true;
        objNDA.Software__c = true;  
        objNDA.Is_this_Multiparty__c = true;
        objNDA.IsProductNDA__c = true; 
       
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(objNDA);
        NDA_CreateCtr contr = new NDA_CreateCtr(sc);        
        
        Pagereference pageRef = Page.NDA_Create;
        pageRef.getParameters().put('pv03','true');        
        pageRef.getParameters().put('pv06',objComp1.Id);
        pageRef.getParameters().put('pv07','true');
        pageRef.getParameters().put('pv08',objComp2.Id);        
        Test.setCurrentPageReference(pageRef);
        
        contr.fnAction();
     /*   contr.boolShowMultiCompany = true;
        contr.boolIsInserted = false;
        contr.boolIsSubmitted = false;
        contr.boolIsSummary = false;
        contr.boolIsProduct = true;
        contr.boolShowMultiCompany = contr.objNDA.Is_this_Multiparty__c;   */      
        
        contr.objNDACompany = new NDA_Company__c();
        contr.objNDA.Company__c = objComp1.id;  
        
        contr.objNDAMultiCompany = new NDA_Company__c();     
        contr.objNDA.Multiparty_Company__c = objComp2.id;   
       
        contr.objNDACompanyContact = new NDA_CompanyContact__c();
        contr.objNDACompanyContact.Email__c = 'testing@test.com';         
        contr.objNDACompanyContact.Full_Name__c = 'TEST NAME';
        contr.objNDACompanyContact.NDACompany__c = objNDA.Company__c;
        
        contr.objNDAMultiCompanyContact = new NDA_CompanyContact__c();
        contr.objNDAMultiCompanyContact.Email__c = 'testing@test.com';         
        contr.objNDAMultiCompanyContact.Full_Name__c = 'TEST NAME';
        contr.objNDAMultiCompanyContact.NDACompany__c = objNDA.Multiparty_Company__c;  
 
        contr.strSelectedVpName = getNASignatory('North America - English').id; 
 
        contr.fnSaveAsDraft();     
        objNDA.Start_Date__c = Date.today();
        getNotifier(objNDA);
    
        objNDA.Company_Contact__c = createCompContact(objComp1).id;
        objNDA.NDA_Multiparty_Company_Contact__c = createCompContact(objComp2).id; 
        
        objNDA.Governing_Law__c = 'Illinois';
        objNDA.NDARegion__c = 'Latin America - English & Portuguese';
        objNDA.Motorola_Entity__c = 'Motorola Mobility LLC';
        objNDA.VP_Name__c = getNASignatory('Latin America - English & Portuguese').id;
 
        
        contr.objNDACompanyContact.Email__c = 'testing@test.com';         
        contr.objNDACompanyContact.Full_Name__c = 'TEST NAME';
        
        contr.objNDA.Company_Contact__c = objNDA.Company_Contact__c;
        contr.objNDA.NDA_Multiparty_Company_Contact__c = objNDA.NDA_Multiparty_Company_Contact__c; 

        contr.boolIsInserted = true;
        contr.boolIsSubmitted = true;
        contr.boolIsSummary = true;
        contr.boolIsProduct = true;
        contr.boolShowMultiCompany = contr.objNDA.Is_this_Multiparty__c; 
            
        
        contr.fnShowVpPanel();
        contr.getVpNames();
        contr.fnRecordType();
        contr.fnShowMultiCompany();
        contr.fnShowPremium();
        contr.fnShowValue();
        contr.fnShowCompanion();
        contr.fnShowSoftware();
        contr.fnAttachNdaDDP(); 
        
        contr.fnUpdateNDA();
        contr.fnCallEchosignDDP();  

        objNDA.Expires_On__c = Date.today().addYears(3);
        objNDA.NDA_file_signed_date__c = Date.today(); 
  
        contr.objNDA.Modification_Text__c = 'test again';
        contr.fnAssignNDASpecialist();
        contr.fnSubmitAfterMod();
        contr.fnNotifySpecialistDDP(objCont.id,'modification');      
        contr.fnNDAAmendment();        
        contr.fnNDADisclosure();  
                  
        test.stopTest();
    }
    
    static testMethod void fnTest4(){
        test.startTest();
        
        Account objAcc = new Account();
        objAcc.Name = 'test acc';
        insert objAcc;
        
        Contact objCont = new Contact();
        objCont.AccountId = objAcc.Id;
        objCont.Email = 'nda@motorola.com';
        objCont.LastName = 'Mandava';
        objCont.Title = 'Developer';
        insert objCont;
        
        
        NDA__c objNDA = new NDA__c();
        NDA_Company__c objComp1 = createCompany('Test comp');
        NDA_Company__c objComp2 = createCompany('Test MComp');  
        objNDA.Company__c = objComp1.id;       
        objNDA.Multiparty_Company__c = objComp2.id;                       
        objNDA.Governing_Law__c = 'Illinois';
        objNDA.NDARegion__c = 'Latin America - English & Portuguese';
        objNDA.Motorola_Entity__c = 'Motorola Mobility LLC';
        objNDA.VP_Name__c = getNASignatory('Latin America - English & Portuguese').id;
                 
        objNDA.Disclosure_Purpose__c = 'test Disclosure';
        objNDA.Premium_Products__c = true;
        objNDA.Premium_MCR__c = true;
        objNDA.Premium_Prototype__c = true;
        objNDA.Companion_Products__c = true;
        objNDA.Companion_MCR__c = true;
        objNDA.Companion_Prototype__c = true;
        objNDA.Value_Products__c = true;
        objNDA.Value_MCR__c = true;
        objNDA.Value_Prototype__c = true;
        objNDA.Software__c = true;
        objNDA.Software_MCR__c = true;
        objNDA.Software__c = true; 
                       
       
       
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(objNDA);
        NDA_CreateCtr contr = new NDA_CreateCtr(sc);        
        
        Pagereference pageRef = Page.NDA_Create;
        pageRef.getParameters().put('pv03','true');        
        pageRef.getParameters().put('pv06',objComp1.Id);
        pageRef.getParameters().put('pv07','true');
        pageRef.getParameters().put('pv08',objComp2.Id);        
        Test.setCurrentPageReference(pageRef);
        
        contr.fnAction();
        contr.objNDA.Is_this_Multiparty__c = true;
        contr.objNDA.IsProductNDA__c = true;
        contr.boolShowMultiCompany = true;
        contr.boolIsInserted = false;
        contr.boolIsSubmitted = false;
        contr.boolIsSummary = false;
        contr.boolIsProduct = true;
        contr.boolShowMultiCompany = contr.objNDA.Is_this_Multiparty__c; 
        
        
        contr.objNDACompany = new NDA_Company__c();
        contr.objNDA.Company__c = objComp1.id;  
        
        contr.objNDAMultiCompany = new NDA_Company__c();     
        contr.objNDA.Multiparty_Company__c = objComp2.id;   
       
        contr.objNDACompanyContact = new NDA_CompanyContact__c();
        contr.objNDACompanyContact.Email__c = 'testing@test.com';         
        contr.objNDACompanyContact.Full_Name__c = 'TEST NAME';
        contr.objNDACompanyContact.NDACompany__c = objNDA.Company__c;
        
        contr.objNDAMultiCompanyContact = new NDA_CompanyContact__c();
        contr.objNDAMultiCompanyContact.Email__c = 'testing@test.com';         
        contr.objNDAMultiCompanyContact.Full_Name__c = 'TEST NAME';
        contr.objNDAMultiCompanyContact.NDACompany__c = objNDA.Multiparty_Company__c;  
 
        contr.strSelectedVpName = getNASignatory('Latin America - English & Portuguese').id; 
 
        contr.fnSaveAsDraft();
        
        pageRef = Page.NDA_Create;
        pageRef.getParameters().put('pv03','false');        
        pageRef.getParameters().put('pv06',objComp1.Id);
        pageRef.getParameters().put('pv07','false');
        pageRef.getParameters().put('pv08','');        
        Test.setCurrentPageReference(pageRef);
        
        contr.fnAction();
        contr.boolShowMultiCompany = false;
        contr.boolIsInserted = false;
        contr.boolIsSubmitted = false;
        contr.boolIsSummary = false;
        contr.boolIsProduct = false;       
              
        contr.objNDACompanyContact.Email__c = 'testing@test.com';         
        contr.objNDACompanyContact.Full_Name__c = 'TEST NAME';
        contr.objNDACompanyContact.NDACompany__c = objNDA.Company__c; 
        contr.strSelectedVpName = getNASignatory('Latin America - English & Portuguese').id;
   
        contr.fnSaveAsDraft();
        
        pageRef = Page.NDA_Create;
        pageRef.getParameters().put('pv03','true');        
        pageRef.getParameters().put('pv06',objComp1.Id);
        pageRef.getParameters().put('pv07','false');
        pageRef.getParameters().put('pv08','');        
        Test.setCurrentPageReference(pageRef);
        
        contr.fnAction();
        contr.boolShowMultiCompany = false;
        contr.boolIsInserted = false;
        contr.boolIsSubmitted = false;
        contr.boolIsSummary = false;
        contr.boolIsProduct = true;        
        
        contr.objNDACompanyContact.Email__c = 'testing@test.com';         
        contr.objNDACompanyContact.Full_Name__c = 'TEST NAME';
        contr.objNDACompanyContact.NDACompany__c = objNDA.Company__c;          
        contr.strSelectedVpName = getNASignatory('North America - English').id;  

        contr.fnSaveAsDraft();
        
        objNDA.Start_Date__c = Date.today();
     //   objNDA.Company_Contact__c = createCompContact(objComp1).id;
    //    objNDA.NDA_Multiparty_Company_Contact__c = createCompContact(objComp2).id; 
       
      objNDA.Company_Contact__c = createCompContact(objComp1).id;
        objNDA.NDA_Multiparty_Company_Contact__c = createCompContact(objComp2).id; 
        
        objNDA.Governing_Law__c = 'Illinois';
        objNDA.NDARegion__c = 'Latin America - English & Portuguese';
        objNDA.Motorola_Entity__c = 'Motorola Mobility LLC';
        objNDA.VP_Name__c = getNASignatory('Latin America - English & Portuguese').id;
       
       insert objNDA;         
        
    //    objNDA.NDAStatus__c = 'Pending';
        contr.objNDA.Start_Date__c = Date.today().addYears(1);
     //   objNDA.DPLStatus__c = 'Pending';  
       // update objNDA;    
        
        contr.objNDACompanyContact.Email__c = 'testing@test.com';         
        contr.objNDACompanyContact.Full_Name__c = 'TEST NAME';
        
        contr.objNDA.Company_Contact__c = objNDA.Company_Contact__c;
        contr.objNDA.NDA_Multiparty_Company_Contact__c = objNDA.NDA_Multiparty_Company_Contact__c; 
        
        contr.boolShowMultiCompany = true;
        contr.boolIsInserted = true;
        contr.boolIsSubmitted = true;
        contr.boolIsSummary = true;
        contr.boolIsProduct = true;
        contr.boolShowMultiCompany = contr.objNDA.Is_this_Multiparty__c; 
        
      //  contr.fnAction();            
        
        contr.fnShowVpPanel();
        contr.getVpNames();
        contr.fnRecordType();
        contr.fnShowMultiCompany();
        contr.fnShowPremium();
        contr.fnShowValue();
        contr.fnShowCompanion();
        contr.fnShowSoftware();
        contr.fnAttachNdaDDP(); 
        
        contr.fnUpdateNDA();
        contr.fnCallEchosignDDP();  
        
      //  objNDA.NDAStatus__c = 'Executed';
        objNDA.Expires_On__c = Date.today().addYears(3);
        objNDA.NDA_file_signed_date__c = Date.today(); 
      //  objNDA.DPLStatus__c = 'Pending'; 
       // objNDA.AmendmentSent__c = false;
       // objNDA.AmendmentSigned__c = 'false';     
       // update objNDA; 
        
       // contr.fnAction(); 
       

        contr.objNDA.Modification_Text__c = 'test again';
        contr.fnAssignNDASpecialist();
        contr.fnSubmitAfterMod();
        contr.fnNotifySpecialistDDP(objCont.id,'modification');        
      
        //contr.fnNotifySpecialistAmendmentDDP(objCont.id);
        contr.fnNDAAmendment();
        
        contr.fnNDADisclosure();

        contr.boolIsInserted = true;
        contr.boolIsProduct = true;
        contr.boolIsSubmitted = true;
        contr.boolIsSummary = true;
        contr.boolShowMultiCompany = true;
        contr.boolShowRegionDepend = true;
        contr.strSelectedEntity = 'test entity';
        contr.strSelectedVpName = 'test vp';        
        test.stopTest();
    }  
    
    static testMethod void fnTest5(){
        test.startTest();
        
        Account objAcc = new Account();
        objAcc.Name = 'test acc';
        insert objAcc;
        
        Contact objCont = new Contact();
        objCont.AccountId = objAcc.Id;
        objCont.Email = 'nda@motorola.com';
        objCont.LastName = 'Mandava';
        objCont.Title = 'Developer';
        insert objCont;
        
        
        NDA__c objNDA = new NDA__c();
        NDA_Company__c objComp1 = createCompany('Test comp');
        NDA_Company__c objComp2 = createCompany('Test MComp');  
        objNDA.Company__c = objComp1.id;       
        objNDA.Multiparty_Company__c = objComp2.id;                       
        objNDA.Governing_Law__c = 'Illinois';
        objNDA.NDARegion__c = 'Latin America - English & Spanish';
        objNDA.Motorola_Entity__c = 'Motorola Mobility LLC';
        objNDA.VP_Name__c = getNASignatory('Latin America - English & Spanish').id;
                 
        objNDA.Disclosure_Purpose__c = 'test Disclosure';
        objNDA.Premium_Products__c = true;
        objNDA.Premium_MCR__c = true;
        objNDA.Premium_Prototype__c = true;
        objNDA.Companion_Products__c = true;
        objNDA.Companion_MCR__c = true;
        objNDA.Companion_Prototype__c = true;
        objNDA.Value_Products__c = true;
        objNDA.Value_MCR__c = true;
        objNDA.Value_Prototype__c = true;
        objNDA.Software__c = true;
        objNDA.Software_MCR__c = true;
        objNDA.Software__c = true; 
                       
       
       
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(objNDA);
        NDA_CreateCtr contr = new NDA_CreateCtr(sc);        
        
        Pagereference pageRef = Page.NDA_Create;
        pageRef.getParameters().put('pv03','true');        
        pageRef.getParameters().put('pv06',objComp1.Id);
        pageRef.getParameters().put('pv07','true');
        pageRef.getParameters().put('pv08',objComp2.Id);        
        Test.setCurrentPageReference(pageRef);
        
        contr.fnAction();
        contr.objNDA.Is_this_Multiparty__c = true;
        contr.objNDA.IsProductNDA__c = true;
        contr.boolShowMultiCompany = true;
        contr.boolIsInserted = false;
        contr.boolIsSubmitted = false;
        contr.boolIsSummary = false;
        contr.boolIsProduct = true;
        contr.boolShowMultiCompany = contr.objNDA.Is_this_Multiparty__c; 
        
        
        contr.objNDACompany = new NDA_Company__c();
        contr.objNDA.Company__c = objComp1.id;  
        
        contr.objNDAMultiCompany = new NDA_Company__c();     
        contr.objNDA.Multiparty_Company__c = objComp2.id;   
       
        contr.objNDACompanyContact = new NDA_CompanyContact__c();
        contr.objNDACompanyContact.Email__c = 'testing@test.com';         
        contr.objNDACompanyContact.Full_Name__c = 'TEST NAME';
        contr.objNDACompanyContact.NDACompany__c = objNDA.Company__c;
        
        contr.objNDAMultiCompanyContact = new NDA_CompanyContact__c();
        contr.objNDAMultiCompanyContact.Email__c = 'testing@test.com';         
        contr.objNDAMultiCompanyContact.Full_Name__c = 'TEST NAME';
        contr.objNDAMultiCompanyContact.NDACompany__c = objNDA.Multiparty_Company__c;  
 
        contr.strSelectedVpName = getNASignatory('Latin America - English & Spanish').id; 
 
        contr.fnSaveAsDraft();
        
        pageRef = Page.NDA_Create;
        pageRef.getParameters().put('pv03','false');        
        pageRef.getParameters().put('pv06',objComp1.Id);
        pageRef.getParameters().put('pv07','false');
        pageRef.getParameters().put('pv08','');        
        Test.setCurrentPageReference(pageRef);
        
        contr.fnAction();
        contr.boolShowMultiCompany = false;
        contr.boolIsInserted = false;
        contr.boolIsSubmitted = false;
        contr.boolIsSummary = false;
        contr.boolIsProduct = false;       
              
        contr.objNDACompanyContact.Email__c = 'testing@test.com';         
        contr.objNDACompanyContact.Full_Name__c = 'TEST NAME';
        contr.objNDACompanyContact.NDACompany__c = objNDA.Company__c; 
        contr.strSelectedVpName = getNASignatory('Latin America - English & Spanish').id;
   
        contr.fnSaveAsDraft();
        
        pageRef = Page.NDA_Create;
        pageRef.getParameters().put('pv03','true');        
        pageRef.getParameters().put('pv06',objComp1.Id);
        pageRef.getParameters().put('pv07','false');
        pageRef.getParameters().put('pv08','');        
        Test.setCurrentPageReference(pageRef);
        
        contr.fnAction();
        contr.boolShowMultiCompany = false;
        contr.boolIsInserted = false;
        contr.boolIsSubmitted = false;
        contr.boolIsSummary = false;
        contr.boolIsProduct = true;        
        
        contr.objNDACompanyContact.Email__c = 'testing@test.com';         
        contr.objNDACompanyContact.Full_Name__c = 'TEST NAME';
        contr.objNDACompanyContact.NDACompany__c = objNDA.Company__c;          
        contr.strSelectedVpName = getNASignatory('Latin America - English & Spanish').id;  

        contr.fnSaveAsDraft();
        
        objNDA.Start_Date__c = Date.today();
     //   objNDA.Company_Contact__c = createCompContact(objComp1).id;
    //    objNDA.NDA_Multiparty_Company_Contact__c = createCompContact(objComp2).id; 
       
      objNDA.Company_Contact__c = createCompContact(objComp1).id;
        objNDA.NDA_Multiparty_Company_Contact__c = createCompContact(objComp2).id; 
        
        objNDA.Governing_Law__c = 'Illinois';
        objNDA.NDARegion__c = 'Latin America - English & Spanish';
        objNDA.Motorola_Entity__c = 'Motorola Mobility LLC';
        objNDA.VP_Name__c = getNASignatory('Latin America - English & Spanish').id;
       
       insert objNDA;         
        
    //    objNDA.NDAStatus__c = 'Pending';
        contr.objNDA.Start_Date__c = Date.today().addYears(1);
     //   objNDA.DPLStatus__c = 'Pending';  
       // update objNDA;    
        
        contr.objNDACompanyContact.Email__c = 'testing@test.com';         
        contr.objNDACompanyContact.Full_Name__c = 'TEST NAME';
        
        contr.objNDA.Company_Contact__c = objNDA.Company_Contact__c;
        contr.objNDA.NDA_Multiparty_Company_Contact__c = objNDA.NDA_Multiparty_Company_Contact__c; 
        
        contr.boolShowMultiCompany = true;
        contr.boolIsInserted = true;
        contr.boolIsSubmitted = true;
        contr.boolIsSummary = true;
        contr.boolIsProduct = true;
        contr.boolShowMultiCompany = contr.objNDA.Is_this_Multiparty__c; 
        
      //  contr.fnAction();            
        
        contr.fnShowVpPanel();
        contr.getVpNames();
        contr.fnRecordType();
        contr.fnShowMultiCompany();
        contr.fnShowPremium();
        contr.fnShowValue();
        contr.fnShowCompanion();
        contr.fnShowSoftware();
        contr.fnAttachNdaDDP(); 
        
        contr.fnUpdateNDA();
        contr.fnCallEchosignDDP();  
        
      //  objNDA.NDAStatus__c = 'Executed';
        objNDA.Expires_On__c = Date.today().addYears(3);
        objNDA.NDA_file_signed_date__c = Date.today(); 
      //  objNDA.DPLStatus__c = 'Pending'; 
       // objNDA.AmendmentSent__c = false;
       // objNDA.AmendmentSigned__c = 'false';     
       // update objNDA; 
        
       // contr.fnAction(); 
       

        contr.objNDA.Modification_Text__c = 'test again';
        contr.fnAssignNDASpecialist();
        contr.fnSubmitAfterMod();
        contr.fnNotifySpecialistDDP(objCont.id,'modification');        
      
        //contr.fnNotifySpecialistAmendmentDDP(objCont.id);
        contr.fnNDAAmendment();
        
        contr.fnNDADisclosure();

        contr.boolIsInserted = true;
        contr.boolIsProduct = true;
        contr.boolIsSubmitted = true;
        contr.boolIsSummary = true;
        contr.boolShowMultiCompany = true;
        contr.boolShowRegionDepend = true;
        contr.strSelectedEntity = 'test entity';
        contr.strSelectedVpName = 'test vp';        
        test.stopTest();
    } 
    
    static testMethod void fnTest2(){
        test.startTest();
        
        NDA__c objNDA = new NDA__c();
        NDA_Company__c objComp1 = createCompany('Test comp');
        NDA_Company__c objComp2 = createCompany('Test MComp');  
        objNDA.Company__c = objComp1.id;       
       // objNDA.Multiparty_Company__c = objComp2.id;        
        objNDA.Company_Contact__c = createCompContact(objComp1).id;
      //  objNDA.NDA_Multiparty_Company_Contact__c = createCompContact(objComp2).id;                 
        objNDA.Governing_Law__c = 'Illinois';
        objNDA.NDARegion__c = 'Latin America - English & Spanish';
        objNDA.Motorola_Entity__c = 'Motorola Mobility LLC';
        objNDA.VP_Name__c = getNASignatory('Latin America - English & Spanish').id;
        objNDA.IsProductNDA__c = false;
      
       /* objNDA.Premium_Products__c = true;
        objNDA.Premium_MCR__c = true;
        objNDA.Premium_Prototype__c = true;
        objNDA.Companion_Products__c = true;
        objNDA.Companion_MCR__c = true;
        objNDA.Companion_Prototype__c = true;
        objNDA.Value_Products__c = true;
        objNDA.Value_MCR__c = true;
        objNDA.Value_Prototype__c = true;
        objNDA.Software__c = true;
        objNDA.Software_MCR__c = true;
        objNDA.Software__c = true;
        objNDA.NDA_Specialist__c = 'nda@motorola.com'; */
        
        objNDA.Disclosure_Purpose__c = 'test Disclosure';
        objNDA.NDAStatus__c = 'Pending';
        objNDA.Is_this_Multiparty__c = false;        
       // insert objNDA;
       
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(objNDA);
        NDA_CreateCtr contr = new NDA_CreateCtr(sc);        
        
        Pagereference pageRef = Page.NDA_Create;
        pageRef.getParameters().put('pv03','false');        
        pageRef.getParameters().put('pv06',objComp1.Id);
        pageRef.getParameters().put('pv07','false');
        pageRef.getParameters().put('pv08','');        
        Test.setCurrentPageReference(pageRef);
        
        contr.boolShowMultiCompany = true;
        contr.boolIsInserted = true;
        contr.boolIsSubmitted = true;
        contr.boolIsSummary = true;
        contr.boolIsProduct = true;
                
        contr.fnAction();
        contr.fnSaveAsDraft();
        insert objNDA;
        
        contr.boolShowMultiCompany = contr.objNDA.Is_this_Multiparty__c;
        contr.fnShowVpPanel();
        contr.getVpNames();
        contr.fnRecordType();
        contr.fnShowMultiCompany();
        contr.fnShowPremium();
        contr.fnShowValue();
        contr.fnShowCompanion();
        contr.fnShowSoftware();
        contr.fnAttachNdaDDP();              
       
        contr.objNDACompanyContact.Email__c = 'testing@test.com';         
        contr.objNDACompanyContact.Full_Name__c = 'TEST NAME';   
            
        contr.fnUpdateNDA();
        contr.fnCallEchosignDDP();
        
        NDA__c objToUpdate = [SELECT id, name,DPLStatus__c, Modification_Text__c, NDAStatus__c, Expires_On__c FROM NDA__c where id =: contr.objNDA.id];

        objToUpdate.NDAStatus__c = 'Executed';
        objToUpdate.DPLStatus__c = 'Approved';
        objToUpdate.Expires_On__c = Date.today().addYears(3);
        update objToUpdate;
        
        contr.objNDA.Modification_Text__c = 'test again';
        contr.fnSubmitAfterMod();       
                
        contr.fnNDAAmendment();
        contr.objNDA.AmendmentSent__c = true;
        
        contr.fnNDADisclosure();
        contr.fnAssignNDASpecialist();
        contr.boolIsInserted = true;
        contr.boolIsProduct = true;
        contr.boolIsSubmitted = true;
        contr.boolIsSummary = true;
        contr.boolShowMultiCompany = true;
        contr.boolShowRegionDepend = true;
        contr.strSelectedEntity = 'test entity';
        contr.strSelectedVpName = 'test vp';
        
       
        Account objAcc = new Account();
        objAcc.Name = 'test acc';
        insert objAcc;
        
        Contact objCont = new Contact();
        objCont.AccountId = objAcc.Id;
        objCont.Email = 'test@test.com';
        objCont.LastName = 'Mandava';
        objCont.Title = 'Developer';
        insert objCont;
        contr.fnNotifySpecialistAmendmentDDP(objCont.id);
        contr.fnAssignNDASpecialist();
        test.stopTest();
    }
    
    
    static testMethod void fnTest(){
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
        objNDA.Motorola_Entity__c = 'Motorola Mobility LLC';
        objNDA.VP_Name__c = getNASignatory('Asia Pac - English').id;
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
        NDA_CreateCtr contr = new NDA_CreateCtr(sc);        
        
        Pagereference pageRef1 = Page.NDA_Create;
        pageRef1.getParameters().put('pv03','true');        
        pageRef1.getParameters().put('pv06',objComp1.Id);
        pageRef1.getParameters().put('pv07','true');
        pageRef1.getParameters().put('pv08',objComp2.Id);        
        Test.setCurrentPageReference(pageRef1);

        contr.boolShowMultiCompany = true;
        contr.boolIsInserted = true;
        contr.boolIsSubmitted = true;
        contr.boolIsSummary = true;
        contr.boolIsProduct = true;
                
        contr.fnAction();    
        
        contr.boolShowMultiCompany = contr.objNDA.Is_this_Multiparty__c;
        contr.fnShowVpPanel();
        contr.getVpNames();
        contr.fnRecordType();
        contr.fnShowMultiCompany();
        contr.fnShowPremium();
        contr.fnShowValue();
        contr.fnShowCompanion();
        contr.fnShowSoftware();
        contr.fnAttachNdaDDP();
               
       
        contr.objNDAMultiCompanyContact.Email__c = 'testing@test.com';         
        contr.objNDAMultiCompanyContact.Full_Name__c = 'TEST NAME';   
        
        getNotifier(objNDA);
            
        contr.fnUpdateNDA();
        contr.fnCallEchosignDDP();
        
        NDA__c objToUpdate = [SELECT id, name, Modification_Text__c, NDAStatus__c, Expires_On__c FROM NDA__c where id =: contr.objNDA.id];
        
        if(objToUpdate.Modification_Text__c != null || objToUpdate.Modification_Text__c != ''){
            objToUpdate.NDAStatus__c = 'Executed-Mod';
        }else{
            objToUpdate.NDAStatus__c = 'Executed';
        }
        
        getNotifier(objNDA);
        objToUpdate.NDAStatus__c = 'Executed';
        objToUpdate.Expires_On__c = Date.today().addYears(3);
        objToUpdate.NDA_Specialist__c = createCompContact(objComp1).id;
        update objToUpdate;
        
        contr.objNDA.Modification_Text__c = 'test again';
        contr.fnSubmitAfterMod();
                
        contr.fnNDAAmendment();
        contr.fnNDADisclosure();
        contr.fnAssignNDASpecialist();
        contr.boolIsInserted = true;
        contr.boolIsProduct = true;
        contr.boolIsSubmitted = true;
        contr.boolIsSummary = true;
        contr.boolShowMultiCompany = true;
        contr.boolShowRegionDepend = true;
      //  contr.strDisclosurePurp = 'test dp';
        contr.strSelectedEntity = 'test entity';
        contr.strSelectedVpName = 'test vp';
        
       
        Account objAcc = new Account();
        objAcc.Name = 'test acc';
        insert objAcc;
        
        Contact objCont = new Contact();
        objCont.AccountId = objAcc.Id;
        objCont.Email = 'test@test.com';
        objCont.LastName = 'Mandava';
        objCont.Title = 'Developer';
        insert objCont;
       // contr.fnNotifySpecialistDDP(objCont.id);
        contr.fnNotifySpecialistAmendmentDDP(objCont.id);
        contr.fnAssignNDASpecialist();
        test.stopTest();
    }
    
    static testMethod void fnTest1(){
        test.startTest();
        
        NDA_Company__c objComp1 = createCompany('Test comp');
        
        NDA__c objNDA = new NDA__c();       
        NDA_Company__c objComp2 = createCompany('Test MComp');  
        objNDA.Company__c = objComp1.id;
        //objNDA.Company_Contact__c = createCompContact(objComp1).id;
        objNDA.Multiparty_Company__c = objComp2.id;
        //objNDA.NDA_Multiparty_Company_Contact__c = createCompContact(objComp2).id;
        objNDA.Governing_Law__c = 'France';
        objNDA.NDARegion__c = 'EMEA - English';
        objNDA.Motorola_Entity__c = 'Motorola Mobility LLC';
        objNDA.VP_Name__c = getNASignatory('EMEA - English').id;
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
        
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(objNDA);
        NDA_CreateCtr contr = new NDA_CreateCtr(sc);
        
        Pagereference pageRef = Page.NDA_Create;
        pageRef.getParameters().put('pv03','true');
        pageRef.getParameters().put('pv06',objComp1.id);
        pageRef.getParameters().put('pv07','true');   
        pageRef.getParameters().put('pv08',objComp2.id);     
        Test.setCurrentPage(pageRef);
             
        contr.boolShowMultiCompany = true;
        contr.boolIsInserted = false;
        contr.boolIsSubmitted = false;
        
        contr.fnAction();       
        
        contr.boolShowMultiCompany = contr.objNDA.Is_this_Multiparty__c;
        contr.fnShowVpPanel();
        contr.getVpNames();
        contr.fnRecordType();
        contr.fnShowMultiCompany();
        contr.fnShowPremium();
        contr.fnShowValue();
        contr.fnShowCompanion();
        contr.fnShowSoftware();
        
        Account objAcc = new Account();
        objAcc.Name = 'test acc';
        insert objAcc;
        
        Contact objCont = new Contact();
        objCont.AccountId = objAcc.Id;
        objCont.Email = 'test@test.com';
        objCont.LastName = 'Mandava';
        objCont.Title = 'Developer';
        insert objCont;

        contr.fnSaveAsDraft();  
        
        objNDA.Company_Contact__c = createCompContact(objComp1).id;
        objNDA.NDA_Multiparty_Company_Contact__c = createCompContact(objComp2).id; 
        
        insert objNDA;
                 
        contr.objNDA.Modification_Text__c = 'test mod';
            
        NDA_Company__c objComp3 = createCompany('Test MComp1'); 
        contr.objNDA.Multiparty_Company__c = objComp3.id; 
        
        NDA_CompanyContact__c objCompContact3 = new NDA_CompanyContact__c();
        objCompContact3.Email__c = 'testing@test.com';
        objCompContact3.NDACompany__c = objComp3.Id;
        objCompContact3.Full_Name__c = 'TEST NAME';
        contr.fnUpdateNDA();
        contr.objNDA.Modification_Text__c = 'test again';
        contr.fnSubmitAfterMod();
        contr.fnCallEchosignDDP();
        
    /*    NDA__c objToUpdate = [SELECT id, name, Modification_Text__c, NDAStatus__c, Expires_On__c FROM NDA__c where id =: contr.objNDA.id];
        
        if(objToUpdate.Modification_Text__c != null || objToUpdate.Modification_Text__c != ''){
            objToUpdate.NDAStatus__c = 'Executed-Mod';
        }else{
            objToUpdate.NDAStatus__c = 'Executed';
        }
        objToUpdate.Expires_On__c = Date.today().addYears(3);
        update objToUpdate; */       
       
                
        contr.fnNDAAmendment();
        contr.fnNDADisclosure();
        contr.fnAssignNDASpecialist();
        contr.boolIsInserted = true;
        contr.boolIsProduct = true;
        contr.boolIsSubmitted = true;
        contr.boolIsSummary = true;
        contr.boolShowMultiCompany = true;
        contr.boolShowRegionDepend = true;
       // contr.strDisclosurePurp = 'test dp';
        contr.strSelectedEntity = 'test entity';
        contr.strSelectedVpName = 'test vp';       
      
      //  contr.fnNotifySpecialistDDP(objCont.id,'update');
       // contr.fnNotifySpecialistAmendmentDDP(objCont.id);
        contr.fnAssignNDASpecialist();
        
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
    
    public static NDA_Signatory__c getNASignatory(string region){
       NDA_Signatory__c objSign = new NDA_Signatory__c();
        objSign.VP_Name__c = 'ABC';
        objSign.Title__c = 'test title';
        objSign.Email__c = 'abc@test.com';
        objSign.Region_Name__c = region;
        insert objSign;        
        return objSign;
    }
     public static NDA_Notifier__c getNotifier(NDA__c objNDA){
      
       Motorola_Core_Directory__c objRecord = new Motorola_Core_Directory__c();
        objRecord.SurName__c = 'Record'; 
        objRecord.Mail__c = 'abc@test.com'; 
        objRecord.Name = 'NDA Record';       
        insert objRecord;         
       NDA_Notifier__c objnot = new NDA_Notifier__c();
        //objnot.Notifier_Email__c = objRecord.FriendlyEmailAddress__c;
        objnot.NDA__c = objNDA.id;
        objnot.Notifier__c = objRecord.id;
        insert objnot;        
        return objnot;
    }   
   
}