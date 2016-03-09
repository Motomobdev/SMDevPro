/*
Application_ReasonCode.Trigger -- 100%
Account_ReasonCode.Trigger -- 100%
Device_ReasonCode.Trigger -- 100%
Contract_ReasonCode.Trigger -- 100%

Modified By     : Neel Desai
Modified Date   : 31/Aug/2012
Change          : Updated for new and modified reason code; 
                  commented InsertContractUpdate() and modified Contract_ReasonCode_Test(), Account_ReasonCode_Test() and Device_ReasonCode_Test()
*/

@isTest
private class ReasonCode_Test 
{
    /*
    static testMethod void InsertContractUpdate() 
    {
        //Contract_ReasonCode -- Test Contract Insert
        Account acc = New Account(name='Test Account', Tier__c='4');
        insert acc;
            
        date myDate = date.newInstance(2012, 1, 1); 
        Contract c = New Contract(StartDate=myDate,name='Testing Contract', AccountId=acc.id,Contract_Type__c='SLDA - Software Licensing Distribution Agreement');
        System.debug(c.Reason_Code__c +'**********Reason Code Value*************');
        System.debug(c.Status + '************Status***********');
            
        insert c;
          
        Contract updatedcontract = [SELECT ID,Status, Reason_Code__c from Contract where id = :c.id];
        System.debug(updatedcontract.Reason_Code__c + '***********Updated Status************');
        System.assertEquals('NC', updatedcontract.Reason_Code__c);
        System.assertNotEquals(null, updatedcontract.Reason_Code_Last_Modified_Date__c);
    }
    */

    static testmethod void Contract_ReasonCode_Test()
    {
        Account acc = New Account(name='Test Account', Tier__c='4');
        insert acc;
        
        date myDate = date.newInstance(2012, 1, 1);
        Contract c = New Contract(StartDate=myDate,name='Testing Contract', AccountId=acc.id,Contract_Type__c='SLDA - Software Licensing Distribution Agreement');
        insert c;
        
        // Insert new contract
        Contract con = [SELECT Reason_Code__c, Reason_Code_Last_Modified_Date__c FROM Contract WHERE Id=:c.Id];
        System.assertEquals('NC', con.Reason_Code__c);
        System.assertNotEquals(null, con.Reason_Code_Last_Modified_Date__c);

        //Total Number of Applications Change
        Application__c app = New Application__c(Name='Test Application', Application_Type__c='Preload', Application_Sub_Type__c='faketype', Account__c=acc.id, Application_Category__c='Test', Description__c='Desc');
        insert app;
        ContApplAssoc__c conapp = New ContApplAssoc__c(Application__c=app.id, Contract__c=c.id);
        insert conapp;
        update c;
        con = [SELECT Reason_Code__c FROM Contract WHERE Id=:c.Id];
        System.assertEquals('AC', con.Reason_Code__c);

        //Test Contract Start Date Update
        date updatestartdate = date.newInstance(2012,4,4);
        c.StartDate = updatestartdate;
        update c;
        con = [SELECT Reason_Code__c FROM Contract WHERE Id=:c.Id];
        System.assertEquals('CD', con.Reason_Code__c);

        //Test Contract Status Update
        c.Contract_Status__c = 'Dropped';
        c.Contract_Phase__c = 'DROPPED';
        update c;
        con = [SELECT Reason_Code__c FROM Contract WHERE Id=:c.Id];
        System.assertEquals('CS', con.Reason_Code__c);

        //Test Contract Rev Share Change
        c.Rev_Share__c = TRUE;
        update c;
        con = [SELECT Reason_Code__c FROM Contract WHERE Id=:c.Id];
        System.assertEquals('SC', con.Reason_Code__c);

        //Test Contract Name Change
        c.Name = 'Test Contract 1';
        update c;
        con = [SELECT Reason_Code__c FROM Contract WHERE Id=:c.Id];
        System.assertEquals('CN', con.Reason_Code__c);

        //Test Contract Payment Terms Change
        c.Contract_Pmt_Terms__c = 'New test terms';
        update c;
        con = [SELECT Reason_Code__c FROM Contract WHERE Id=:c.Id];
        System.assertEquals('PT', con.Reason_Code__c);

        //contract's earliest SA Date Device changes
        date sadate = date.newInstance(2012,12,12);
        Device__c dev = New Device__c(Name='New Test Device 1', SA_Date__c=sadate);
        insert dev;
        ContractDeviceAssoc__c condev = New ContractDeviceAssoc__c(Device__c=dev.id, Contract__c=c.id);
        insert condev;
        c.Earliest_SA_Date_Device__c = dev.id;
        update c;
        con = [SELECT Reason_Code__c FROM Contract WHERE Id=:c.Id];
        System.assertEquals('ED', con.Reason_Code__c);

        //contract's earliest Device SA date changes
        c.Earliest_Device_SA_Date__c = sadate;
        update c;
        con = [SELECT Reason_Code__c FROM Contract WHERE Id=:c.Id];
        System.assertEquals('ES', con.Reason_Code__c);

        //Test Contract Motorola Entity Change
        c.Motorola_Entity__c = 'MOTOROLA Inc';
        update c;
        con = [SELECT Reason_Code__c FROM Contract WHERE Id=:c.Id];
        System.assertEquals('ME', con.Reason_Code__c);

        //Test Contract Type Update
        c.Contract_Type__c = 'ALDA - Application License and Distribution Agreement';
        update c;
        con = [SELECT Reason_Code__c FROM Contract WHERE Id=:c.Id];
        System.assertEquals('CT', con.Reason_Code__c);
    }


