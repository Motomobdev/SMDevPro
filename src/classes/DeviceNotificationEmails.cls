public with sharing class DeviceNotificationEmails {
  public static void motoreadyPMUpdated(Set<Device__c> newList, Set<Device__c> oldList){
    system.debug('START OF MOTOREADYMETHODS');
    List<Messaging.SingleEmailMessage> emailsToSendSingle = new List<Messaging.SingleEmailMessage>();
    Messaging.reserveSingleEmailCapacity(newList.size());
    
    Map<Id, User> userIdMap = UserMethods.getIdUserMap();
    
    //EmailTemplate emailTemplate = [SELECT Id FROM EmailTemplate WHERE Name = 'Motoready PM Updated'];    
    
    Map<Id, List<Device__c>> pmIdDeviceListMap = new Map<Id, List<Device__c>>();
    for(Device__c d : newList){
      List<Device__c> tempList = pmIdDeviceListMap.get(d.MOTOREADY_Preload_Program_Manager__c);
      if(tempList == null){
        tempList = new List<Device__c>{d};
      } else {
        tempList.add(d);
      }
      pmIdDeviceListMap.put(d.MOTOREADY_Preload_Program_Manager__c, tempList);
    }
    
    for(Id pmId : pmIdDeviceListMap.keySet()){
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      mail.setSaveAsActivity(false);
      mail.setToAddresses(new List<String>{userIdMap.get(pmId).email});        
      /*if(devIDpreviousPM.get(d.Id) != null){
        mail.setCcAddresses(new List<String>{userIdMap.get(devIDpreviousPM.get(d.Id)).email});
      }*/
      mail.setReplyTo('mpm@motorola.com');
            mail.setSenderDisplayName('Salesforce Automated Email - Do Not Reply');
            mail.setSubject('You have been assigned as the new Motoready PM for Device(s)');
            
            String stringOfLinks;
            for(Device__c d : pmIdDeviceListMap.get(pmId)){
              if(stringOfLinks == null){
                stringOfLinks = 'You are the new Motoready Preload PM for <a href="https://na2.salesforce.com/' + d.Id + '">' + d.Device_Name_plus_ID__c + '.</a>';
              } else {
                stringOfLinks = stringOfLinks + '<BR>You are the new Motoready Preload PM for <a href="https://na2.salesforce.com/' + d.Id + '">' + d.Device_Name_plus_ID__c + '.</a>';
              }
            }
            
            mail.setHtmlBody('Hi ' + userIdMap.get(pmId).name + ',<BR><BR>' + stringOfLinks +            
            '<BR><BR><I>Do not reply this automated notification.</I>');
            
            emailsToSendSingle.add(mail);     
    }
    
    Map<Id, List<Device__c>> oldPMDeviceListMap = new Map<Id, List<Device__c>>();
    for(Device__c d : oldList){
      List<Device__c> tempList = oldPMDeviceListMap.get(d.MOTOREADY_Preload_Program_Manager__c);
      if(tempList == null){
        tempList = new List<Device__c>{d};
      } else {
        tempList.add(d);
      }
      oldPMDeviceListMap.put(d.MOTOREADY_Preload_Program_Manager__c, tempList);
    }
    
    for(Id pmId : oldPMDeviceListMap.keySet()){
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      mail.setSaveAsActivity(false);
      mail.setToAddresses(new List<String>{userIdMap.get(pmId).email});        
      /*if(devIDpreviousPM.get(d.Id) != null){
        mail.setCcAddresses(new List<String>{userIdMap.get(devIDpreviousPM.get(d.Id)).email});
      }*/
      mail.setReplyTo('mpm@motorola.com');
            mail.setSenderDisplayName('Salesforce Automated Email - Do Not Reply');
            mail.setSubject('The following program(s) have been reassigned to another PM');
            
            String stringOfLinks;
            for(Device__c d : oldPMDeviceListMap.get(pmId)){
              if(stringOfLinks == null){
                stringOfLinks = 'The following program has been reassigned to another PM: <a href="https://na2.salesforce.com/' + d.Id + '">' + d.Device_Name_plus_ID__c + '.</a>';
              } else {
                stringOfLinks = stringOfLinks + '<BR>The following program has been reassigned to another PM: <a href="https://na2.salesforce.com/' + d.Id + '">' + d.Device_Name_plus_ID__c + '.</a>';
              }
            }
            
            mail.setHtmlBody('Hi ' + userIdMap.get(pmId).name + ',<BR><BR>' + stringOfLinks +            
            '<BR><BR><I>Do not reply this automated notification.</I>');
            
            emailsToSendSingle.add(mail);     
    }
    
    if(!emailsToSendSingle.isEmpty()) 
    { 
    	//Messaging.sendEmail(emailsToSendSingle); 
    }
  }
  
    public static void aifComplianceNotification(Set<Device__c> newList){
        List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();
        Set<Id> applicationsWithAIFViolations = new Set<Id>();
        
        for(DeviceApplicationAssoc__c da : [SELECT Application__c FROM DeviceApplicationAssoc__c WHERE Device__c IN : newList AND Application__r.Application_Contract_Status__c != 'Fully Executed' AND Include_in_BOM__c = true ORDER BY SA_Date__c ASC]){
      applicationsWithAIFViolations.add(da.Application__c);
    }
        
        for(DeviceApplicationAssoc__c da : [SELECT Id, SA_Date__c, Name, AppID__c, Application__r.Name, Application__c, Application_Contract_Number__c, AcctOwner__r.Email, Device__r.Name, Device__r.SWBOM_Owner_Email__c, Device__r.Device_ID__c, Device__r.Regional_PM_Email__c, Device__r.Regional_PM__c, Device__r.Program_Manager_Email__c, Device__r.Program_Manager_Name__c FROM DeviceApplicationAssoc__c WHERE Device__c IN : newList AND Approval_Status__c != 'Approved'AND Include_in_BOM__c = true]){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            //mail.setTargetObjectId(da.AcctOwner__c)
            //String[] toAddresses = new String[] {};
            //if(da.AcctOwner__r.Email != null){ toAddresses.add(da.AcctOwner__r.Email); }
            if(UserInfo.getUserName().contains('.com.')){ String[] toAddresses = new String[] { 'brianc@motorola.com'}; } 
            String[] toAddresses = new String[] { 'brianc@motorola.com'};
            //'quicker1@motorola.com',
         
            mail.setToAddresses(toAddresses);
            
            mail.setReplyTo('mpm@motorola.com');
            mail.setSenderDisplayName('Salesforce Automated Email - Do Not Reply');
            mail.setSubject(da.Application__r.Name + ' in ' + da.SA_Date__c.format() + ', ' + da.Device__r.Device_ID__c + ', ' + da.Name);
            
            mail.setHtmlBody('According to NPI records, device SA is planned for ' + da.SA_Date__c.format() + '.<BR>' + da.Name + ' for ' + da.Device__r.Device_ID__c + ':' +  da.Device__r.Name + 
            ' is NOT Approved and impacts Device SA.<BR><BR><B>You are identified as the Approver for this DevApp. Please advise on any issues to Dan Robindeaux.</B><BR><BR>' +
            'If alternate owner, please contact Salesforce support team and update Current Approver for Application ' +
            da.Application__r.Name + '.<BR><BR> <a href="https://na2.salesforce.com/'+ da.Id + '">Link to ' + da.Name + '.</a><BR><BR> ' +
            '<I>This is a system generated email and responses will be ignored.</I>');
            
            mail.setPlainTextBody('According to NPI records, device SA is planned for ' + da.SA_Date__c.format() + '.\n' + da.Name + ' for ' + da.Device__r.Device_ID__c + ':' +  da.Device__r.Name + 
            'is NOT Approved and impacts Device SA.\n\nYou are identified as the Approver for this DevApp. Please advise on any issues to Dan Robindeaux.\n\n' +
            'If alternate owner, please contact Salesforce support team and update Current Approver for Application ' + da.Application__r.Name + '.\n\n' +
            'https://na2.salesforce.com/' + da.Application__c + ' \n\n' + 
            'This is a system generated email and responses will be ignored.');
                        
            
            if(da.SA_Date__c < Date.today().addDays(15)){
                //String[] ccAddresses = new String[] {da.Device__r.Regional_PM_Email__c, da.Device__r.SWBOM_Owner_Email__c, 'quicker1@motorola.com'};
                String[] ccAddresses = new String[] {'brianc@motorola.com'};
                //'quicker1@motorola.com',  

                mail.setCcAddresses(ccAddresses);       
            }
            
            if(!toAddresses.isEmpty()){ emailsToSend.add(mail); }
        }

        //Messaging.sendEmail(emailsToSend);
    }
    
    
    public static void bomComplianceNotification(Set<Device__c> newList)
    {
        List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();
        
        for(Device__c d : newList)
        {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            //mail.setTargetObjectId(da.AcctOwner__c)
            String[] toAddresses = new String[] {'quicker1@motorola.com'};
            String[] ccAddresses = new String[] {};
            
            if(d.SWBOM_Owner_Email__c != null) { toAddresses.add(d.SWBOM_Owner_Email__c); }
            if(d.Regional_PM_Email__c != null) { toAddresses.add(d.Regional_PM_Email__c); }                 
                        
            mail.setReplyTo('mpm@motorola.com');
            mail.setSenderDisplayName('Salesforce Automated Email - Do Not Reply');
            mail.setSubject(d.SA_Date__c.format() + ', ' + d.Device_ID__c + ', ' + d.Name);
            
            mail.setHtmlBody('Dear ' + d.SWBOM_Owner__c + ',<BR><BR>' + 
            'According to NPI records, SA for this device is planned for ' + d.SA_Date__c.format() + '. SW BOM Compliance mandates "SW BOM Reviewed and Approved" in SalesForce within 4 weeks of SA.<BR><BR><B>' + 
            'You are identified as the owner for this action. Please review, configure and approve BOM for this device in SalesForce by COB today.</B><BR><BR>' +
            'If you are not the responsible owner, please contact the device Global PM, ' + d.Program_Manager_Name__c + ', and Update SW BOM owner role in NPI system.<BR><BR>' +      
            '<I>This is a system generated email and responses will be ignored.</I><BR><BR>' +
            '<B>Useful Links:</B><BR>' +
            '<a href="https://na2.salesforce.com/' + d.Id + '">Link to ' + d.Name + '.</a><BR>' +
            '<a href="http://npidashboard.mot.com/cgi/dashboard_customizer.plx">NPI Dashboard.</a><BR>' +
            /*'<a href="https://sites.google.com/a/motorola.com/pmo-community/Community/process/process-file-cabinet/12-Oct-2011PMOTrainingWorkshop.pptx?attredirects=0">SW BOM Process Slide 27.</a>');*/
            '<a href="https://docs.google.com/a/motorola.com/document/d/16HKKvAYVH7wZw-Jgd8uiWUQiqG8ztwAXv9KKMn6tDcs/edit">SW BOM Edit Notes.</a>');
                        
            /*mail.setPlainTextBody('Dear ' + d.SWBOM_Owner__c + ',\n\n' + 
            'According to NPI records, device SA is planned for ' + d.SA_Date__c.format() + '.\n' + 
            'SW BOM Compliance mandates SW BOM Review and Approval in SalesForce within 4w of SA.\n\n' + 
            'You are identified as the owner for this action. Please review, configure and approve BOM for this device in SalesForce by COB today.\n\n' +
            'If alternate owner, please contact the device Global PM, ' + d.Program_Manager_Name__c + ', and Update SW BOM owner role in NPI system.\n\n' +
            'https://na2.salesforce.com/' + d.Id + ' \n\n' +           
            'This is a system generated email and responses will be ignored.');*/         
            
            if(d.SA_Date__c < Date.today().addDays(8))
            {
                if(d.Program_Manager_Email__c != null)
                { 
                  ccAddresses.add(d.Program_Manager_Email__c); 
				}
            }
            
            /***********************************************
            VHD Ticket #140544
            Added on: 06/Dec/2012
            Added by: Neel Desai
            ------------------------------------------------
            Requirement: Add the NPI sourced "Device Project/Program Lead" owner to the automatic email
            ***********************************************/
            if(d.Device_Project_Program_Lead_Email__c != null)
            {
        		ccAddresses.add(d.Device_Project_Program_Lead_Email__c);
            }


            if(!ccAddresses.isEmpty())
	            mail.setCcAddresses(ccAddresses);       

            if(!toAddresses.isEmpty())
            {
	            mail.setToAddresses(toAddresses);
				emailsToSend.add(mail);
            } 
        }
        
        if(!emailsToSend.isEmpty())
        {
          //Messaging.sendEmail(emailsToSend);
        }
    }
    
  public static void contractComplianceNotification(Set<Device__c> newList){      
    List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();
    Set<Id> applicationIdsBeingEmailed = new Set<Id>();
    Set<Id> applicationsWithContractViolations = new Set<Id>();
    Map<Id, List<DeviceApplicationAssoc__c>> appIdDevAppListMap = new Map<Id, List<DeviceApplicationAssoc__c>>();
    Map<Id, String> appIdContractIdMap = new Map<Id, String>();
    
    for(DeviceApplicationAssoc__c da : [SELECT Application__c FROM DeviceApplicationAssoc__c WHERE Device__c IN : newList AND Application__r.Application_Contract_Status__c != 'Fully Executed' AND Include_in_BOM__c = true ORDER BY SA_Date__c ASC]){
      applicationsWithContractViolations.add(da.Application__c);
    }
        
    for(DeviceApplicationAssoc__c da : [SELECT Id, SA_Date__c, Name, AppID__c, Application__r.Name, Application__c, Application__r.Account__r.Name, Application_Contract_Name__c, Application_Contract_Number__c, AcctOwner__r.Name, AcctOwner__r.Email, AcctOwner__r.ManagerId, Device__r.Device_ID__c, Device__r.Regional_PM_Email__c, Device__r.Regional_PM__c, Device__r.Program_Manager_Email__c, Device__r.Program_Manager_Name__c, Device__r.Device_Name_plus_ID__c, Device__c FROM DeviceApplicationAssoc__c WHERE Application__c IN : applicationsWithContractViolations AND Application__r.Application_Contract_Status__c != 'Fully Executed' AND Include_in_BOM__c = true ORDER BY SA_Date__c ASC]){
      if(da.SA_Date__c >= Date.today() && da.SA_Date__c <= Date.today().addDays(42)){
        List<DeviceApplicationAssoc__c> tempList = appIdDevAppListMap.get(da.Application__c);
        if(tempList == null){
          tempList = new List<DeviceApplicationAssoc__c>{da};
        }else {
          tempList.add(da);
        }
        appIdDevAppListMap.put(da.Application__c, tempList);
      }
    }
    system.debug('appIdDevAppListMap: ' + appIdDevAppListMap);
    for(ContApplAssoc__c ca : [SELECT Id, Application__c, Contract__c FROM ContApplAssoc__c WHERE Application__c IN : appIdDevAppListMap.keySet() AND Governing_End_Date__c = true]){
      appIdContractIdMap.put(ca.Application__c, ca.Contract__c);
    }
    
    for(Id appId : appIdDevAppListMap.keySet()){
//      if(!applicationIdsBeingEmailed.contains(Id)){
//        applicationIdsBeingEmailed.add(da.Application__c);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        //mail.setTargetObjectId(da.AcctOwner__c)
        String[] toAddresses = new String[] {};
        if(appIdDevAppListMap.get(appId)[0].AcctOwner__r.Email != null) { toAddresses.add(appIdDevAppListMap.get(appId)[0].AcctOwner__r.Email); }  
        //String[] toAddresses = new String[] { 'quicker1@motorola.com'};
        

        mail.setToAddresses(toAddresses);
        
        if(appIdDevAppListMap.get(appId)[0].SA_Date__c > Date.today().addDays(14)){
          // 4 or 6 week notice
          // add partner manager's manager to email
          try{
            String partnerManagersManagerEmail = [SELECT Id, Email FROM User WHERE Id =: appIdDevAppListMap.get(appId)[0].AcctOwner__r.ManagerId].Email;
            if(partnerManagersManagerEmail != null){
              String[] ccAddresses = new String[] {partnerManagersManagerEmail};
    
              mail.setCcAddresses(ccAddresses);
            }
          } catch(System.QueryException e){
            // current user do not have a manager selected
          }                    
        }
        
        if(appIdDevAppListMap.get(appId)[0].SA_Date__c < Date.today().addDays(15)){
          String[] ccAddresses = new String[] {'quicker1@motorola.com'};
          if(appIdDevAppListMap.get(appId)[0].Device__r.Regional_PM_Email__c != null){ ccAddresses.add(appIdDevAppListMap.get(appId)[0].Device__r.Regional_PM_Email__c); }
          if(appIdDevAppListMap.get(appId)[0].Device__r.Program_Manager_Email__c != null){ ccAddresses.add(appIdDevAppListMap.get(appId)[0].Device__r.Program_Manager_Email__c); }
          //String[] ccAddresses = new String[] {'quicker1@motorola.com'};

          mail.setCcAddresses(ccAddresses);    
        }
        
        mail.setReplyTo('mpm@motorola.com');
        mail.setSenderDisplayName('Salesforce Automated Email - Do Not Reply');
        mail.setSubject(appIdDevAppListMap.get(appId)[0].Application__r.Name + ' (' + appIdDevAppListMap.get(appId)[0].AppID__c + ')');
        // in ' + appIdDevAppListMap.get(appId)[0].SA_Date__c.format() + ', ' + appIdDevAppListMap.get(appId)[0].Device__r.Device_ID__c + ', ' + appIdDevAppListMap.get(appId)[0].Name
        
        String stringOfLinks;
              for(DeviceApplicationAssoc__c da : appIdDevAppListMap.get(appId)){
                if(stringOfLinks == null){
                  stringOfLinks = '<a href="https://na2.salesforce.com/' + da.Device__c + '">' + da.SA_Date__c.format() + ' ' + da.Device__r.Device_Name_plus_ID__c + '.</a>';
                } else {
                  stringOfLinks = stringOfLinks + '<BR> <a href="https://na2.salesforce.com/' + da.Device__c + '">' + da.SA_Date__c.format() + ' ' + da.Device__r.Device_Name_plus_ID__c + '.</a>';
                }
              }
              
              if(appIdDevAppListMap.get(appId)[0].SA_Date__c > Date.today().addDays(14)){
                if(appIdContractIdMap.get(appId) != null){
            mail.setHtmlBody('++++ <BR> ' +
            'CONTRACT CLOSURE REQUIRED: ' + appIdDevAppListMap.get(appId)[0].Application__r.Account__r.Name + ': ' + appIdDevAppListMap.get(appId)[0].Application__r.Name + ': ' + appIdDevAppListMap.get(appId)[0].SA_Date__c.format() + '<BR>' +
            '++++ <BR>' + 
            'Dear ' + appIdDevAppListMap.get(appId)[0].AcctOwner__r.Name + ', <BR><BR>' + 
            'According to our records, the contract, <a href="https://na2.salesforce.com/' + appIdContractIdMap.get(appId) + '">' + appIdDevAppListMap.get(appId)[0].Application_Contract_Name__c + ' (' + appIdDevAppListMap.get(appId)[0].Application_Contract_Number__c + ')</a>, for ' + appIdDevAppListMap.get(appId)[0].Application__r.Name + ' will block the lead device that is dependent on it.<BR><BR>' +
            'The SA for <a href="https://na2.salesforce.com/' + appIdDevAppListMap.get(appId)[0].Device__c + '">' + appIdDevAppListMap.get(appId)[0].Device__r.Device_Name_plus_ID__c + '</a> is planned for ' + appIdDevAppListMap.get(appId)[0].SA_Date__c.format() + '. Please ensure that you will complete this agreement at least 4 weeks before the lead product SA Date of ' + appIdDevAppListMap.get(appId)[0].SA_Date__c.format() + '<BR><BR>' + 
            'NOTE <BR>' + 
            'If you will not be able to complete the agreement before 4 weeks of the lead device SA Date, please immediately notify ' + appIdDevAppListMap.get(appId)[0].Device__r.Regional_PM__c + ' or ' + appIdDevAppListMap.get(appId)[0].Device__r.Program_Manager_Name__c + ' to discuss a contingency risk plan. <BR><BR>' + 
            'If you are at 2 weeks before the SA Date, a waiver is required with VP or above approval immediately. Please see the <a href="https://na2.salesforce.com/sfc/p/400000008LsoDhNWvBvrlfOseFdIiAqi71iyFQs=">instructions</a> for creating and getting waiver approval, and work with the Salesforce/SW BOM teams to close out the device block in the system.<BR><BR>' +
            'If you are not the responsible owner for this contract or application, please contact the SalesForce support team and updated the Account Owner for ' + appIdDevAppListMap.get(appId)[0].Application__r.Name + '. <BR><BR>' +
            'Please note the upcoming Device(s) that are impacted by this contract:<BR>' + 
            stringOfLinks + '.<BR><BR>' +
            '<I>This is a system generated email and responses will be ignored. Please contact the Salesforce support team for additional assistance.</I>' + 
            '++++');
                } else {
                  mail.setHtmlBody('++++ <BR> ' +
            'CONTRACT CLOSURE REQUIRED: ' + appIdDevAppListMap.get(appId)[0].Application__r.Account__r.Name + ': ' + appIdDevAppListMap.get(appId)[0].Application__r.Name + ': ' + appIdDevAppListMap.get(appId)[0].SA_Date__c.format() + '<BR>' +
            '++++ <BR>' + 
            'Dear ' + appIdDevAppListMap.get(appId)[0].AcctOwner__r.Name + ', <BR><BR>' + 
            'According to our records, there is no contract for <a href="https://na2.salesforce.com/' + appId + '">' + appIdDevAppListMap.get(appId)[0].Application__r.Name + '</a> and its absence will block the lead device that is dependent on it.<BR><BR>' +
            'The SA for <a href="https://na2.salesforce.com/' + appIdDevAppListMap.get(appId)[0].Device__c + '">' + appIdDevAppListMap.get(appId)[0].Device__r.Device_Name_plus_ID__c + '</a> is planned for ' + appIdDevAppListMap.get(appId)[0].SA_Date__c.format() + '. Please ensure that you will complete this agreement at least 4 weeks before the lead product SA Date of ' + appIdDevAppListMap.get(appId)[0].SA_Date__c.format() + '<BR><BR>' + 
            'NOTE <BR>' + 
            'If you will not be able to complete the agreement before 4 weeks of the lead device SA Date, please immediately notify ' + appIdDevAppListMap.get(appId)[0].Device__r.Regional_PM__c + ' or ' + appIdDevAppListMap.get(appId)[0].Device__r.Program_Manager_Name__c + ' to discuss a contingency risk plan. <BR><BR>' + 
            'If you are at 2 weeks before the SA Date, a waiver is required with VP or above approval immediately. Please see the <a href="https://na2.salesforce.com/sfc/p/400000008LsoDhNWvBvrlfOseFdIiAqi71iyFQs=">instructions</a> for creating and getting waiver approval, and work with the Salesforce/SW BOM teams to close out the device block in the system.<BR><BR>' +
            'If you are not the responsible owner for this contract or application, please contact the SalesForce support team and updated the Account Owner for ' + appIdDevAppListMap.get(appId)[0].Application__r.Name + '. <BR><BR>' +
            'Please note the upcoming Device(s) that are impacted by this contract:<BR>' + 
            stringOfLinks + '.<BR><BR>' +
            '<I>This is a system generated email and responses will be ignored. Please contact the Salesforce support team for additional assistance.</I>' + 
            '++++');
                }
              } else if(appIdDevAppListMap.get(appId)[0].SA_Date__c < Date.today().addDays(15)) {
                if(appIdContractIdMap.get(appId) != null){
                  mail.setHtmlBody('Dear ' + appIdDevAppListMap.get(appId)[0].AcctOwner__r.Name + ', <BR><BR>' + 
            'According to our records, the contract, <a href="https://na2.salesforce.com/' + appIdContractIdMap.get(appId) + '">' + appIdDevAppListMap.get(appId)[0].Application_Contract_Name__c + ' (' + appIdDevAppListMap.get(appId)[0].Application_Contract_Number__c + ')</a>, for ' + appIdDevAppListMap.get(appId)[0].Application__r.Name + ' will block the lead device that is dependent on it.<BR><BR>' +
            'The SA for <a href="https://na2.salesforce.com/' + appIdDevAppListMap.get(appId)[0].Device__c + '">' + appIdDevAppListMap.get(appId)[0].Device__r.Device_Name_plus_ID__c + '</a> is planned in 2 weeks: ' + appIdDevAppListMap.get(appId)[0].SA_Date__c.format() + '.<BR><BR>' + 
            'Since the agreement has not been completed, a waiver is required with VP or above approval immediately. Please see the <a href="https://na2.salesforce.com/sfc/p/400000008LsoDhNWvBvrlfOseFdIiAqi71iyFQs=">instructions</a> for creating and getting waiver approval, and work with the Salesforce/SW BOM teams to close out the device block in the system.<BR><BR>' +
            'Please note the upcoming Device(s) that are impacted by this contract:<BR>' + 
            stringOfLinks + '.<BR><BR>' +
            '<I>This is a system generated email and responses will be ignored. Please contact the Salesforce support team for additional assistance.</I>');
                } else {
                  mail.setHtmlBody('Dear ' + appIdDevAppListMap.get(appId)[0].AcctOwner__r.Name + ', <BR><BR>' + 
            'According to our records, there is no contract for <a href="https://na2.salesforce.com/' + appId + '">' + appIdDevAppListMap.get(appId)[0].Application__r.Name + '</a> and its absence will block the lead device that is dependent on it.<BR><BR>' +
            'The SA for <a href="https://na2.salesforce.com/' + appIdDevAppListMap.get(appId)[0].Device__c + '">' + appIdDevAppListMap.get(appId)[0].Device__r.Device_Name_plus_ID__c + '</a> is planned in 2 weeks: ' + appIdDevAppListMap.get(appId)[0].SA_Date__c.format() + '.<BR><BR>' + 
            'Since the agreement has not been completed, a waiver is required with VP or above approval immediately. Please see the <a href="https://na2.salesforce.com/sfc/p/400000008LsoDhNWvBvrlfOseFdIiAqi71iyFQs=">instructions</a> for creating and getting waiver approval, and work with the Salesforce/SW BOM teams to close out the device block in the system.<BR><BR>' +
            'Please note the upcoming Device(s) that are impacted by this contract:<BR>' + 
            stringOfLinks + '.<BR><BR>' +
            '<I>This is a system generated email and responses will be ignored. Please contact the Salesforce support team for additional assistance.</I>');
                }
              } 

        if(!toAddresses.isEmpty()){ system.debug('SEND EMAIL'); emailsToSend.add(mail); }
    }
    
    //Messaging.sendEmail(emailsToSend);
  }
    

    
    private static testmethod void notificationsTest(){
        // neds to be split into two tests because of the number of queries 
        User p = [SELECT ID, Username From User Where username LIKE 'datafeed@motorola.com%' LIMIT 1];
        User p2 = [SELECT ID, Username From User Where Id != : p.Id AND isActive = true LIMIT 1];
        
        Account a1 = new Account(Name='Account1', ownerId = p.Id);
        insert a1;
        
        Contract c1 = new Contract(Name='Contract1', AccountId=a1.Id, StartDate=DATE.today());
        insert c1;
        
        Application__c app = new Application__c(Name='App', application_type__c='Preload', Application_Sub_Type__c='faketype', Account__c=a1.Id, Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);
        insert app;
        
        ContApplAssoc__c conApp = new ContApplAssoc__c(application__c=app.Id, contract__c = c1.Id);
        insert conApp;
        
        Device__c dev1 = new Device__c(Name='Dev1', SA_Date__c = Date.today(), SWBOM_Owner_Email__c = 'brian.chiang@motorola.com ', Regional_PM_Email__c = 'brian.chiang@motorola.com', Program_Manager_Email__c = 'brian.chiang@motorola.com');
        Device__c dev2 = new Device__c(Name='Dev2', SA_Date__c = Date.today(), SWBOM_Owner_Email__c = 'brian.chiang@motorola.com ', Regional_PM_Email__c = 'brian.chiang@motorola.com', Program_Manager_Email__c = 'brian.chiang@motorola.com');
        
        System.runAs(p) {        
            insert new List<Device__c>{dev1, dev2};
        }
        system.debug('TEST CODE');
        
        DeviceApplicationAssoc__c devapp = new DeviceApplicationAssoc__c(Device__c=dev1.Id, Application__c=app.Id);
        insert devApp;
        DeviceApplicationAssoc__c devapp2 = new DeviceApplicationAssoc__c(Device__c=dev2.Id, Application__c=app.Id);
        insert devApp2;
        
        Test.startTest();
            dev1.sendContractComplianceEmail__c = true;
            dev1.sendAIFComplianceEmail__c = true;
            dev1.sendBOMComplianceEmail__c = true;
            dev1.MOTOREADY_Preload_Program_Manager__c = p.Id;
            dev2.MOTOREADY_Preload_Program_Manager__c = p.Id;
            update new List<Device__c>{dev1, dev2};
            
            dev1.SA_Date__c = Date.today().addDays(15);
            dev1.sendContractComplianceEmail__c = true;
            dev1.sendAIFComplianceEmail__c = true;
            dev1.sendBOMComplianceEmail__c = true;
            dev1.MOTOREADY_Preload_Program_Manager__c = p2.Id;
            dev2.MOTOREADY_Preload_Program_Manager__c = p2.Id;
            update new List<Device__c>{dev1, dev2};
        Test.stopTest(); 
    }  
}