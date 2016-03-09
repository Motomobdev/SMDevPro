/*************************************************************
  COMMENT: Testmethod for the APTPS_CA_CreateContract class
  CreatedBy: Swetha Mandava  
**************************************************************/  
@isTest(SeeAllData = false)
public class APTPS_CA_CreateContractTestClass{
    static testMethod void myUnitTest() {   
        test.startTest(); 
        // 1. Create Account
        Account acct = new Account(Name='Test Account');
        insert acct; 
    
       
         // Parent Agreement                                   
         Apttus__APTS_Agreement__c parentagmt = new Apttus__APTS_Agreement__c 
                                            (   
                                                Name = 'Test Agreement #1', 
                                                APTPS_Practice_Area__c='Indirect Supply Chain',
                                                APTPS_subtype__c = 'Master Services Agreement (MSA)',
                                                APTPS_Primary_Contact__c='Test Contact',
                                                APTPS_Primary_Contact_Email__c='test@test.com',
                                                APT_MMI_Contracting_Entity__c='Motorola Mobility LLC',
                                                Apttus__Status_Category__c = 'Request',
                                                APT_Region__c='Global',
                                                RecordTypeId = '01240000000QJ1MAAW',
                                                Apttus__Status__c = 'Request',
                                                Apttus__Account__c = acct.id,
                                                APTPS_Executive_Summary_Generated__c = false
                                            );
                                            
        // 2. Create Agreement
        Apttus__APTS_Agreement__c newagmt = new Apttus__APTS_Agreement__c 
                                            (   
                                                Name = 'Test Agreement #1', 
                                                APTPS_Practice_Area__c='Indirect Supply Chain',
                                                APTPS_Primary_Contact__c='Test Contact',
                                                APTPS_Primary_Contact_Email__c='test@test.com',
                                                APT_MMI_Contracting_Entity__c='Motorola Mobility LLC',
                                                Apttus__Status_Category__c = 'Request',
                                                APT_Region__c='Global',
                                                RecordTypeId = '01240000000QJ1MAAW',
                                                Apttus__Status__c = 'Request',
                                                Apttus__Account__c = acct.id,
                                                APTPS_Executive_Summary_Generated__c = false,
                                                Apttus__Parent_Agreement__c = parentagmt.id
                                            );
                                            
       
        
      // STEP 3 - Create the controller          
          ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(newagmt);         
          APTPS_CA_CreateContract controller1 = new APTPS_CA_CreateContract(sc);      
          PageReference currPage = Page.APTPS_CA_CreateContract;
     
      // Test preview mode of the controller
         Test.setCurrentPage(currPage);          

         controller1.availableTab=0;
         controller1.currentTab='tab0';
         PageReference newPage1 = controller1.nextTabStep();      
         newPage1 = controller1.cancelTab();
         newagmt.Available_Tab__c=1;
         
         newagmt.APTPS_subtype__c = 'Master Services Agreement (MSA)'; 
         
         controller1.availableTab=1;
         controller1.currentTab='tab1';   
         newPage1 = controller1.mySave();
         newPage1 = controller1.nextTab();
         newPage1 = controller1.prevTab();
         newPage1 = controller1.nextTabStep1();          
         newPage1 = controller1.cancelTab();
         newPage1 = controller1.detailViewTab();
         newagmt.Available_Tab__c=2;
        
         newagmt.Is_Supplier_Customer_on_Connected_Party__c = 'Yes';
         controller1.availableTab=2;
         controller1.currentTab='tab2';             
         
         //insert newagmt; 
         controller1.availableTab=2; 
         
         newPage1 = controller1.mySave();  
         newPage1 = controller1.nextTab();       
         newPage1 = controller1.prevTab();
         newPage1 = controller1.nextTabStep1();
         newPage1 = controller1.cancelTab();
         newPage1 = controller1.detailViewTab();
         newPage1 = controller1.createContract();
         newPage1 = controller1.reviewExSummary();
         newPage1 = controller1.fnSubmitApproval();
         newPage1 = controller1.Activate();
         newPage1 = controller1.fnSendforSignatures();            
         newPage1 = controller1.setRedirectFalse();
         controller1.recordTab(); 
         controller1.getRecordTypes();
         controller1.updateRecordType();
         controller1.getstrSectionHeader();
         controller1.setAgreementTab();
         controller1.getstrAgreementName();
         controller1.populateLegalRep();
         controller1.populateChannelPartnerInfo();
         controller1.populateMotoSignerInfo();
         controller1.fnShowParent();
         controller1.fnShowThirdSigner();
         
         controller1.getMonthsBetween(Date.newInstance(2014, 07, 15),Date.newInstance(2017, 07, 15));
         
         newagmt.APTPS_Executive_Summary_Generated__c = true;
         newagmt.Apttus__Contract_End_Date__c = Date.newInstance(2017, 07, 15);
         newagmt.Apttus__Contract_Start_Date__c = Date.newInstance(2014, 07, 15);
         newagmt.Company_Signed_DateTime__c = Date.newInstance(2014, 07, 15);
         newagmt.Other_Party_Signed_DateTime__c = Date.newInstance(2014, 07, 15);
         newagmt.Apttus__Term_Months__c = 36;
         newagmt.Target_Close_Month__c = Date.newInstance(2017, 07, 15);
         newagmt.APTPS_TargetClose_Reason__c='Other';
         newagmt.APTPS_TargetClose_Reason__c='Other';  
         newagmt.Available_Tab__c=3;         
         update newagmt;         
         controller1.availableTab=3; 
         controller1.currentTab='tab3';           
         newPage1 = controller1.mySave();
         newPage1 = controller1.nextTab();
         newPage1 = controller1.prevTab(); 
       
         
         List<User> testfinanceOwner = [Select id,email from User where name = 'test 01'];
         
         newagmt.Apttus__Status_Category__c = 'In Authoring';
         newagmt.Apttus__Status__c = 'Author Contract'; 
         newagmt.Payment_Terms_Based_on_Receipt__c = '30';
         newagmt.APTPS_Practice_Area__c='GTM';
         newagmt.APTPS_Functional_Finance_Approver__c = testfinanceOwner[0].id;
         newagmt.Available_Tab__c=4;  
         update newagmt;    
         controller1.availableTab=4;  
         controller1.currentTab='tab4';                 
         newPage1 = controller1.mySave();
         newPage1 = controller1.nextTab();
         newPage1 = controller1.prevTab(); 
         newPage1 = controller1.createContract();
         newPage1 = controller1.reviewExSummary(); 
         newPage1 = controller1.notifyFinance();
         
         newagmt.Contract_Departments__c='Marketing'; 
         controller1.populateLegalRep();
         Blob b1 = Blob.valueOf('Test Data');  
         Attachment atch1 = new Attachment(name = 'Test_contract1.pdf', parentId = newagmt.Id, body = b1);
         insert atch1 ; 
         
         controller1.getApttusAttachments();      
         controller1.attachmentList[0].selected =true;   
         controller1.attachmentList[0].attach=atch1;
         
         newPage1 = controller1.sendEmailFunction();      
       
         newagmt.Apttus__Status_Category__c = 'In Authoring';
         newagmt.Apttus__Status__c = 'Approved';
         newagmt.Apttus_Approval__Approval_Status__c = 'Approved';
         newagmt.Available_Tab__c=5;  
         update newagmt; 
         controller1.availableTab=5; 
         controller1.currentTab='tab5';                     
         newPage1 = controller1.mySave();
         newPage1 = controller1.nextTab();
         newPage1 = controller1.prevTab(); 
         newPage1 = controller1.fnSubmitApproval();
      
         
         Blob b = Blob.valueOf('Test Data');  
         Attachment atch = new Attachment(name = 'Test_contract.pdf', parentId = newagmt.Id, body = b);
         insert atch ;

         Contact contact2 = new Contact(
            lastname = 'TestingMoto',
            email='test@test.com',
            accountid = acct.Id
            );
         insert contact2;         
         
         controller1.getApttusAttachments();      
         controller1.attachmentList[0].selected =true;   
         controller1.attachmentList[0].attach=atch; 
         controller1.boolShowThirdSigner=true;
         
         echosign_dev1__SIGN_Data_Mapping__c datamapping = new echosign_dev1__SIGN_Data_Mapping__c(name = 'Apttus DataMapping');
         insert datamapping ;
         
         
         newagmt.Apttus__Status_Category__c = 'In Signatures';
         newagmt.Apttus__Status__c = 'Other Party Signatures';
         newagmt.Outside_Party_Signatory_Email__c= 'test@test.com';
         newagmt.Outside_Party_Signatory_Name__c='test';
         newagmt.Outside_Party_Signatory_2_Email__c= 'test2@test.com';
         newagmt.Outside_Party_Signatory_2_Name__c='test2';
         newagmt.Motorola_Signatory__c= testfinanceOwner[0].id;
         newagmt.Available_Tab__c=6;  
         update newagmt;         
         
         controller1.availableTab=6; 
         controller1.currentTab='tab6';            
         newPage1 = controller1.mySave();
         newPage1 = controller1.nextTab();
         newPage1 = controller1.prevTab();
         newPage1 = controller1.fnSendforSignatures();         
         
         newagmt.Apttus__Status_Category__c = 'In Signatures';
         newagmt.Apttus__Status__c = 'Fully Signed';
         newagmt.Available_Tab__c=7;          
         update newagmt;    
         controller1.availableTab=7; 
         controller1.currentTab='tab7';        
         newPage1 = controller1.mySave();
         newPage1 = controller1.nextTab();
         newPage1 = controller1.prevTab();
         newPage1 = controller1.Activate(); 
         
         newagmt.Apttus__Other_Party_Signed_Date__c = Date.newInstance(2017, 07, 15);
         newagmt.Apttus__Company_Signed_Date__c = Date.newInstance(2017, 07, 15);  
         newagmt.Apttus__Status_Category__c = 'In Effect';
         newagmt.Apttus__Status__c = 'Activated';
         newagmt.Redirect_User__c=''; 
         update newagmt; 
         controller1.availableTab=7;  
         controller1.currentTab='tab7';          
         newPage1 = controller1.mySave();
         newPage1 = controller1.nextTab();
         newPage1 = controller1.prevTab();   
        test.stopTest();  
    }
    
    
    static testMethod void myUnitTest2() {   
        test.startTest(); 
        // 1. Create Account
        Account acct = new Account(Name='Test Account2');
        insert acct; 
                                            
        // 2. Create Agreement
        Apttus__APTS_Agreement__c newagmt = new Apttus__APTS_Agreement__c 
                                            (   
                                                Name = 'Test Agreement #2', 
                                                APTPS_Practice_Area__c='Direct Supply Chain',
                                                APTPS_subtype__c = 'Master Services Agreement (MSA)',
                                                APTPS_Primary_Contact__c='Test Contact',
                                                APTPS_Primary_Contact_Email__c='test@test.com',
                                                APT_MMI_Contracting_Entity__c='Motorola Mobility LLC',
                                                Apttus__Status_Category__c = 'In Filing',
                                                APT_Region__c='Global',
                                                RecordTypeId = '01240000000QJSdAAO',
                                                Apttus__Status__c = 'Request',
                                                Apttus__Account__c = acct.id,
                                                APTPS_Executive_Summary_Generated__c = false,
                                                Is_Supplier_Customer_on_Connected_Party__c='Yes'
                                            );
        insert newagmt; 
       
        Blob b = Blob.valueOf('Test Data');  
        Attachment atch = new Attachment(name = 'Test_contract.pdf', parentId = newagmt.Id, body = b);
        insert atch ;                                    
       
        
      // STEP 3 - Create the controller       
          ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(newagmt);
          APTPS_CA_CreateContract controller1 = new APTPS_CA_CreateContract(sc);      
          PageReference currPage = Page.APTPS_CA_CreateContract;
     
      // Test preview mode of the controller
         Test.setCurrentPage(currPage); 
                
         controller1.availableTab=0;
         controller1.currentTab='tab0';
         PageReference newPage1 = controller1.nextTabStep();      
         newPage1 = controller1.cancelTab();
         newagmt.Available_Tab__c=1;
                     
         controller1.availableTab=1;
         controller1.currentTab='tab1';   
         newPage1 = controller1.mySave();
         newPage1 = controller1.nextTab();
         newPage1 = controller1.prevTab();
         newPage1 = controller1.nextTabStep1();          
         newPage1 = controller1.cancelTab();
         newPage1 = controller1.detailViewTab();
         newagmt.Available_Tab__c=2;
         controller1.availableTab=2;
         controller1.currentTab='tab2';                                                         
                  
         controller1.availableTab=2; 
         newPage1 = controller1.mySave();
         newPage1 = controller1.nextTab();
         newPage1 = controller1.prevTab();
         newPage1 = controller1.nextTabStep1();
         newPage1 = controller1.cancelTab();
         newPage1 = controller1.detailViewTab();
         newPage1 = controller1.createContract();
         newPage1 = controller1.reviewExSummary();
         newPage1 = controller1.fnSubmitApproval();
         newPage1 = controller1.Activate();
         newPage1 = controller1.fnSendforSignatures();            
         newPage1 = controller1.setRedirectFalse();
         controller1.recordTab(); 
         controller1.getRecordTypes();
         controller1.updateRecordType();
         controller1.getstrSectionHeader();
         controller1.setAgreementTab();
         controller1.getstrAgreementName();
         newagmt.Contract_Departments__c='Regional: NA';
         controller1.populateLegalRep();
         controller1.populateChannelPartnerInfo();
         controller1.populateMotoSignerInfo();
         controller1.fnShowParent();
         controller1.fnShowThirdSigner();
         
         controller1.getMonthsBetween(Date.newInstance(2014, 07, 15),Date.newInstance(2017, 07, 15));
         
         newagmt.APTPS_Executive_Summary_Generated__c = true;
         newagmt.Apttus__Contract_End_Date__c = Date.newInstance(2017, 07, 15);
         newagmt.Apttus__Contract_Start_Date__c = Date.newInstance(2014, 07, 15);
         newagmt.Company_Signed_DateTime__c = Date.newInstance(2014, 07, 15);
         newagmt.Other_Party_Signed_DateTime__c = Date.newInstance(2014, 07, 15);
         newagmt.Apttus__Term_Months__c = 36;
         newagmt.Target_Close_Month__c = Date.newInstance(2017, 07, 15);       
         newagmt.APTPS_TargetClose_Reason__c='Other';
         newagmt.APTPS_TargetClose_Reason__c='Other';  
         newagmt.Available_Tab__c=3;         
         update newagmt;         
         controller1.availableTab=3; 
         controller1.currentTab='tab3';           
         newPage1 = controller1.mySave();
         newPage1 = controller1.nextTab();
         newPage1 = controller1.prevTab(); 
         
         List<User> testfinanceOwner = [Select id,email from User where name = 'test 01'];
         
         newagmt.Apttus__Status_Category__c = 'In Filing';
         newagmt.Payment_Terms_Based_on_Receipt__c = '30';
         newagmt.APTPS_Practice_Area__c='GTM';
         newagmt.APTPS_Functional_Finance_Approver__c = testfinanceOwner[0].id;
         newagmt.Apttus__Term_Months__c=10;
         newagmt.Available_Tab__c=4;  
         update newagmt;    
         controller1.availableTab=4;  
         controller1.currentTab='tab4';                 
         newPage1 = controller1.mySave();
         newPage1 = controller1.nextTab();
         newPage1 = controller1.prevTab(); 
         newPage1 = controller1.createContract();
         newPage1 = controller1.reviewExSummary(); 
         newPage1 = controller1.notifyFinance();
         newagmt.APT_Payment_Term_Days__c = '90'; 
         newagmt.Contract_Departments__c='Government Relations'; 
 
         
         newPage1 = controller1.sendEmailFunction();         
         System.assertEquals(controller1.sendEmailFunction(),null); 
         
         newagmt.Apttus__Other_Party_Signed_Date__c = Date.newInstance(2017, 07, 15);
         newagmt.Apttus__Company_Signed_Date__c = Date.newInstance(2017, 07, 15);            
         newagmt.Apttus__Status_Category__c = 'In Effect';
         newagmt.Apttus__Status__c = 'Activated';
         newagmt.Redirect_User__c=''; 
         update newagmt; 
         controller1.availableTab=7;  
         controller1.currentTab='tab7';          
         newPage1 = controller1.mySave();
         newPage1 = controller1.nextTab();
         newPage1 = controller1.prevTab();
         
         test.stopTest();  
    }
    
   
    
