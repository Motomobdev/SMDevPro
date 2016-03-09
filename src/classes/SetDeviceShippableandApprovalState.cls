public with sharing class SetDeviceShippableandApprovalState {
  /*  public static Boolean SW_KIT_REF_12 = False;
    public static Boolean SW_KIT_REF_32 = False;
    public static Boolean SW_KIT_REF_35 = False;

    Public static void SetDeviceShippableandApprovalState(List<DeviceApplicationAssoc__c> DevApps){    
        Map<ID,List<String>> Devappstatemap = New Map<ID,List<String>>();
        List<String> devappstatelist = New List<String>();

        for(DeviceApplicationAssoc__c da: devapps){
            if(da.App_Item_State__c != null){
	            if(DevappStateList == NULL){
	                DevappStateList = new List<String>{da.App_Item_State__c};
	            }else{  
	                DevappStateList.add(da.App_Item_State__c);
	            }
	            devappstatemap.put(da.Device__c, DevAppStateList);
            }         
        }
        
        Map<ID,Device__c> DevicesMap = New Map<ID, Device__c>([SELECT Device_SW_KIT_State__c,SW_KIT__c,SWBOM_Reviewed_and_Approved__c,SW_BOM_List_Approver__c,Number_of_Sales_Models__c FROM Device__c Where ID IN: devappstatemap.keyset()]);
        System.debug(DevicesMap + '***************Devices List Debug*****************');

        List<String> stringlist = New List<String>();
            
		for(Id DevappStateMapDevId : devappStateMap.keyset()){
			SW_KIT_REF_12 = False;
			SW_KIT_REF_32 = False;
			SW_KIT_REF_35 = False;
			
        	StringList = devappstateMap.get(DevAppStateMapDevId);
            System.debug(Stringlist + 'List of Strings');      

            for(String s: stringlist){
             	system.debug('THIS IS String: ' + s);
				if(s.contains('12')){
					SW_KIT_REF_12 = TRUE;
				}
				if(s.contains('32')){
				    SW_KIT_REF_32 = TRUE;
				}
				if(s.contains('35')){
				    SW_KIT_REF_35 = TRUE;
				}           
          	}
              
              
			if(devicesmap.ContainsKey(DevappStateMapDevId)){                 
				if((devicesmap.get(DevappStateMapDevId).SW_KIT__c == NULL) || (devicesmap.get(DevAppStateMapDevId).SWBOM_Reviewed_And_Approved__c == 'No') || (devicesmap.get(DevAppStateMapDevId).SW_BOM_List_Approver__c == NULL)){
                	devicesmap.put(DevappStateMapDevId, New Device__c(id=DevappStateMapDevId, Device_SW_KIT_State__c = '12 - Prelim', Device_Fully_Approved__c='No'));                    
                }else{
	                
					if((SW_KIT_REF_12 == TRUE) && (SW_KIT_REF_32 == FALSE) && (SW_KIT_REF_35 == FALSE)){
	                	devicesmap.put(DevappStateMapDevId, New Device__c(id=DevappStateMapDevId, Device_SW_KIT_State__c = '12 - Prelim', Device_Fully_Approved__c='No'));
	                }
	                if((SW_KIT_REF_12 == TRUE) && (SW_KIT_REF_32 == TRUE) && (SW_KIT_REF_35 == FALSE)){     
	                    devicesmap.put(DevappStateMapDevId, New Device__c(id=DevappStateMapDevId, Device_SW_KIT_State__c = '12 - Prelim', Device_Fully_Approved__c='No'));
	                }
	                if((SW_KIT_REF_12 == TRUE) && (SW_KIT_REF_32 == TRUE) && (SW_KIT_REF_35 == TRUE)){ 
	                    devicesmap.put(DevappStateMapDevId, New Device__c(id=DevappStateMapDevId, Device_SW_KIT_State__c = '12 - Prelim', Device_Fully_Approved__c='No'));            
	                }
	                if((SW_KIT_REF_12 == FALSE) && (SW_KIT_REF_32 == TRUE) && (SW_KIT_REF_35 == FALSE)){           
	                    if(Devicesmap.get(DevappStateMapDevId).Number_of_Sales_Models__c != 0){                        
	                        devicesmap.put(DevappStateMapDevId, New Device__c(id=DevappStateMapDevId, Device_SW_KIT_State__c = '32 - Controlled', Device_Fully_Approved__c='Yes'));   
	                    }else{
	                    	devicesmap.put(DevappStateMapDevId, New Device__c(id=DevappStateMapDevId, Device_SW_KIT_State__c = '32 - Controlled', Device_Fully_Approved__c='No'));   
	                    }
	                }
	                if((SW_KIT_REF_12 == FALSE) && (SW_KIT_REF_32 == TRUE) && (SW_KIT_REF_35 == TRUE)){ 
	                    if(Devicesmap.get(DevappStateMapDevId).Number_of_Sales_Models__c != 0){                        
	                        devicesmap.put(DevappStateMapDevId, New Device__c(id=DevappStateMapDevId, Device_SW_KIT_State__c = '32 - Controlled', Device_Fully_Approved__c='Yes'));   
	                    }else{
	                          devicesmap.put(DevappStateMapDevId, New Device__c(id=DevappStateMapDevId, Device_SW_KIT_State__c = '32 - Controlled', Device_Fully_Approved__c='No'));   
	                    }
	                }
	                if((SW_KIT_REF_12 == FALSE) && (SW_KIT_REF_32 == FALSE) && (SW_KIT_REF_35 == TRUE)) {                                  
	                    if(Devicesmap.get(DevappStateMapDevId).Number_of_Sales_Models__c != 0){                        
	                        devicesmap.put(DevappStateMapDevId, New Device__c(id=DevappStateMapDevId, Device_SW_KIT_State__c = '35 - Full Release', Device_Fully_Approved__c='Yes'));   
	                    }else{
	                        devicesmap.put(DevappStateMapDevId, New Device__c(id=DevappStateMapDevId, Device_SW_KIT_State__c = '35 - Full Release', Device_Fully_Approved__c='No'));   
	                    }
	                }
	                if((SW_KIT_REF_12 == True) && (SW_KIT_REF_32 == FALSE) && (SW_KIT_REF_35 == TRUE)){
	                        devicesmap.put(DevappStateMapDevId, New Device__c(id=DevappStateMapDevId, Device_SW_KIT_State__c = '12 - Prelim', Device_Fully_Approved__c='No'));
	                }
	                if((SW_KIT_REF_12 == False) && (SW_KIT_REF_32 == FALSE) && (SW_KIT_REF_35 == FALSE)){
	                        devicesmap.put(DevappStateMapDevId, New Device__c(id=DevappStateMapDevId, Device_SW_KIT_State__c = '12 - Prelim', Device_Fully_Approved__c='No'));    
	                }   
                }
            }

        }
            
        update DevicesMap.Values();
           
    }     







//Test Methods
    
      static testmethod void DeviceApplicationShippableTest(){
        Contact u = [SELECT ID FROM Contact where Name=:'Austin Heinrichs']; 
        User u2 = [SELECT ID FROM User where name=:'Austin Heinrichs'];
        Account acc = New Account(name='Test Account', Tier__c='4');
            insert acc;
            date myDate = date.newInstance(2012, 1, 1);
            date myDate2 = date.newInstance(2014,1,1);  
        
        Contract c = New Contract(StartDate=myDate,EndDate=myDate2,name='Testing Contract', AccountId=acc.id,Contract_Type__c='SLDA - Software Licensing Distribution Agreement',Contract_Status__c='Fully Executed',Contract_Phase__c='6 - Fully Executed Contract Phase',Moto_Signed__c=TRUE,  Partner_Signed__c=TRUE, Motorola_Entity__c='Motorola Inc',SW_Procurement_Owner__c=u.id,Legal_Owner__c=u.id,Finance_Owner__c=u.id,ContractTerm=20);
            insert c;
        
        SW_KIT__c swkit = New SW_KIT__c(SW_Kit_Item_State__c='35 - Full Release');
        
        Sales_Model__c salesmodel = New Sales_Model__c(Name='Test Model');
            insert swkit;
            insert salesmodel;
            date sa = date.newInstance(2013,1,1);
        
        Device__c d = New Device__c(Name='Test Device',Device_ID__c='1234', SW_KIT__c=swkit.id, Google_TA_Approval_Status__c='Not Applicable', SA_Date__c=sa,Percent_BOM_SD_Apps_w_Executed_Contract__c=100.00,SW_BOM_List_Approver__c = u2.id);
            insert d;
        
        Application__c a = New Application__c(Account__c=acc.id,Name='Test App',  Application_Type__c='Preload',ECCN_subECCN_Value__c='5D002.c.1',ENC_License_Category__c='ENC-Unrestricted: 740.17.b.4',Royalty_Current__c=0.0);        
        Application__c a2 = New Application__c(Account__c=acc.id,Name='Test App',  Application_Type__c='Preload',ECCN_subECCN_Value__c='5D002.c.1',ENC_License_Category__c='ENC-Unrestricted: 740.17.b.4');
            insert new List<Application__c>{a, a2};     
        
        ContApplAssoc__c conapp = New ContApplAssoc__c(Application__c=a.id,Contract__c=c.id,Governing_End_Date__c=TRUE);        
        ContApplAssoc__c conapp2 = New ContApplAssoc__c(Application__c=a2.id,Contract__c=c.id,Governing_End_Date__c=TRUE);
            insert new List<ContApplAssoc__c>{conapp, conapp2};      
        
        AIF_Approval_Matrix__c aam = New AIF_Approval_Matrix__c(Application_Requester__c=u2.id,Confirmation_of_Budget_Approver__c=u2.id,Device_Name__c=d.id,    DTS_Approver__c=u2.id,Finance_Approver__c=u2.id,FMD_Status_Check_Approver__c=u2.id,LRB_Approver__c=u2.id);
        insert aam;
        
        Application_Manager_Selection_Matrix__c amsm = New Application_Manager_Selection_Matrix__c(Application_Manager__c=u2.id,Application_Type__c='Other',    Device__c=d.id);
        Application_Manager_Selection_Matrix__c amsm2 = New Application_Manager_Selection_Matrix__c(Application_Manager__c=u2.id,Application_Type__c='Preload', Device__c=d.id);
        Application_Manager_Selection_Matrix__c amsm3 = New Application_Manager_Selection_Matrix__c(Application_Manager__c=u2.id,Application_Type__c='Embedded',    Device__c=d.id);
        insert new List<Application_Manager_Selection_Matrix__c>{amsm, amsm2, amsm3};        
        
        SalesModel_Device__c salesmodeldevice = New  SalesModel_Device__c(Sales_Model__c=salesmodel.id,Device__c=d.id);
            insert salesmodeldevice;
            update a;
        
                
        DeviceApplicationAssoc__c da35 = New DeviceApplicationAssoc__c(Device__c=d.id,Application__c=a.id, Include_in_BOM__c=TRUE, X3rd_Party_Approval_Status__c= 'N/A'); 
        DeviceApplicationAssoc__c da32 = New DeviceApplicationAssoc__c(Device__c=d.id,Application__c=a2.id, Include_in_BOM__c=TRUE,X3rd_Party_Approval_Status__c= 'N/A');     
        DeviceApplicationAssoc__c da12 = New DeviceApplicationAssoc__c(Device__c=d.id,Application__c=a2.id, Include_in_BOM__c=TRUE); 
        
        insert da35;
        da35.Approval_Status__c = 'Approved';
        update da35;
        
        DeviceApplicationAssoc__c devapp = [SELECT ID, App_Item_State__c FROM DeviceApplicationAssoc__c WHERE ID =: DA35.ID];
        system.debug('THIS IS devapp.App_Item_State__c: ' + devapp.App_Item_State__c);
        System.assertEquals('35 - Full Release', devapp.App_Item_State__c);
        
        d.SWBOM_Reviewed_and_Approved__c = 'Yes';
        update d;
        
        Device__c dev = [SELECT ID, Device_SW_KIT_State__c, Device_Fully_Approved__c from Device__c where id =:d.id];
            system.debug('THIS IS dev.Device_SW_KIT_State__c: ' + dev.Device_SW_KIT_State__c);
            //System.assertequals('35 - Full Release', dev.Device_SW_KIT_State__c);
            //System.assertequals('Yes',dev.Device_Fully_Approved__c);
            
        
		d.SWBOM_Reviewed_and_Approved__c = 'No';
		d.SW_BOM_List_Approver__c = NULL;
		update d;
		
        Device__c dev2 = [SELECT ID, Device_SW_KIT_State__c, Device_Fully_Approved__c from Device__c where id =:d.id];
            //System.assertequals('12 - Prelim', dev2.Device_SW_KIT_State__c);
            //System.assertequals('No',dev2.Device_Fully_Approved__c);
    }   

   
    
 static testmethod void DeviceApplicationShippableTest3(){
        Contact u = [SELECT ID FROM Contact where Name=:'Austin Heinrichs']; 
        User u2 = [SELECT ID FROM User where name=:'Austin Heinrichs'];
        Account acc = New Account(name='Test Account', Tier__c='4');
            insert acc;
            date myDate = date.newInstance(2012, 1, 1);
            date myDate2 = date.newInstance(2014,1,1);  
        
        Contract c = New Contract(StartDate=myDate,EndDate=myDate2,name='Testing Contract', AccountId=acc.id,Contract_Type__c='SLDA - Software Licensing Distribution Agreement',Contract_Status__c='Fully Executed',Contract_Phase__c='6 - Fully Executed Contract Phase',Moto_Signed__c=TRUE,  Partner_Signed__c=TRUE, Motorola_Entity__c='Motorola Inc',SW_Procurement_Owner__c=u.id,Legal_Owner__c=u.id,Finance_Owner__c=u.id,ContractTerm=20);
            insert c;
        
        SW_KIT__c swkit = New SW_KIT__c(SW_Kit_Item_State__c='35 - Full Release');
        
        Sales_Model__c salesmodel = New Sales_Model__c(Name='Test Model');
            insert swkit;
            insert salesmodel;
            date sa = date.newInstance(2013,1,1);
        
        Device__c d = New Device__c(Name='Test Device',SW_KIT__c=swkit.id, Google_TA_Approval_Status__c='Not Applicable', SA_Date__c=sa,Percent_BOM_SD_Apps_w_Executed_Contract__c=100.00,SW_BOM_List_Approver__c = u2.id);
            insert d;
        
        Application__c a = New Application__c(Account__c=acc.id,Name='Test App',  Application_Type__c='Preload',ECCN_subECCN_Value__c='5D002.c.1',ENC_License_Category__c='ENC-Unrestricted: 740.17.b.4',Royalty_Current__c=0.0);
        Application__c a2 = New Application__c(Account__c=acc.id,Name='Test App',  Application_Type__c='Preload',ECCN_subECCN_Value__c='5D002.c.1',ENC_License_Category__c='ENC-Unrestricted: 740.17.b.4');
            insert new List<Application__c>{a, a2};    
        
        ContApplAssoc__c conapp = New ContApplAssoc__c(Application__c=a.id,Contract__c=c.id,Governing_End_Date__c=TRUE);
        ContApplAssoc__c conapp2 = New ContApplAssoc__c(Application__c=a2.id,Contract__c=c.id,Governing_End_Date__c=TRUE);
            insert new List<ContApplAssoc__c>{conapp, conapp2};       
        
        AIF_Approval_Matrix__c aam = New AIF_Approval_Matrix__c(Application_Requester__c=u2.id,Confirmation_of_Budget_Approver__c=u2.id,Device_Name__c=d.id,    DTS_Approver__c=u2.id,Finance_Approver__c=u2.id,FMD_Status_Check_Approver__c=u2.id,LRB_Approver__c=u2.id);
        insert aam;
        
        Application_Manager_Selection_Matrix__c amsm = New Application_Manager_Selection_Matrix__c(Application_Manager__c=u2.id,Application_Type__c='Other',    Device__c=d.id);
        Application_Manager_Selection_Matrix__c amsm2 = New Application_Manager_Selection_Matrix__c(Application_Manager__c=u2.id,Application_Type__c='Preload', Device__c=d.id);
        Application_Manager_Selection_Matrix__c amsm3 = New Application_Manager_Selection_Matrix__c(Application_Manager__c=u2.id,Application_Type__c='Embedded',    Device__c=d.id);
        insert new List<Application_Manager_Selection_Matrix__c>{amsm, amsm2, amsm3};  
        
        SalesModel_Device__c salesmodeldevice = New  SalesModel_Device__c(Sales_Model__c=salesmodel.id,Device__c=d.id);
            insert salesmodeldevice;
            update a;
        
        
        
        DeviceApplicationAssoc__c da35 = New DeviceApplicationAssoc__c(Device__c=d.id,Application__c=a.id, Include_in_BOM__c=TRUE, X3rd_Party_Approval_Status__c= 'N/A'); 
        DeviceApplicationAssoc__c da32 = New DeviceApplicationAssoc__c(Device__c=d.id,Application__c=a2.id, Include_in_BOM__c=TRUE,X3rd_Party_Approval_Status__c= 'N/A');     
        DeviceApplicationAssoc__c da12 = New DeviceApplicationAssoc__c(Device__c=d.id,Application__c=a2.id, Include_in_BOM__c=TRUE); 
        
        insert da12;
        da12.X3rd_Party_Approval_Status__c='In Progress';
        da12.Approval_Status__c= 'Approved';
        update da12;
        
        DeviceApplicationAssoc__c devapp = [SELECT ID, App_Item_State__c FROM DeviceApplicationAssoc__c WHERE ID =: DA12.ID];
        //System.assertEquals('12 - Prelim', devapp.App_Item_State__c);

        d.SWBOM_Reviewed_and_Approved__c='Yes';
        update d;

        Device__c dev = [SELECT ID, Device_SW_KIT_State__c, Device_Fully_Approved__c from Device__c where id =:d.id];
           // System.assertequals('12 - Prelim', dev.Device_SW_KIT_State__c);
           // System.assertequals('No',dev.Device_Fully_Approved__c);


    }    
      static testmethod void DeviceApplicationShippableTestPrelim(){
        Contact u = [SELECT ID FROM Contact where Name=:'Austin Heinrichs']; 
        User u2 = [SELECT ID FROM User where name=:'Austin Heinrichs'];
        Account acc = New Account(name='Test Account', Tier__c='4');
            insert acc;
            date myDate = date.newInstance(2012, 1, 1);
            date myDate2 = date.newInstance(2014,1,1);  
        
        Contract c = New Contract(StartDate=myDate,EndDate=myDate2,name='Testing Contract', AccountId=acc.id,Contract_Type__c='SLDA - Software Licensing Distribution Agreement',Contract_Status__c='Fully Executed',Contract_Phase__c='6 - Fully Executed Contract Phase',Moto_Signed__c=TRUE,  Partner_Signed__c=TRUE, Motorola_Entity__c='Motorola Inc',SW_Procurement_Owner__c=u.id,Legal_Owner__c=u.id,Finance_Owner__c=u.id,ContractTerm=20);
            insert c;
        
        SW_KIT__c swkit = New SW_KIT__c(SW_Kit_Item_State__c='35 - Full Release');
        
        Sales_Model__c salesmodel = New Sales_Model__c(Name='Test Model');
            insert swkit;
            insert salesmodel;
            date sa = date.newInstance(2013,1,1);
        
        Device__c d = New Device__c(Name='Test Device',SW_KIT__c=swkit.id, Google_TA_Approval_Status__c='Not Applicable', SA_Date__c=sa,Percent_BOM_SD_Apps_w_Executed_Contract__c=100.00,SW_BOM_List_Approver__c = u2.id);
            insert d;
        
        Application__c a = New Application__c(Account__c=acc.id,Name='Test App',  Application_Type__c='Preload',ECCN_subECCN_Value__c='5D002.c.1',ENC_License_Category__c='ENC-Unrestricted: 740.17.b.4',Royalty_Current__c=0.0);
        Application__c a2 = New Application__c(Account__c=acc.id,Name='Test App',  Application_Type__c='Preload',ECCN_subECCN_Value__c='5D002.c.1',ENC_License_Category__c='ENC-Unrestricted: 740.17.b.4');
            insert new List<Application__c>{a, a2};     
        
        ContApplAssoc__c conapp = New ContApplAssoc__c(Application__c=a.id,Contract__c=c.id,Governing_End_Date__c=TRUE);
        ContApplAssoc__c conapp2 = New ContApplAssoc__c(Application__c=a2.id,Contract__c=c.id,Governing_End_Date__c=TRUE);
            insert new List<ContApplAssoc__c>{conapp, conapp2};       
        
        AIF_Approval_Matrix__c aam = New AIF_Approval_Matrix__c(Application_Requester__c=u2.id,Confirmation_of_Budget_Approver__c=u2.id,Device_Name__c=d.id,    DTS_Approver__c=u2.id,Finance_Approver__c=u2.id,FMD_Status_Check_Approver__c=u2.id,LRB_Approver__c=u2.id);
        insert aam;
        
        Application_Manager_Selection_Matrix__c amsm = New Application_Manager_Selection_Matrix__c(Application_Manager__c=u2.id,Application_Type__c='Other',    Device__c=d.id);
        Application_Manager_Selection_Matrix__c amsm2 = New Application_Manager_Selection_Matrix__c(Application_Manager__c=u2.id,Application_Type__c='Preload', Device__c=d.id);
        Application_Manager_Selection_Matrix__c amsm3 = New Application_Manager_Selection_Matrix__c(Application_Manager__c=u2.id,Application_Type__c='Embedded',    Device__c=d.id);
        insert new List<Application_Manager_Selection_Matrix__c>{amsm, amsm2, amsm3}; 
        
        SalesModel_Device__c salesmodeldevice = New  SalesModel_Device__c(Sales_Model__c=salesmodel.id,Device__c=d.id);
            insert salesmodeldevice;
            update a;
        
        
        
        DeviceApplicationAssoc__c da35 = New DeviceApplicationAssoc__c(Device__c=d.id,Application__c=a.id, Include_in_BOM__c=TRUE, X3rd_Party_Approval_Status__c= 'N/A'); 
        DeviceApplicationAssoc__c da32 = New DeviceApplicationAssoc__c(Device__c=d.id,Application__c=a2.id, Include_in_BOM__c=TRUE,X3rd_Party_Approval_Status__c= 'N/A');     
        DeviceApplicationAssoc__c da12 = New DeviceApplicationAssoc__c(Device__c=d.id,Application__c=a2.id, Include_in_BOM__c=TRUE); 

        d.SW_Kit__c = NULL;
        
        update d;
        
        Device__c dev = [SELECT ID, Device_SW_KIT_State__c, Device_Fully_Approved__c from Device__c where id =:d.id];
            System.assertequals('12 - Prelim', dev.Device_SW_KIT_State__c);
            System.assertequals('No',dev.Device_Fully_Approved__c);


    }    */
}