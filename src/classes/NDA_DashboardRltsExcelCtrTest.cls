@isTest
private class NDA_DashboardRltsExcelCtrTest {
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
        objNDA.NDA_Specialist__c = 'smandava@motorola.com';
        
        insert objNDA;
        
        NDA__c nda = [SELECT Id,NDAFileID__c,NDAStatus__c FROM NDA__c limit 1];
        
            PageReference pageRefToExport = Page.NDA_DashboardRltsExcel;
            pageRefToExport.getParameters().put('pv01','Executed');
            pageRefToExport.getParameters().put('pv02','true');
            pageRefToExport.getParameters().put('pv03','');
            pageRefToExport.getParameters().put('pv04','Asia Pac - English');
            Test.setCurrentPage(pageRefToExport);               
           
            NDA_DashboardRltsExcelCtr objContr = new NDA_DashboardRltsExcelCtr();
            objContr.doaction();
        
            PageReference pageRefToExport1 = Page.NDA_DashboardRltsExcel;
            pageRefToExport1.getParameters().put('pv01','Executed');
            pageRefToExport1.getParameters().put('pv02','false');
            pageRefToExport1.getParameters().put('pv03',objComp1.name);
            pageRefToExport1.getParameters().put('pv04','');
            Test.setCurrentPage(pageRefToExport1);
            
            objContr.doaction();
            
            PageReference pageRefToExport2 = Page.NDA_DashboardRltsExcel;
            pageRefToExport2.getParameters().put('pv01','Executed');
            pageRefToExport2.getParameters().put('pv02','false');
            pageRefToExport2.getParameters().put('pv03',objComp1.name);
            pageRefToExport2.getParameters().put('pv04','Asia Pac - English');
            Test.setCurrentPage(pageRefToExport2);
            
            objContr.doaction();
            
            PageReference pageRefToExport4 = Page.NDA_DashboardRltsExcel;
            pageRefToExport4.getParameters().put('pv01','Executed');
            pageRefToExport4.getParameters().put('pv02','true');
            pageRefToExport4.getParameters().put('pv03',objComp1.name);
            pageRefToExport4.getParameters().put('pv04','Asia Pac - English');
            Test.setCurrentPage(pageRefToExport4);
            
            objContr.doaction();
            
            PageReference pageRefToExport3 = Page.NDA_DashboardRltsExcel;
            pageRefToExport3.getParameters().put('pv01','Executed');
            pageRefToExport3.getParameters().put('pv02','false');
            pageRefToExport3.getParameters().put('pv03','');
            pageRefToExport3.getParameters().put('pv04','Asia Pac - English');
            Test.setCurrentPage(pageRefToExport3);
            
            objContr.doaction();
        
        test.stopTest();
    }
    
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
        objNDA.NDA_Specialist__c = 'smandava@motorola.com';
        objNDA.NDAStatus__c = 'Pending';
        
        insert objNDA;

        Profile p = [select id from profile where name='NDA Requester'];
        UserRole r = [Select id from userrole where name='NDA Requester'];
        
        User u = [SELECT Id FROM User WHERE userroleid =:r.Id limit 1];
        NDA__c nda = [SELECT Id,NDAFileID__c,NDAStatus__c FROM NDA__c limit 1];
    
        System.runAs(u) {
        
            PageReference pageRefToExport = Page.NDA_DashboardRltsExcel;
            pageRefToExport.getParameters().put('pv01','Executed');
            pageRefToExport.getParameters().put('pv02','true');
            pageRefToExport.getParameters().put('pv03','');
            pageRefToExport.getParameters().put('pv04','Asia Pac - English');
            Test.setCurrentPage(pageRefToExport);
               
            NDA_DashboardRltsExcelCtr objContr = new NDA_DashboardRltsExcelCtr();
          //  objContr.strSelectedRegion = 'Asia Pac - English';
           // objContr.strTempVar = 'true';
            objContr.doaction();
            
            PageReference pageRefToExport1 = Page.NDA_DashboardRltsExcel;
            pageRefToExport1.getParameters().put('pv01','Executed');
            pageRefToExport1.getParameters().put('pv02','false');
            pageRefToExport1.getParameters().put('pv03',objComp1.name);
            pageRefToExport1.getParameters().put('pv04','');
            Test.setCurrentPage(pageRefToExport1);
            
            objContr.doaction();
            
            PageReference pageRefToExport2 = Page.NDA_DashboardRltsExcel;
            pageRefToExport2.getParameters().put('pv01','Executed');
            pageRefToExport2.getParameters().put('pv02','true');
            pageRefToExport2.getParameters().put('pv03',objComp1.name);
            pageRefToExport2.getParameters().put('pv04','Asia Pac - English');
            Test.setCurrentPage(pageRefToExport2);
            
            objContr.doaction();
            
            PageReference pageRefToExport3 = Page.NDA_DashboardRltsExcel;
            pageRefToExport3.getParameters().put('pv01','Executed');
            pageRefToExport3.getParameters().put('pv02','true');
            pageRefToExport3.getParameters().put('pv03','');
            pageRefToExport3.getParameters().put('pv04','Asia Pac - English');
            Test.setCurrentPage(pageRefToExport3);
            
            objContr.doaction();
            
            PageReference pageRefToExport4 = Page.NDA_DashboardRltsExcel;
            pageRefToExport4.getParameters().put('pv01','Executed');
            pageRefToExport4.getParameters().put('pv02','false');
            pageRefToExport4.getParameters().put('pv03',objComp1.name);
            pageRefToExport4.getParameters().put('pv04','Asia Pac - English');
            Test.setCurrentPage(pageRefToExport4);
            
            objContr.doaction();
        }
        test.stopTest();
    }
    
    static testMethod void fnTest2(){
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
        objNDA.NDA_Specialist__c = 'smandava@motorola.com';
        
        insert objNDA;
        
        NDA_DashboardRltsExcelCtr objContr = new NDA_DashboardRltsExcelCtr();
        objContr.companytwo = objComp1.name;
        objContr.strTempVar = 'true';
        objContr.doaction();
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
        objNDA.NDA_Specialist__c = 'smandava@motorola.com';
        
        insert objNDA;
        
        NDA_DashboardRltsExcelCtr objContr = new NDA_DashboardRltsExcelCtr();
        objContr.strTempVar = 'true';
        objContr.doaction();
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