    static testMethod void Account_ReasonCode_Test() 
    {
        User u = [SELECT ID FROM USER WHERE isActive = true AND profileId = '00e40000000oqQ9' LIMIT 1];
        User u2 = [SELECT ID FROM USER WHERE isActive = true AND profileId = '00e40000000oqQ9' and Id !=: u.id LIMIT 1];
        Account acc = New Account(name='Test Account', Tier__c='4', OwnerId = u.Id);
        insert acc;
        date myDate = date.newInstance(2012, 1, 1); 
        Contract c = New Contract(StartDate=myDate,name='Testing Contract', AccountId=acc.id,Contract_Type__c='SLDA - Software Licensing Distribution Agreement');
        insert c;
        Country__c cc = new Country__c(Name='US', Region__c='North America', Country_Code__c='U9');
        insert cc;

        //updated account name
        acc.Name = 'Test Account 1';
        //update acc;
        Contract con = [SELECT Reason_Code__c FROM Contract WHERE Id=:c.Id];
        //System.assertEquals('VC', con.Reason_Code__c);
        
        //eGVM Number
        acc.eGVM_Number__c = '123456';
        update acc;
        con = [SELECT Reason_Code__c FROM Contract WHERE Id=:c.Id];
        //System.assertEquals('TC', con.Reason_Code__c);
        
        //updated account billing country
        acc.Billing_Country__c = cc.Id;
        update acc;
        con = [SELECT Reason_Code__c FROM Contract WHERE Id=:c.Id];
        System.assertEquals('CC', con.Reason_Code__c);
        
        //Tax Withholding
        acc.Tax_Withholding__c = .25;
        update acc;
        con = [SELECT Reason_Code__c FROM Contract WHERE Id=:c.Id];
        System.assertEquals('TX', con.Reason_Code__c);
        
        //Valid_W_8BEN
        acc.Valid_W_8BEN__c = 'Yes';
        update acc;
        con = [SELECT Reason_Code__c FROM Contract WHERE Id=:c.Id];
        System.assertEquals('WB', con.Reason_Code__c);
        
        acc.OwnerId =  u2.id;
        update acc;
        con = [SELECT Reason_Code__c FROM Contract WHERE Id=:c.Id];
        System.assertEquals('PM', con.Reason_Code__c);
    }