    static testMethod void myUnitTest3() {   
        test.startTest(); 
        System.runAs ( new User(Id = UserInfo.getUserId()) ) {
        Folder test_template_folder = 
            [Select Id from Folder Where Type = 'Email' And IsReadOnly = false Limit 1];
        
        EmailTemplate test_template = new EmailTemplate(
            Name = 'test email template', DeveloperName = 'test_template_uniqueasdfbahkls',
            TemplateType = 'text', isActive = true, Description = 'test template',
            Subject = 'test email', FolderId = test_template_folder.Id,
            Body = 'Hi , this is a test email to a user.'
        );
        insert test_template; 
        }  
        // 1. Create Account
        Account acct = new Account(Name='Test Account3');
        insert acct; 
                                            
        // 2. Create Agreement
        Apttus__APTS_Agreement__c newagmt = new Apttus__APTS_Agreement__c 
                                            (   
                                                Name = 'Test Agreement #3', 
                                                APTPS_Practice_Area__c='GTM',
                                                APTPS_subtype__c = 'Master Services Agreement (MSA)',
                                                APTPS_Primary_Contact__c='Test Contact1',
                                                APTPS_Primary_Contact_Email__c='test1@test.com',
                                                APT_MMI_Contracting_Entity__c='Motorola Mobility LLC',
                                                Apttus__Status_Category__c = 'In Authoring',
                                                APT_Region__c='Global',
                                                RecordTypeId = '01240000000QJ1MAAW',
                                                Apttus__Status__c = 'Request',
                                                Apttus__Account__c = acct.id,
                                                APTPS_Executive_Summary_Generated__c = true,
                                                Is_Supplier_Customer_on_Connected_Party__c='Yes'                                              
                                            );
        insert newagmt; 
       
        Blob b = Blob.valueOf('Test Data3');  
        Attachment atch = new Attachment(name = 'Test_contract3.pdf', parentId = newagmt.Id, body = b);
        insert atch ; 
                                     
        
      // STEP 3 - Create the controller       
          ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(newagmt);
          APTPS_CA_CreateContract controller1 = new APTPS_CA_CreateContract(sc);      
          PageReference currPage = Page.APTPS_CA_CreateContract;
     
      // Test preview mode of the controller
         Test.setCurrentPage(currPage); 
                
         controller1.availableTab=0;
         controller1.currentTab='tab0';
         PageReference newPage1 = controller1.nextTabStep();      
         newPage1 = controller1.cancelTab();
         newagmt.Available_Tab__c=1;
                     
         controller1.availableTab=1;
         controller1.currentTab='tab1';   
         newPage1 = controller1.mySave();
         newPage1 = controller1.nextTab();
         newPage1 = controller1.prevTab();
         newPage1 = controller1.nextTabStep1();          
         newPage1 = controller1.cancelTab();
         newPage1 = controller1.detailViewTab();
         newagmt.Available_Tab__c=2;
         controller1.availableTab=2;
         controller1.currentTab='tab2';                                                         
                  
         controller1.availableTab=2; 
         newPage1 = controller1.mySave();
         newPage1 = controller1.nextTab();
         newPage1 = controller1.prevTab();
         newPage1 = controller1.nextTabStep1();
         newPage1 = controller1.cancelTab();
         newPage1 = controller1.detailViewTab();
         newPage1 = controller1.createContract();
         newPage1 = controller1.reviewExSummary();
         newPage1 = controller1.fnSubmitApproval();
         newPage1 = controller1.Activate();
         newPage1 = controller1.fnSendforSignatures();            
         newPage1 = controller1.setRedirectFalse();
         controller1.recordTab(); 
         controller1.getRecordTypes();
         controller1.updateRecordType();
         controller1.getstrSectionHeader();
         controller1.setAgreementTab();
         controller1.getstrAgreementName();
         controller1.populateLegalRep();
         controller1.populateChannelPartnerInfo();
         controller1.populateMotoSignerInfo();
         controller1.fnShowParent();
         controller1.fnShowThirdSigner();
         
         controller1.getMonthsBetween(Date.newInstance(2014, 07, 15),Date.newInstance(2017, 07, 15));
         newagmt.Apttus__Total_Contract_Value__c = 0;
         newagmt.APTPS_Executive_Summary_Generated__c = true;
         newagmt.Apttus__Contract_End_Date__c = Date.newInstance(2017, 07, 15);
         newagmt.Apttus__Contract_Start_Date__c = Date.newInstance(2014, 07, 15);
         newagmt.Company_Signed_DateTime__c = Date.newInstance(2014, 07, 15);
         newagmt.Other_Party_Signed_DateTime__c = Date.newInstance(2014, 07, 15);
         newagmt.Apttus__Term_Months__c = 36;
         newagmt.Target_Close_Month__c = Date.newInstance(2017, 07, 15);       
         newagmt.APTPS_TargetClose_Reason__c='Other';
         newagmt.Connected_Party_Approval_Status__c = 'Pending';
         newagmt.APTPS_Practice_Area__c='GTM'; 
         newagmt.Payment_Terms_Based_on_Invoice_Shipping__c='30';
         newagmt.Available_Tab__c=3;         
         update newagmt;         
         controller1.availableTab=3; 
         controller1.currentTab='tab3';           
         newPage1 = controller1.mySave();
         newPage1 = controller1.nextTab();
         newPage1 = controller1.prevTab(); 
         
         List<User> testfinanceOwner = [Select id,email from User where name = 'test 01'];
         
         newagmt.Apttus__Status_Category__c = 'In Filing';
         newagmt.Payment_Terms_Based_on_Receipt__c = '30';
         newagmt.APTPS_Practice_Area__c='GTM';
         newagmt.APTPS_Functional_Finance_Approver__c = testfinanceOwner[0].id;
        // newagmt.Payment_Terms_Based_on_Receipt__c =30;
         newagmt.Available_Tab__c=4;  
         update newagmt;    
         controller1.availableTab=4;  
         controller1.currentTab='tab4';                 
         newPage1 = controller1.mySave();
         newPage1 = controller1.nextTab();
         newPage1 = controller1.prevTab(); 
         newPage1 = controller1.createContract();
         newPage1 = controller1.reviewExSummary(); 
         newPage1 = controller1.notifyFinance();
          
         newagmt.Contract_Departments__c='Customs'; 
         controller1.populateLegalRep();
         Blob b3 = Blob.valueOf('Test Data3');  
         Attachment atch3 = new Attachment(name = 'Test_contract3.pdf', parentId = newagmt.Id, body = b3);
         insert atch3 ; 

         
           Contact contact3 = new Contact(
            lastname = 'TestingMoto3',
            email='test3@test.com',
            accountid = acct.Id
            );
         insert contact3; 
         
         controller1.getApttusAttachments();      
         controller1.attachmentList[0].selected =true;   
         controller1.attachmentList[0].attach=atch3; 
                 

        // When an email is constructed & sent  with that template
         newPage1 = controller1.sendEmailFunction();  
         
         newagmt.Apttus__Other_Party_Signed_Date__c = Date.newInstance(2017, 07, 15);
         newagmt.Apttus__Company_Signed_Date__c = Date.newInstance(2017, 07, 15);            
         newagmt.Apttus__Status_Category__c = 'In Effect';
         newagmt.Apttus__Status__c = 'Activated';
         newagmt.Redirect_User__c=''; 
         update newagmt; 
         controller1.availableTab=7;  
         controller1.currentTab='tab7';          
         newPage1 = controller1.mySave();
         newPage1 = controller1.nextTab();
         newPage1 = controller1.prevTab();
         
         
         test.stopTest(); 
         
    }
    
