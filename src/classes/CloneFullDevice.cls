public without sharing class CloneFullDevice {
     private static boolean isTestMode = false;
    private Device__c clonedPO;
    private Device__c originalPO;
    
    private List<DeviceApplicationAssoc__c> originalCOs = new List<DeviceApplicationAssoc__c>();
    private List<DeviceApplicationAssoc__c> clonedCOs = new List<DeviceApplicationAssoc__c>();
    
    public CloneFullDevice(ApexPages.StandardController controller) {
    }
    public PageReference DoClone() {
        String SOQLPO; //text to hold dynamic soql for Parent Object 
        String SOQLCO; //text to hold dynamic soql for related Child Object
        String originalID;

        originalID = ApexPages.CurrentPage().getParameters().get('ID');
        
                
      
        SOQLPO = 'SELECT ' + getAllFieldsForSelect(Schema.SObjectType.Device__c) + ' FROM Device__c WHERE Id = \'' + originalID + '\'';               
        System.debug('***SFDC: SOQL for Device: ' + SOQLPO);              
        originalPO = Database.query(SOQLPO);
        clonedPO = originalPO.Clone(false, true);
        clonedPO.name = OriginalPO.name+'-CLONED';
        ClonedPO.Device_Fully_Approved__c = 'No';
        ClonedPO.Device_ID__c = NULL;
        ClonedPO.TA_Date__c = NULL;
        ClonedPO.SA_Date__c = NULL;
        ClonedPO.SA_Status__c = NULL;
        ClonedPO.EOL__c = NULL;
        ClonedPO.Target_STRR_Date__c = NULL;
        ClonedPO.SA_Release_Type__c = '';
        ClonedPO.Target_FTRR_Date__c = NULL;
        ClonedPO.Shipped_Date__c = NULL;
        ClonedPO.Cancelled__c = FALSE;
        ClonedPO.Shipped_and_Completed__c = FALSE;
        ClonedPO.Product_Security_Classification__c = '';
        ClonedPO.Product__c = '';
        ClonedPO.Cancelled_product__c = FALSE;
        ClonedPO.Google_TA_Approval_Status__c = 'Not Started';
        ClonedPO.Date_of_Google_TA_Approval_by_Google__c = NULL;
        ClonedPO.Program_Manager_Name__c = '';
        ClonedPO.SW_Apps_Lead__c = '';
        ClonedPO.SW_Eng_Lead__c = '';
        ClonedPO.GMS_Technical_Lead_Name__c = '';
        ClonedPO.CTS_Technical_Lead_Name__c = '';
        ClonedPO.Google_Relationship_Manager_Name__c = '';
        ClonedPO.MOT_GTAM__c = '';
        ClonedPO.Business_Operations_Analyst__c = '';
        ClonedPO.Program_Manager_Email__c = '';
        ClonedPO.Software_and_Applications_Lead_Email__c = '';
        ClonedPO.Software_Engineering_Lead_Email__c = '';
        ClonedPO.GMS_Technical_Lead_Email__c = '';
        ClonedPO.CTS_Technical_Lead_Email__c = '';
        ClonedPO.Google_Relationship_Manager_Email__c = '';
        ClonedPO.MOT_GTAM_Email__c = '';
        ClonedPO.Business_Operations_Analyst_Email__c = '';
        ClonedPO.Launch_Addendum_ID__c = '';
        ClonedPO.Launch_Addendum_Template__c = '';
        ClonedPO.Launch_Addendum__c = '';
        ClonedPO.Launch_Addendum_Executed_by_MOT__c = '';
        ClonedPO.Launch_Addendum_Executed_by_Google__c = '';
        ClonedPO.Launch_Addendum_Comments__c = '';
        ClonedPO.Launch_Addendum_Status__c = 'Not Started';
        ClonedPO.Date_Launch_Addendum_Template_Provided__c = NULL;
        ClonedPO.Date_Launch_Addendum_Submitted_to_Google__c = NULL;
        ClonedPO.Date_Launch_Addendum_Executed_by_MOT__c = NULL;
        ClonedPO.Date_Launch_Addendum_Executed_by_Google__c = NULL;
        ClonedPO.GMS_Software_Checklist__c = '';
        ClonedPO.GMS_Last_SW_Submitted__c = '';
        ClonedPO.GMS_Comments__c = '';
        ClonedPO.GMS_Submission_Status__c = 'Not Started';
        ClonedPO.Date_GMS_SW_Checklist_Provided__c = NULL;
        ClonedPO.Date_GMS_SW_Checklist_Sent_to_Google__c = NULL;
        ClonedPO.Date_GMS_Conditional_Approval_by_Google__c = NULL;
        ClonedPO.CTS_Software_Checklist__c = '';
        ClonedPO.CTS_Last_SW_Submitted__c = '';
        ClonedPO.CTS_Comments__c = '';
        ClonedPO.CTS_Submission_Status__c = 'Not Started';
        ClonedPO.Date_CTS_SW_Checklist_Provided__c = NULL;
        ClonedPO.Date_CTS_SW_Checklist_Sent_to_Google__c = NULL;
        ClonedPO.Approval_Document_from_Google__c = '';
        ClonedPO.White_Listed_Build_Fingerprint__c = '';
        ClonedPO.Google_TA_Comments__c = '';
        ClonedPO.Google_TA_Approval_Status__c = 'Not Started';
        ClonedPO.Date_of_Google_TA_Approval_by_Google__c= NULL;
        ClonedPO.Shipped_and_Completed__c = FALSE;
        insert clonedPO; 

  //List<AIF_Approval_Matrix__c> aams2 = [SELECT device_name__c, lrb_approver__c, dts_approver__c, FMD_Status_Check_Approver__c, Confirmation_of_Budget_Royalties__c,Finance_Approver__c, application_Requester__c from AIF_Approval_Matrix__c where device_name__c =: OriginalPo.id];
  List<AIF_Approval_Matrix__c> aams2 = [SELECT device_name__c, lrb_approver__c, dts_approver__c, FMD_Status_Check_Approver__c, Confirmation_of_Budget_Approver__c,Finance_Approver__c, application_Requester__c from AIF_Approval_Matrix__c where device_name__c =: OriginalPo.id];
    
      AIF_Approval_Matrix__c aam = new AIF_Approval_Matrix__c(name = OriginalPO.name+'-CLONED',Device_Name__c = ClonedPO.ID);
      List<AIF_Approval_Matrix__c> aams = new List<AIF_Approval_matrix__c>();
      
            
    aams.add(aam);
     
      
        for(AIF_Approval_matrix__c am:aams2){
      //if(am.device_name__c== aam.device_name__c){ // EDITED BY JESSE, IF STATEMENT WILL NEVER BE TRUE BECAUSE THERE CANNOT BE TWO IDENTICAL ID's
                
                am.lrb_approver__c = aam.lrb_approver__c;
                am.dts_approver__c = aam.dts_approver__c;
                am.FMD_Status_Check_Approver__c = aam.FMD_Status_Check_Approver__c;
                //am.Confirmation_of_Budget_Royalties__c = aam.Confirmation_of_Budget_Royalties__c;
                am.Confirmation_of_Budget_Approver__c = aam.Confirmation_of_Budget_Approver__c;
                am.Finance_Approver__c = aam.Finance_Approver__c;
                am.Application_Requester__c = aam.Application_Requester__c;    
      //}
       insert aam;
        }
        
        
     List<Application_Manager_Selection_Matrix__c> sams2 = [SELECT device__c, application_type__c, app_type__c, application_manager__c from Application_Manager_Selection_Matrix__c where device__c =: OriginalPo.id];
 Application_Manager_Selection_Matrix__c sam1 = new Application_Manager_Selection_Matrix__c(name = OriginalPO.name+'-CLONED',device__c = ClonedPO.id, Application_Type__c = 'Embedded');
 Application_Manager_Selection_Matrix__c sam2 = new Application_Manager_Selection_Matrix__c(name = OriginalPO.name+'-CLONED',device__c = ClonedPO.id, Application_Type__c = 'Preload');
 Application_Manager_Selection_Matrix__c sam3 = new Application_Manager_Selection_Matrix__c(name = OriginalPO.name+'-CLONED',device__c = ClonedPO.id, Application_Type__c = 'Other');
     List<Application_Manager_Selection_Matrix__c> sams = new List<Application_Manager_Selection_Matrix__c>();
      
            sams.add(sam3);
            sams.add(sam2);
            sams.add(sam1);
    for(Application_Manager_Selection_Matrix__c sm:sams2){
    if(sm.app_type__c == 'Embedded'){
                sm.application_manager__c = sam1.application_manager__c;
   }ELSE{
    if(sm.app_type__c == 'Preload'){
    }ELSE{
                sm.application_manager__c = sam2.application_manager__c;
    if(sm.app_type__c == 'Other'){
                sm.application_manager__c = sam3.application_manager__c;
}
  
      insert sams;
      }
      }
      }
      
      
      
        
        
        
        
        

        
        
    SOQLCO = 'SELECT ' + getAllFieldsForSelect(Schema.SObjectType.DeviceApplicationAssoc__c) + ' FROM DeviceApplicationAssoc__c WHERE Device__c = \'' + originalID + '\'';        
        System.debug('***SFDC: SOQL for Child Object L1: ' + SOQLCO);
        originalCOs = Database.query(SOQLCO);
        
        
        for(DeviceApplicationAssoc__c CO:originalCOs){
            DeviceApplicationAssoc__c clonedCO;
            clonedCO = CO.Clone(false,true);
            //clonedCO.dts_support__c = 'Not Supported';
            clonedCO.dts_support__c = 'No Support Required';
            clonedCO.Device__c = clonedPO.ID; //change the related field to point to the new cloned object instead of the old original object  
            clonedCO.Approval_Status__c = 'Not Submitted';
            clonedCO.LRB_Approval__c = 'In Progress';
            clonedCO.DTS_Approval__c = 'In Progress';
            clonedCO.Application_Mgr_Selection_Approval__c = 'In Progress';
            clonedCO.Confirmation_of_Budget_Royalties__c = 'In Progress';
            clonedCO.FMD_Status_Approval__c = 'In Progress';
            clonedCO.Partner_Manager_Checklist_Approval__c = 'In Progress';
            clonedCO.Requester_Approval__c = 'In Progress'; 
            clonedCOs.add(clonedCO);  
        }
        
   
      
     
        insert clonedCOs; // insert related children

      
        return new PageReference('/' + clonedPO.ID);
    }
    
    private String getAllFieldsForSelect(Schema.DescribeSObjectResult descObject) {
        return getAllFieldsForSelect(descObject, new Set<String>());
    }
    
    private String getAllFieldsForSelect(Schema.DescribeSObjectResult descObject, Set<String> exceptFields) {
                
        String fieldName;
        String strFields = '';

        Map<String, Schema.SObjectField> mapFields = descObject.fields.getMap();
        For (Schema.SObjectField field : mapFields.Values()) {
            fieldName = field.getDescribe().Name;
            if (!exceptFields.contains(fieldName)) {
                if (strFields != '') {
                    strFields += ', ';
                }
                strFields += fieldName;
            }
        }
        return strFields;
    }

//TESING METHODS
//a06S0000001K3eq Test Device-AH
//a06S0000001Kos1 Test Device-AH-Clone
//a0AS0000001c4r5 DevApp
//a0AS0000001c4rT DevApp
//a0AS0000001c4rO DevApp
    private static testmethod void testExtension() {
istestmode = true;
        PageReference testPage;

 

        // SFDC 1: Prepare records
      //User u = [SELECT ID FROM User WHERE email = 'beth.vollbeer@motorola.com' LIMIT 1];  
      //Device__c DeviceTest = [SELECT device_id__c FROM Device__c where device_id__c = '123456789' LIMIT 1];
	User datafeed = [SELECT ID From User Where name = 'Automated Data Feed'];
    Device__c DeviceTest = new Device__c(name='DeviceTest');
    System.runAs(datafeed){
		insert deviceTest;
    }
   //Set-up Approval Matrix
  
        System.debug('SFDC: CaseTest: ' + DeviceTest);

       

        // SFDC 2: Instantiate a controller

        Apexpages.StandardController CloneFullDeviceController = new Apexpages.standardController(DeviceTest);

       

        // SFDC 3: Set page
        
        testPage = Page.FullDeviceClone;

        testPage.getParameters().put('id', DeviceTest.id);

        test.setCurrentPage(testPage);

 

        // SFDC 4: Instantiate an extension

        CloneFullDevice ext = new CloneFullDevice(CloneFullDeviceController);

     

        // SFDC 5: Use extension to assert all your methods, properties, getters and setters.

        ext.DoClone();

     //  System.assertEquals(ext.clonedpo.Is_Cloned__c, true);

     //   System.assertEquals(ext.clonedpo.Cloned_From__c, DeviceTest.id);
       //   System.assertNotEquals(ext.clonedpo, null);
        System.assertEquals(ext.clonedpo.Device_Fully_Approved__c, 'No');
        System.assertEquals(ext.clonedpo.Device_ID__c, NULL);
        System.assertEquals(ext.clonedpo.TA_Date__c, NULL);
        System.assertEquals(ext.clonedpo.SA_Date__c, NULL);
        System.assertEquals(ext.clonedpo.SA_Status__c, NULL);
        System.assertEquals(ext.clonedpo.EOL__c, NULL);
        System.assertEquals(ext.clonedpo.Target_STRR_Date__c, NULL);
        System.assertEquals(ext.clonedpo.Target_FTRR_Date__c, NULL);
        System.assertEquals(ext.clonedpo.Shipped_Date__c, NULL);
        System.assertEquals(ext.clonedpo.Cancelled__c, FALSE);
        System.assertEquals(ext.clonedpo.Shipped_and_completed__c, FALSE);
        System.assertEquals(ext.clonedpo.Product_Security_Classification__c, NULL);
        System.assertEquals(ext.clonedpo.Product__c, NULL);
        System.assertEquals(ext.clonedpo.SA_Release_Type__c, NULL);
        System.assertEquals(ext.ClonedPO.Cancelled_product__c,FALSE);
        System.assertEquals(ext.ClonedPO.Google_TA_Approval_Status__c, 'Not Started'); 
        System.assertEquals(ext.ClonedPO.Date_of_Google_TA_Approval_by_Google__c, NULL);
        System.assertEquals(ext.ClonedPO.Program_Manager_Name__c, NULL);
        System.assertEquals(ext.ClonedPO.SW_Apps_Lead__c, NULL);
        System.assertEquals(ext.ClonedPO.SW_Eng_Lead__c, NULL);
        System.assertEquals(ext.ClonedPO.GMS_Technical_Lead_Name__c, NULL);
        System.assertEquals(ext.ClonedPO.CTS_Technical_Lead_Name__c, NULL);
        System.assertEquals(ext.ClonedPO.Google_Relationship_Manager_Name__c, NULL);
        System.assertEquals(ext.ClonedPO.MOT_GTAM__c, NULL);
        System.assertEquals(ext.ClonedPO.Business_Operations_Analyst__c, NULL);
        System.assertEquals(ext.ClonedPO.Program_Manager_Email__c, NULL);
        System.assertEquals(ext.ClonedPO.Software_and_Applications_Lead_Email__c, NULL);
        System.assertEquals(ext.ClonedPO.Software_Engineering_Lead_Email__c, NULL);
        System.assertEquals(ext.ClonedPO.GMS_Technical_Lead_Email__c, NULL);
        System.assertEquals(ext.ClonedPO.CTS_Technical_Lead_Email__c, NULL);
        System.assertEquals(ext.ClonedPO.Google_Relationship_Manager_Email__c, NULL);
        System.assertEquals(ext.ClonedPO.MOT_GTAM_Email__c, NULL);
        System.assertEquals(ext.ClonedPO.Business_Operations_Analyst_Email__c, NULL);
        System.assertEquals(ext.ClonedPO.Launch_Addendum_ID__c, NULL);
        System.assertEquals(ext.ClonedPO.Launch_Addendum_Template__c, NULL);
        System.assertEquals(ext.ClonedPO.Launch_Addendum__c, NULL);
        System.assertEquals(ext.ClonedPO.Launch_Addendum_Executed_by_MOT__c, NULL);
        System.assertEquals(ext.ClonedPO.Launch_Addendum_Executed_by_Google__c, NULL);
        System.assertEquals(ext.ClonedPO.Launch_Addendum_Comments__c, NULL);
        System.assertEquals(ext.ClonedPO.Launch_Addendum_Status__c, 'Not Started');
        System.assertEquals(ext.ClonedPO.Date_Launch_Addendum_Template_Provided__c, NULL);
        System.assertEquals(ext.ClonedPO.Date_Launch_Addendum_Submitted_to_Google__c, NULL);
        System.assertEquals(ext.ClonedPO.Date_Launch_Addendum_Executed_by_MOT__c, NULL);
        System.assertEquals(ext.ClonedPO.Date_Launch_Addendum_Executed_by_Google__c, NULL);
        System.assertEquals(ext.ClonedPO.GMS_Software_Checklist__c, NULL);
        System.assertEquals(ext.ClonedPO.GMS_Last_SW_Submitted__c, NULL);
        System.assertEquals(ext.ClonedPO.GMS_Comments__c, NULL);
        System.assertEquals(ext.ClonedPO.GMS_Submission_Status__c, 'Not Started');
        System.assertEquals(ext.ClonedPO.Date_GMS_SW_Checklist_Provided__c, NULL);
        System.assertEquals(ext.ClonedPO.Date_GMS_SW_Checklist_Sent_to_Google__c, NULL);
        System.assertEquals(ext.ClonedPO.Date_GMS_Conditional_Approval_by_Google__c, NULL);
        System.assertEquals(ext.ClonedPO.CTS_Software_Checklist__c, NULL);
        System.assertEquals(ext.ClonedPO.CTS_Last_SW_Submitted__c, NULL);
        System.assertEquals(ext.ClonedPO.CTS_Comments__c, NULL);
        System.assertEquals(ext.ClonedPO.CTS_Submission_Status__c, 'Not Started');
        System.assertEquals(ext.ClonedPO.Date_CTS_SW_Checklist_Provided__c, NULL);
        System.assertEquals(ext.ClonedPO.Date_CTS_SW_Checklist_Sent_to_Google__c, NULL);
        System.assertEquals(ext.ClonedPO.Approval_Document_from_Google__c, NULL);
        System.assertEquals(ext.ClonedPO.White_Listed_Build_Fingerprint__c, NULL);
        System.assertEquals(ext.ClonedPO.Google_TA_Comments__c, NULL);
        System.assertEquals(ext.ClonedPO.Google_TA_Approval_Status__c, 'Not Started');
        System.assertEquals(ext.ClonedPO.Date_of_Google_TA_Approval_by_Google__c, NULL);
        System.assertEquals(ext.ClonedPO.Shipped_and_Completed__c, FALSE);
    }

}