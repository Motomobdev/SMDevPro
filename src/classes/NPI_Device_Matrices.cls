public with sharing class NPI_Device_Matrices {

    public static String deviceid;
    public static String ProgramManager;
    public static List <AIF_Approval_Matrix__c> aifmatrix = New List<AIF_Approval_Matrix__c>();
    public static List <Application_Manager_Selection_Matrix__c> appmatrices = 
        New List<Application_Manager_Selection_Matrix__c>(); 

    public static void SetNPIMatrices(Device__c[] devices){
        Map<String, User> userMap = UserMethods.getNameUserMap();
        
        User deviceProgramManager;
        User softwareAndAppsLead;
        
        Map<Id, Device__c> deviceIdMap = new Map<Id, Device__c>(devices);
        
        List<AIF_Approval_Matrix__c> existingAIFApprovalMatrices = 
            [SELECT Id, Device_Name__c 
            FROM AIF_Approval_Matrix__c 
            WHERE Device_Name__c IN : deviceIdMap.keySet()];
        List <Application_Manager_Selection_Matrix__c> existingAppMgrSelectionMatrices = 
            [SELECT Id, Device__c 
            FROM Application_Manager_Selection_Matrix__c 
            WHERE Device__c IN : deviceIdMap.keySet()];
        
        Boolean hasMatrices = false;
        for(Device__c d:devices){   
            hasMatrices = false;  
            for(AIF_Approval_Matrix__c aif : existingAIFApprovalMatrices){  
                if(aif.Device_Name__c == d.Id){
                    hasMatrices = true;
                }
            }
            
            for(Application_Manager_Selection_Matrix__c appMgr : existingAppMgrSelectionMatrices){  
                if(appMgr.Device__c == d.Id){
                    hasMatrices = true;
                }
            }
            
            if(!hasMatrices){
                AIF_Approval_Matrix__c Newmatrix = 
                    new AIF_Approval_Matrix__c(name =d.Device_ID__c+'-Matrix',
                        Device_Name__c = d.id,
                        LRB_Approver__c = '005400000012sVaAAI', 
                        DTS_Approver__c = '005400000013pVjAAI');

                /***** Added by Jesse *****/
    
                if(d.SW_Apps_Lead__c != null && d.SW_Apps_Lead__c != ''){
                    softwareAndAppsLead = userMap.get(d.SW_Apps_Lead__c);
                }
    
                // Set deviceProgram Manger
                if(d.Program_Manager_Name__c != null && d.Program_Manager_Name__c != ''){
                    deviceProgramManager = userMap.get(d.Program_Manager_Name__c);
                }           
                
                if(deviceProgramManager == null){
                    // Dan Quicker
                    deviceProgramManager = userMap.get('Dan Quicker');
                }                       
                
                /*if(d.ODM_Device__c == true){ // replaced by product segment 
                    // set confirmation of budget approver to Jatin Patel
                    // Rajesh: Replaced Jatin Patel with Dan Quicker
                    Newmatrix.Finance_Approver__c = userMap.get('Dan Quicker').Id;
                }*/
                if(d.Product_Segment__c == 'MMCP'){
                    if(softwareAndAppsLead != null){ Newmatrix.Finance_Approver__c = softwareAndAppsLead.Id; }
                    else { Newmatrix.Finance_Approver__c = userMap.get('Dan Quicker').Id; }
                }
                else if(d.Technology__c == 'iDEN'){ // Replaced Dell Barton with Claudia Masihy -- Rajesh 12/30/2013
                    Newmatrix.Finance_Approver__c = userMap.get('Claudia Masihy').Id;
                }
                else if(d.Business_Unit__c == 'Companion Products'){
                    Newmatrix.Finance_Approver__c = userMap.get('Dan Quicker').Id;
                }
                else if(d.ODM_Device__c != true && d.Business_Unit__c != 'Companion Products' && d.Country__c == 'China'){
                    Newmatrix.Finance_Approver__c = userMap.get('Dan Quicker').Id;
                }
                else{
                    if(softwareAndAppsLead != null){
                        NewMatrix.Finance_Approver__c = softwareAndAppsLead.id;
                    }
                    else{ 
                        NewMatrix.Finance_Approver__c = userMap.get('Dan Quicker').id;
                    }                   
                }
                
                system.debug('SET Finance Approver to : ' + Newmatrix.Finance_Approver__c);
                
                /***** END Added by Jesse *****/
          
                aifmatrix.add(NewMatrix); 
        
                // These three lines have been changed to use device_Id__c as part of name because using actual name was reulting in string > 80 characters
                Application_Manager_Selection_Matrix__c sam1 = new Application_Manager_Selection_Matrix__c(name=d.Device_ID__c+'-Emb',device__c = d.id, Application_Type__c = 'Embedded', Application_Manager__c = deviceProgramManager.id);
                Application_Manager_Selection_Matrix__c sam2 = new Application_Manager_Selection_Matrix__c(name=d.Device_ID__c+'-Pre',device__c = d.id, Application_Type__c = 'Preload', Application_Manager__c = '005400000012toYAAQ');//Danny Rose - 005400000012toYAAQ
                Application_Manager_Selection_Matrix__c sam3 = new Application_Manager_Selection_Matrix__c(name=d.Device_ID__c+'-Other',device__c = d.id, Application_Type__c = 'Other', Application_Manager__c = deviceProgramManager.id);
        
                appmatrices.add(sam1);
                appmatrices.add(sam2);
                appmatrices.add(sam3);
            }
        }
        
        insert appmatrices;
        insert aifmatrix;
        
        aifmatrix = New List<AIF_Approval_Matrix__c>();
        appmatrices = New List<Application_Manager_Selection_Matrix__c>();    
    }
    
    
    private testmethod static void TestMethod1() {
        User p = [SELECT ID, Username From User Where username LIKE 'datafeed@motorola.com%' LIMIT 1];
        Test.startTest();
        /*System.runAs(p) {
           Device__c d = new Device__c();
           List<Device__c> ds = new List<Device__c>();
            ds.add(d);
            for(Device__c da:ds){
               da.odm_device__c = TRUE;
            }
            setNPIMatrices(ds);
        }*/

        /***** Added by Jesse *****/
        System.runAs(p) {
            Device__c d2 = new Device__c(name='testfortrigger', Device_Project_Program_Lead__c='Automated Data Feed', technology__c='iDEN', Business_Unit__c = 'Companion Products');
            insert d2;
            /*List<Device__c> ds2 = new List<Device__c>();
            ds2.add(d2);
            setNPIMatrices(ds2);
            */
            /*List<AIF_Approval_Matrix__c> existingAIFApprovalMatrices = [SELECT Id, Device_Name__c FROM AIF_Approval_Matrix__c WHERE Device_Name__c =: d2.Id];
            List <Application_Manager_Selection_Matrix__c> existingAppMgrSelectionMatrices = [SELECT Id, Device__c FROM Application_Manager_Selection_Matrix__c WHERE Device__c =: d2.Id];
            delete existingAIFApprovalMatrices;
            delete existingAppMgrSelectionMatrices;
            */d2.SW_Apps_Lead__c = 'Automated Data Feed';
            
            update d2;
            //setNPIMatrices(new List<Device__c>(d2));
            
        }
        /***** End Added by Jesse *****/
        Test.stopTest();
    }
}