    static testMethod void myUnitTest4() {   
        test.startTest(); 
        System.runAs ( new User(Id = UserInfo.getUserId()) ) {
        Folder test_template_folder = 
            [Select Id from Folder Where Type = 'Email' And IsReadOnly = false Limit 1];
        
        EmailTemplate test_template = new EmailTemplate(
            Name = 'test email template', DeveloperName = 'test_template_uniqueasdfbahkls',
            TemplateType = 'text', isActive = true, Description = 'test template',
            Subject = 'test email', FolderId = test_template_folder.Id,
            Body = 'Hi , this is a test email to a user.'
        );
        insert test_template; 
        }  
        // 1. Create Account
        Account acct = new Account(Name='Test Account3');
        insert acct; 
                                            
        // 2. Create Agreement
        Apttus__APTS_Agreement__c newagmt = new Apttus__APTS_Agreement__c 
                                            (   
                                                Name = 'Test Agreement #4', 
                                                APTPS_Practice_Area__c='Marketing',
                                                APTPS_subtype__c = 'Master Services Agreement (MSA)',
                                                APTPS_Primary_Contact__c='Test Contact3',
                                                APTPS_Primary_Contact_Email__c='test3@test.com',
                                                APT_MMI_Contracting_Entity__c='Motorola Mobility LLC',
                                                Apttus__Status_Category__c = 'In Authoring',
                                                APT_Region__c='Global',
                                                RecordTypeId = '01240000000QJRVAA4',
                                                Apttus__Status__c = 'Request',
                                                Apttus__Account__c = acct.id,
                                                APTPS_Executive_Summary_Generated__c = true,
                                                Is_Supplier_Customer_on_Connected_Party__c='Yes',
                                                Apttus_Approval__Approval_Status__c='Pending'                                             
                                            );
        insert newagmt; 
       
      
                                     
        
      // STEP 3 - Create the controller       
          ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(newagmt);
          APTPS_CA_CreateContract controller1 = new APTPS_CA_CreateContract(sc);      
          PageReference currPage = Page.APTPS_CA_CreateContract;
     
      // Test preview mode of the controller
         Test.setCurrentPage(currPage); 
                
         controller1.availableTab=0;
         controller1.currentTab='tab0';
         PageReference newPage1 = controller1.nextTabStep();      
         newPage1 = controller1.cancelTab();
         newagmt.Available_Tab__c=1;
                     
         controller1.availableTab=1;
         controller1.currentTab='tab1';   
         newPage1 = controller1.mySave();
         newPage1 = controller1.nextTab();
         newPage1 = controller1.prevTab();
         newPage1 = controller1.nextTabStep1();          
         newPage1 = controller1.cancelTab();
         newPage1 = controller1.detailViewTab();
         newagmt.Available_Tab__c=2;
         controller1.availableTab=2;
         controller1.currentTab='tab2';                                                         
                  
         controller1.availableTab=2; 
         controller1.recordTab(); 
         controller1.getRecordTypes();
         controller1.updateRecordType();
         controller1.getstrSectionHeader();
         controller1.setAgreementTab();
         controller1.getstrAgreementName();
         newagmt.Contract_Departments__c='GTM: Retail';
         newagmt.RecordTypeId ='01240000000QJRVAA4'; 
         controller1.populateLegalRep();
         controller1.emailLegalRep();
         controller1.populateChannelPartnerInfo();
         controller1.populateMotoSignerInfo();
         controller1.fnShowParent();
         controller1.fnShowThirdSigner();
         newPage1 = controller1.mySave();
         newPage1 = controller1.nextTab();
         newPage1 = controller1.prevTab();
         newPage1 = controller1.nextTabStep1();
         newPage1 = controller1.cancelTab();
         newPage1 = controller1.detailViewTab();
         newPage1 = controller1.createContract();
         newPage1 = controller1.reviewExSummary();
         newPage1 = controller1.fnSubmitApproval();
         newPage1 = controller1.Activate();
         newPage1 = controller1.fnSendforSignatures();            
         newPage1 = controller1.setRedirectFalse();
         
         
         controller1.getMonthsBetween(Date.newInstance(2014, 07, 15),Date.newInstance(2017, 07, 15));
         newagmt.Apttus__Total_Contract_Value__c = 0;
         newagmt.APTPS_Executive_Summary_Generated__c = true;
         newagmt.Apttus__Contract_End_Date__c = Date.newInstance(2017, 07, 15);
         newagmt.Apttus__Contract_Start_Date__c = Date.newInstance(2014, 07, 15);
         newagmt.Company_Signed_DateTime__c = Date.newInstance(2014, 07, 15);
         newagmt.Other_Party_Signed_DateTime__c = Date.newInstance(2014, 07, 15);
         newagmt.Apttus__Term_Months__c = 36;
         newagmt.Target_Close_Month__c = Date.newInstance(2017, 07, 15);       
         newagmt.APTPS_TargetClose_Reason__c='Other';
         newagmt.Connected_Party_Approval_Status__c = 'Pending';
         newagmt.Payment_Terms_Based_on_Invoice_Shipping__c='30';
         newagmt.Available_Tab__c=3;         
         update newagmt;         
         controller1.availableTab=3; 
         controller1.currentTab='tab3';           
         newPage1 = controller1.mySave();
         newPage1 = controller1.nextTab();
         newPage1 = controller1.prevTab(); 
         
         List<User> testfinanceOwner = [Select id,email from User where name = 'test 01'];
         
         newagmt.Apttus__Status_Category__c = 'In Filing';
         newagmt.Payment_Terms_Based_on_Receipt__c = '30';
         newagmt.APTPS_Practice_Area__c='GTM';
         newagmt.APTPS_Functional_Finance_Approver__c = testfinanceOwner[0].id;
        // newagmt.Payment_Terms_Based_on_Receipt__c =30;
         newagmt.Available_Tab__c=4;  
         update newagmt;    
         controller1.availableTab=4;  
         controller1.currentTab='tab4';                 
         newPage1 = controller1.mySave();
         newPage1 = controller1.nextTab();
         newPage1 = controller1.prevTab(); 
         newPage1 = controller1.createContract();
         newPage1 = controller1.reviewExSummary(); 
         newPage1 = controller1.notifyFinance();
          
         newagmt.Contract_Departments__c='Customs'; 
         controller1.populateLegalRep();
           Contact contact4 = new Contact(
            lastname = 'TestingMoto4',
            email='test4@test.com',
            accountid = acct.Id
            );
         insert contact4; 
         
         controller1.getApttusAttachments();      

        // When an email is constructed & sent  with that template
         newPage1 = controller1.sendEmailFunction();  
         
         echosign_dev1__SIGN_Data_Mapping__c datamapping = new echosign_dev1__SIGN_Data_Mapping__c(name = 'Apttus DataMapping');
         insert datamapping ;
         
         
         newagmt.Apttus__Status_Category__c = 'In Signatures';
         newagmt.Apttus__Status__c = 'Other Party Signatures';
         newagmt.Outside_Party_Signatory_Email__c= 'test@test.com';
         newagmt.Outside_Party_Signatory_Name__c='test';
         newagmt.Outside_Party_Signatory_2_Email__c= 'test2@test.com';
         newagmt.Outside_Party_Signatory_2_Name__c='test2';
         newagmt.Motorola_Signatory__c= testfinanceOwner[0].id;
         newagmt.Available_Tab__c=6;  
         update newagmt;         
         
         controller1.availableTab=6; 
         controller1.currentTab='tab6';            
         newPage1 = controller1.mySave();
         newPage1 = controller1.nextTab();
         newPage1 = controller1.prevTab();
         newPage1 = controller1.fnSendforSignatures();         
         
         newagmt.Apttus__Status_Category__c = 'In Signatures';
         newagmt.Apttus__Status__c = 'Fully Signed';
         newagmt.Available_Tab__c=7;          
         update newagmt;    
         controller1.availableTab=7; 
         controller1.currentTab='tab7';        
         newPage1 = controller1.mySave();
         newPage1 = controller1.nextTab();
         newPage1 = controller1.prevTab();
         newPage1 = controller1.Activate(); 
         
         newagmt.Apttus__Other_Party_Signed_Date__c = Date.newInstance(2017, 07, 15);
         newagmt.Apttus__Company_Signed_Date__c = Date.newInstance(2017, 07, 15);  
         newagmt.Apttus__Status_Category__c = 'In Effect'; 
         newagmt.Apttus__Status__c = 'Activated';
         newagmt.Redirect_User__c=''; 
         update newagmt; 
         controller1.availableTab=7;  
         controller1.currentTab='tab7';          
         newPage1 = controller1.mySave();
         newPage1 = controller1.nextTab();
         newPage1 = controller1.prevTab();   
        test.stopTest();  
         
    }
    
    
    

}