@isTest
public class JiraImporterTest {
	
    @isTest
    public static void updateDevicesTest(){
        String SVNName = 'SVN123ABC';
        String DeviceID = '987654';

    	Device__c dev = new Device__c(Device_ID__c=DeviceID,Name='JiraDEV');
        insert dev;       
        
        SW_Kit__c swKit = new SW_Kit__c();
        swKit.Name = SVNName;
        insert swKit;	

        Jira_Device__c jiraDevice = new Jira_Device__c();
        jiraDevice.Blur_Version__c = 'Blur_Version';
        jiraDevice.Build_Fingerprint__c = 'Blur_fingerPrint';
        jiraDevice.Device_ID__c = DeviceID;
        jiraDevice.Device__c = dev.ID;
        jiraDevice.Issue_ID__c = '12398672';
        jiraDevice.SW_KIT_ID__c = SVNName;
        jiraDevice.SW_KIT__c = swKit.ID;        
        jiraDevice.Updated_From_SF__c = false;
        insert jiraDevice;

        Test.startTest();
		JiraImporter jiraImporter = new JiraImporter();
        jiraImporter.updateDevices();
        Test.stopTest();   
        
        List<Jira_Device__c> updatedJiraDevices = [select ID,Updated_From_SF__c from Jira_Device__c];
                
        System.assert(!updatedJiraDevices.isEmpty());
        System.assert(updatedJiraDevices.get(0).Updated_From_SF__c == true);
    }
    
