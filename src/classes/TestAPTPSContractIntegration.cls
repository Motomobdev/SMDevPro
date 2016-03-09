@isTest (SeeAllData=true)
public class TestAPTPSContractIntegration {

 
    
    // Create a Contract
         public static Contract createTestContract(Account a,Contact c1, Contact c2) {  

            Contract con = new Contract(name = 'Test',AccountId=a.id,StartDate = System.Today(),
            ContractTerm = 12,
            Legal_Owner__c = c2.id,
            SW_Procurement_Owner__c = c2.id,
            Product_Team_Owner__c = c1.id,
            Finance_Owner__c = c2.id,
            Contract_Type__c ='SOW - Statement of Work');
            insert con;
            
            Blob b = Blob.valueOf('Test Data');  
            Attachment atch = new Attachment(name = 'Test_contract.pdf', parentId = con.Id, body = b);
            insert atch ;
            
            return con;      
        }
        
        //update Agreement status to test Trigger
        
    public static void TestContract_case1(Contract c) {
        Apttus__APTS_Agreement__c ag = [select id from Apttus__APTS_Agreement__c where contract__c = :c.Id];
        
        ag.APTPS_Executive_Summary_Generated__c = true;
        ag.APTPS_Offline_Document_Imported__c = true;        
        ag.Apttus__Status__c = 'Approved';
        
        update ag; 
    }
    
     public static void TestContract_case2(Contract c) {
        Apttus__APTS_Agreement__c ag = [select id from Apttus__APTS_Agreement__c where contract__c = :c.Id];
        
        ag.APTPS_Executive_Summary_Generated__c = true;
        ag.APTPS_Offline_Document_Imported__c = true;        
        
       // ag.Apttus__Contract_End_Date__c = System.Today();
        ag.Apttus__Term_Months__c = 12;
        ag.Apttus__Company_Signed_Date__c = System.Today();
        ag.Apttus__Other_Party_Signed_Date__c = System.Today();
        
        ag.Apttus__Status__c = 'Activated';
        
        //update contract status to Executed
        update ag; 
    }
    
     public static void InsertAgreementAttachments(Contract c) {
       Apttus__APTS_Agreement__c A = [select id from Apttus__APTS_Agreement__c where contract__c = :c.Id];
       Blob b = Blob.valueOf('Test Data');        
       Attachment atch = new Attachment(name = 'Test_signed.pdf', parentId = A.Id, body = b);
       insert atch ;        
    }
    

    public static testmethod void testAPTPSContractIntegration() {

        Profile p = [select id from profile where name='Apttus Direct SC Contract Manager'];
 
        User user = new User(alias = 'test123', email='test12345@noemail.com',
            emailencodingkey='UTF-8', lastname='Testing1', languagelocalekey='en_US',
            localesidkey='en_US', profileid = p.Id, country='United States',
            timezonesidkey='America/Los_Angeles', username='test12345@noemail.com');
        insert user;

        Account account = new Account();// specify all the required fields
        account.name = 'testing1'; 
        insert account;        
       
        Contact contact1 = new Contact(
            lastname = 'Testing1'
        );
        insert contact1; 

         Account ma = [select Id from Account where name ='Motorola Mobility Inc' LIMIT 1];
          Contact contact2 = new Contact(
            lastname = 'TestingMoto',
            accountid = ma.Id
        );
        insert contact2;

        Contract con = createTestContract(account,contact1,contact2);    
               
        Test.setCurrentPage(Page.APTPS_Contract_Integration);
        ApexPages.StandardController sc = new ApexPages.StandardController(con);
        APTPS_Contract_Integration controller = new APTPS_Contract_Integration(sc);

        sc = new ApexPages.StandardController(con);
        controller = new APTPS_Contract_Integration(sc);
       
       // Test for class APTPS_Contract_Integration
        controller.myCreate(); 
        
        //Test for Trigger Update_Contract_Status 
        // test Approved status
        Recursionblocker.UpdateContractStatusflag = true;
        TestContract_case1(con);
        
          // test signed attachments to Agreement
         InsertAgreementAttachments(con);
        
        //test Activated case for Contract
        Recursionblocker.UpdateContractStatusflag = true;
        TestContract_case2(con);

    }
}