    static testmethod void ApplicationReasonCode()
    {
        User u = [SELECT ID FROM USER WHERE isActive = true AND profileId = '00e40000000oqQ9' LIMIT 1];
    
        Country__c country= New Country__c(Name='US', Region__c='North America', Country_Code__c='U9');
        insert country;
        
        Account acc = New Account(name='Test Account', Tier__c='4');
        insert acc;
    
        date myDate = date.newInstance(2012, 1, 1);
    
        Contract c = New Contract(StartDate=myDate,name='Testing Contract', AccountId=acc.id,Contract_Type__c='SLDA - Software Licensing Distribution Agreement');
        insert c;
    
        Application__c a = New Application__c(name='Test App',Application_Type__c='Preload', Application_Sub_Type__c='faketype',Account__c=acc.id,Rev_Share_App__c=TRUE, Application_Category__c='Test', Description__c='Desc');
        insert a;
            
        ContApplAssoc__c ca = New ContApplAssoc__c(Contract__c=c.id,Application__c=a.id);
        insert ca;
        
            
        a.Rev_Share_App__c =False;
        update a;
        
        Contract contractupdate = [SELECT ID, Reason_Code__c from Contract where id =: c.id];
        System.assertEquals('SA', contractupdate.Reason_Code__c);
    
        Application_Country__c appcountry = New Application_Country__c(Application__c=a.id,Country__c=country.id,Relationship__c='Legal');      
            
        insert appcountry;
        update a;
    
        Contract contractupdate2 = [SELECT ID, Reason_Code__c from Contract where id =: c.id];
        System.assertEquals('LS', contractupdate2.Reason_Code__c);
        
        a.Name = '';
        update a;
        
        Contract contractupdate3 = [SELECT Reason_Code__c from Contract where id =: c.id];
        System.assertEquals('AN', contractupdate3.Reason_Code__c);
    }

    static testmethod void Device_ReasonCode_Test()
    {
        User u = [SELECT ID FROM USER WHERE isActive = true AND profileId = '00e40000000oqQ9' LIMIT 1];
        Country__c country= New Country__c(Name='US', Region__c='North America', Country_Code__c='U9');
        insert country;
        Account acc = New Account(name='Test Account', Tier__c='4');
        insert acc;
        date myDate = date.newInstance(2012, 1, 1); 
        Contract c = New Contract(StartDate=myDate,name='Testing Contract', AccountId=acc.id,Contract_Type__c='SLDA - Software Licensing Distribution Agreement');
        insert c;
        Application__c a = New Application__c(name='Test App',Application_Type__c='Preload', Application_Sub_Type__c='faketype',Account__c=acc.id, Application_Category__c='Test', Description__c='Desc');
        insert a;
        Device__c d = New Device__c(Name='Test Device', Device_ID__c='475639857',APC_code__c='');
        insert d;
        Sales_Model__c sm = new Sales_Model__c(Name='Test SM');
        insert sm; 
        
        d.Device_ID__c='45345346775';
        update d;
        Device__c d0 = [SELECT Reason_Code__c FROM Device__c WHERE Id=:d.Id];
        System.assertEquals('DC', d0.Reason_Code__c);
    
        d.APC_Code__c='APC';
        update d;
        d0 = [SELECT Reason_Code__c FROM Device__c WHERE Id=:d.Id];
        System.assertEquals('AP', d0.Reason_Code__c);   
    
        DeviceApplicationAssoc__c devapp = New DeviceApplicationAssoc__c(Device__c=d.id,Application__c=a.id);
        insert devapp;
        update d;
        d0 = [SELECT Reason_Code__c FROM Device__c WHERE Id=:d.Id];
        System.assertEquals('SK', d0.Reason_Code__c);  
        
        d.Device_Fully_Approved__c = 'Yes';
        update d;
        d0 = [SELECT Reason_Code__c FROM Device__c WHERE Id=:d.Id];
        System.assertEquals('FA', d0.Reason_Code__c);  
    
        d.BLUR_Version_String__c = 'new value';
        update d;
        d0 = [SELECT Reason_Code__c FROM Device__c WHERE Id=:d.Id];
        System.assertEquals('BV', d0.Reason_Code__c);  

        SalesModel_Device__c smd = new SalesModel_Device__c(Sales_Model__c=sm.Id, Device__c=d.Id);
        insert smd;
        update d;
        d0 = [SELECT Reason_Code__c FROM Device__c WHERE Id=:d.Id];
        System.assertEquals('SM', d0.Reason_Code__c);
    }
}