    @isTest
    public static void pushJiraDevicesTest(){   
        String SVNName = 'SVN123ABC';
        String SVNName2 = 'SVN123XYZ';
        String DeviceID = '987654';

    	Device__c dev = new Device__c(Device_ID__c=DeviceID,Name='JiraDEV');
        insert dev;       
        
        SW_Kit__c swKit = new SW_Kit__c();
        swKit.Name = SVNName;
        insert swKit;	

        SW_Kit__c swKit2 = new SW_Kit__c();
        swKit2.Name = SVNName2;
        insert swKit2;	

        
        JIRA_Issue_prod__c jiraIssue = new  JIRA_Issue_prod__c();
        jiraIssue.Created_Date_JIRA_Issue__c = date.today();
        jiraIssue.Issue_ID__c = '2222222';
        jiraIssue.Issue_Summary__c = 'Test Elias';
        jiraIssue.Issue_Type__c = '10100';
        insert jiraIssue;
        
        List<JIRA_CustomFieldValue_prod__c> jiraCustomList = new List<JIRA_CustomFieldValue_prod__c>();
        JIRA_CustomFieldValue_prod__c jiraCustom = new JIRA_CustomFieldValue_prod__c();
        jiraCustom.CustomField_ID__c = '14826';
        jiraCustom.Issue_ID__c = '2222222';
        jiraCustom.StringValue__c = 'Blur_Version_Test2';
        jiraCustom.Table_ID__c = '83646332';
        jiraCustomList.add(jiraCustom);
                   
        JIRA_CustomFieldValue_prod__c jiraCustom2 = new JIRA_CustomFieldValue_prod__c();
        jiraCustom2.CustomField_ID__c = '14827';
        jiraCustom2.Issue_ID__c = '2222222';
        jiraCustom2.StringValue__c = 'finger_print2';
        jiraCustom2.Table_ID__c = '83646442';
        jiraCustomList.add(jiraCustom2);
        
        JIRA_CustomFieldValue_prod__c jiraCustom3 = new JIRA_CustomFieldValue_prod__c();
        jiraCustom3.CustomField_ID__c = '16711';
        jiraCustom3.Issue_ID__c = '2222222';
        jiraCustom3.StringValue__c = DeviceID;
        jiraCustom3.Table_ID__c = '83646552';
        jiraCustomList.add(jiraCustom3);
        
        JIRA_CustomFieldValue_prod__c jiraCustom4 = new JIRA_CustomFieldValue_prod__c();
        jiraCustom4.CustomField_ID__c = '14834';
        jiraCustom4.Issue_ID__c = '2222222';
        jiraCustom4.StringValue__c = SVNName2;
        jiraCustom4.Table_ID__c = '83646662';
        jiraCustomList.add(jiraCustom4);              
        insert jiraCustomList;
        
        
		jiraCustomList = new List<JIRA_CustomFieldValue_prod__c>();
        jiraCustom = new JIRA_CustomFieldValue_prod__c();
        jiraCustom.CustomField_ID__c = '14826';
        jiraCustom.Issue_ID__c = '2222222';
        jiraCustom.StringValue__c = 'Blur_Version_Test';
        jiraCustom.Table_ID__c = '83646333';
        jiraCustomList.add(jiraCustom);
                   
        jiraCustom2 = new JIRA_CustomFieldValue_prod__c();
        jiraCustom2.CustomField_ID__c = '14827';
        jiraCustom2.Issue_ID__c = '2222222';
        jiraCustom2.StringValue__c = 'finger_print';
        jiraCustom2.Table_ID__c = '83646444';
        jiraCustomList.add(jiraCustom2);
        
        jiraCustom3 = new JIRA_CustomFieldValue_prod__c();
        jiraCustom3.CustomField_ID__c = '16711';
        jiraCustom3.Issue_ID__c = '2222222';
        jiraCustom3.StringValue__c = DeviceID;
        jiraCustom3.Table_ID__c = '83646555';
        jiraCustomList.add(jiraCustom3);
        
        jiraCustom4 = new JIRA_CustomFieldValue_prod__c();
        jiraCustom4.CustomField_ID__c = '14834';
        jiraCustom4.Issue_ID__c = '2222222';
        jiraCustom4.StringValue__c = SVNName;
        jiraCustom4.Table_ID__c = '83646666';
        jiraCustomList.add(jiraCustom4);              
        insert jiraCustomList;
        
        Jira_Device__c jiraDevice = new Jira_Device__c();
        jiraDevice.Blur_Version__c = 'Blur_Version';
        jiraDevice.Build_Fingerprint__c = 'Blur_fingerPrint';
        jiraDevice.Device_ID__c = DeviceID;
        jiraDevice.Device__c = dev.ID;
        jiraDevice.Issue_ID__c = '12398672';
        jiraDevice.SW_KIT_ID__c = SVNName;
        jiraDevice.SW_KIT__c = swKit.ID;        
        jiraDevice.Updated_From_SF__c = false;
        insert jiraDevice;
        
        jiraDevice = new Jira_Device__c();
        jiraDevice.Blur_Version__c = 'Blur_Version2';
        jiraDevice.Build_Fingerprint__c = 'Blur_fingerPrint2';
        jiraDevice.Device_ID__c = DeviceID;
        jiraDevice.Device__c = dev.ID;
        jiraDevice.Issue_ID__c = '1239867234';
        jiraDevice.SW_KIT_ID__c = SVNName2;
        jiraDevice.SW_KIT__c = swKit2.ID;        
        jiraDevice.Updated_From_SF__c = false;
        insert jiraDevice;
        
        

        Test.startTest();
		JiraImporter jiraImporter = new JiraImporter();
        jiraImporter.pushJiraDevices();
        Test.stopTest();   
        
        List<Jira_Device__c> updatedJiraDevices = [select ID from Jira_Device__c];
                
        System.assert(!updatedJiraDevices.isEmpty());
    }        
        
    @isTest
    public static void preprocessingTest(){   
        String DeviceID = '987654';
        String SVNName = 'SVN123ABC';
        
        Jira_Device__c jiraDevice = new Jira_Device__c();
        jiraDevice.Blur_Version__c = 'Blur_Version';
        jiraDevice.Build_Fingerprint__c = 'Blur_fingerPrint';
        jiraDevice.Device_ID__c = DeviceID;
        jiraDevice.Issue_ID__c = '12398672';
        jiraDevice.SW_KIT_ID__c = SVNName;
        insert jiraDevice;

        Test.startTest();
		JiraImporter jiraImporter = new JiraImporter();
        jiraImporter.preProcessing();
        Test.stopTest();   
        
        List<Jira_Device__c> updatedJiraDevices = [select ID from Jira_Device__c];
                
        System.assert(!updatedJiraDevices.isEmpty());
    }
    
