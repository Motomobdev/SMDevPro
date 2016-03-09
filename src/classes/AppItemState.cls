global class AppItemState {

    @future
    Public static void AppItemState(Set<ID> Apps){    
		Map<ID, DeviceApplicationAssoc__c> devappmap = New Map<ID, DeviceApplicationAssoc__c>([SELECT ID FROM DeviceApplicationAssoc__c WHERE Application__c IN: Apps AND Device__r.Cancelled__c = false AND Device__r.Device_ID__c != null AND INCLUDE_IN_BOM__c = true AND Device__r.Device_Fully_Approved__c = 'No' AND (App_Item_State__c = '12 - Prelim' OR App_Item_State__c = '32 - Controlled')]);    
     
	    update devappmap.values();
    }


     static testmethod void AppUpdateTest()
     {
     	/*
        Contact u = [SELECT ID FROM Contact WHERE AccountId = '0014000000IpuSy' LIMIT 1];
        User user2 = [SELECT Id FROM User WHERE isActive=true AND profileId = '00e40000000oqQ9' LIMIT 1];
        Account acc = New Account(name='Test Account', Tier__c='4');
            insert acc;
            date myDate = date.newInstance(2012, 1, 1);
            date myDate2 = date.newInstance(2014,1,1);  
        
        Contract c = New Contract(StartDate=myDate,EndDate=myDate2,name='Testing Contract', AccountId=acc.id,Contract_Type__c='SLDA - Software Licensing Distribution Agreement',Contract_Status__c='Fully Executed',Contract_Phase__c='6 - Fully Executed Contract Phase',Moto_Signed__c=TRUE,  Partner_Signed__c=TRUE, Motorola_Entity__c='Motorola Inc',SW_Procurement_Owner__c=u.id,Legal_Owner__c=u.id,Finance_Owner__c=u.id,ContractTerm=20);
            insert c;
        User p = [SELECT ID, Username From User Where username LIKE 'datafeed@motorola.com%' LIMIT 1];
        Test.startTest();
	        Device__c d = New Device__c(Name='Test Device', Google_TA_Approval_Status__c='Not Applicable', SA_Date__c=mydate2,Percent_BOM_SD_Apps_w_Executed_Contract__c=100.00,SW_BOM_List_Approver__c = user2.id);
	        	System.runAs(p){
	            	insert d;
	        	}
	        
	        Application__c a = New Application__c(Account__c=acc.id,Name='Test App',  Application_Type__c='Preload', Application_Sub_Type__c='faketype',ECCN_subECCN_Value__c='5D002.c.1',ENC_License_Category__c='ENC-Unrestricted: 740.17.b.4',Royalty_Current__c=0.0, Application_Category__c='Test', Description__c='Desc', Available_For_Use__c=true);
	             
	        
	        Application__c a2 = New Application__c(Account__c=acc.id,Name='Test App',  Application_Type__c='Preload', Application_Sub_Type__c='faketype',ECCN_subECCN_Value__c='5D002.c.1',ENC_License_Category__c='ENC-Unrestricted: 740.17.b.4', Available_For_Use__c=true, Application_Category__c='Test', Description__c='Desc');
	            insert new List<Application__c>{a, a2};     
	        
	        ContApplAssoc__c conapp = New ContApplAssoc__c(Application__c=a.id,Contract__c=c.id,Governing_End_Date__c=TRUE);
	            
	        
	        ContApplAssoc__c conapp2 = New ContApplAssoc__c(Application__c=a2.id,Contract__c=c.id,Governing_End_Date__c=TRUE);
	            insert new List<ContApplAssoc__c>{conapp, conapp2};      
	
	        
	        DeviceApplicationAssoc__c da1 = New DeviceApplicationAssoc__c(Device__c=d.id,Application__c=a.id, Include_in_BOM__c=TRUE); 
	        DeviceApplicationAssoc__c da2 = New DeviceApplicationAssoc__c(Device__c=d.id,Application__c=a2.id, Include_in_BOM__c=TRUE);     
	        DeviceApplicationAssoc__c da3 = New DeviceApplicationAssoc__c(Device__c=d.id,Application__c=a2.id, Include_in_BOM__c=TRUE); 
			insert new List<DeviceApplicationAssoc__c>{da1, da2, da3};
	
			
			a.ECCN_subECCN_Value__c = NULL;
			
			update a;
			
		Test.stopTest();
        

		*/
    }    


}