    @isTest
    public static void getDeviceFromJiraDeviceTest(){
        String DeviceID = '987654';
        String SVNName = 'SVN123ABC';
        
    	Device__c dev = new Device__c(Device_ID__c=DeviceID,Name='JiraDEV');
        insert dev;
            
        System.debug(dev);
        
        Jira_Device__c jiraDevice = new Jira_Device__c();
        jiraDevice.Blur_Version__c = 'Blur_Version';
        jiraDevice.Build_Fingerprint__c = 'Blur_fingerPrint';
        jiraDevice.Device_ID__c = DeviceID;
        jiraDevice.Device__c = dev.ID;
        jiraDevice.Issue_ID__c = '12398672';
        jiraDevice.SW_KIT_ID__c = SVNName;
        insert jiraDevice;

        System.debug(jiraDevice);
        
        Test.startTest();
		JiraImporter jiraImporter      = new JiraImporter();
        List<Device__c> devicesFromSF = jiraImporter.getDevices(new List<Jira_Device__c>{jiraDevice});        
        Test.stopTest();     
        
        System.debug(devicesFromSF);
        
        System.assert(devicesFromSF.isEmpty() == false);
        System.assert(devicesFromSF.get(0).Device_ID__c.equals(DeviceID)); 
    }
    
    @isTest
    public static void getSWKitsFromJiraDeviceTest(){
        String SVNName = 'SVN123ABC';
        
        SW_Kit__c swKit = new SW_Kit__c();
        swKit.Name = SVNName;
        insert swKit;
        
        Jira_Device__c jiraDevice = new Jira_Device__c();
        jiraDevice.Blur_Version__c = 'Blur_Version';
        jiraDevice.Build_Fingerprint__c = 'Blur_fingerPrint';
        jiraDevice.Device_ID__c = '12345';
        jiraDevice.Issue_ID__c = '12398672';
        jiraDevice.SW_KIT_ID__c = SVNName;
        insert jiraDevice;
        
        Test.startTest();
		JiraImporter jiraImporter     = new JiraImporter();
        List <SW_Kit__c> swkitsFromSF = jiraImporter.getSWKits(new List<Jira_Device__c>{jiraDevice});
        Test.stopTest();     
        
        System.assert(!swkitsFromSF.isEmpty());
        System.assert(swkitsFromSF.get(0).Name.equals(SVNName));
    }
    
    @isTest
    public static void alidateSVNTest(){
		JiraImporter jiraImporter = new JiraImporter();
        
        Test.startTest();
		String validatedSVN = jiraImporter.validateSWkit('SVN123ABC');                       
        String invalidatedSVN = jiraImporter.validateSWkit('SVN123ABC, SVN123ABC');                       
        String nullSVN = jiraImporter.validateSWkit(null);  
        Test.stopTest();
        
        System.assert(validatedSVN != null);
        System.assert(invalidatedSVN == null);        
        System.assert(nullSVN == null);          
    }

    @isTest
    public static void validateSVNTest(){
		JiraImporter jiraImporter = new JiraImporter();
        
        Test.startTest();
		String validatedSVN = jiraImporter.validateSWkit('SVN123ABC');                       
        String invalidatedSVN = jiraImporter.validateSWkit('SVN123ABC, SVN123ABC');                       
        Test.stopTest();
        
        System.assert(validatedSVN != null);
        System.assert(invalidatedSVN == null);        
    }

    @isTest
    public static void JiraSchedulerTest(){
        
        // Execution
        Test.startTest();
        String cron = '0 5 * * 1-12 ? *';
		String jobId = System.schedule('JiraSchedulerTest', cron, new Jira_Device_Update());        
		CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        Test.stopTest();        
        
        // Assertions
        System.assertEquals(cron, ct.CronExpression);
    }
}