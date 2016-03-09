/**********************************************************/
// Created by:Srinivas Vadla
// Created Date: 2/5/2014 
// Last Modified:Srinivas Vadla
// Last Modified by: 2/19/2014 
//
// Description:
// This class is used to Move data from Cuurent Qtr Score to Prior QTR Score.
// 
// Test Class: 
// Ssc_Moverecordsfromcurrent_to_prior_Test.cls
/**********************************************************/


global class SSC_Moverecordsfromcurrent_to_prior implements Database.Batchable<sObject>{
    
    global  String Query;
    
    /*global SSC_Moverecordsfromcurrent_to_prior(String q)
    {
        Query=q;
    }  */ 
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
       Query='Select id,Name,Account__r.Id,Comments__c,GenerationDate__c,Month__c,Score__c,ScoreOverrides__c,SubMetric_Name__c,L3SubMetricName__c,VsCompetetorField__c,year__c from SSC_CurrentQuarterScore__c';
        System.debug('###############'+query);
        return Database.getQueryLocator(query);
    }
    //Captures data from Cuurent Qtr Score to Prior QTR Score
    global void execute(Database.BatchableContext BC,list<SSC_CurrentQuarterScore__c> scope)
    {
        
         List<SSC_PriorQuarterScore__c> PriorList = new List<SSC_PriorQuarterScore__c>();
       
       
            for(SSC_CurrentQuarterScore__c Ctr : scope)
            { 
                SSC_PriorQuarterScore__c Ptr = new SSC_PriorQuarterScore__c(); 
                Ptr.Name = Ctr.Name;
                Ptr.Account__c = Ctr.Account__c;
                Ptr.Comments__c =Ctr.Comments__c;
                Ptr.GenerationDate__c = Ctr.GenerationDate__c;
                Ptr.L3SubMetricName__c = Ctr.L3SubMetricName__c;
                Ptr.Month__c = Ctr.Month__c;
                Ptr.Score__c = Ctr.Score__c;  
                Ptr.ScoreOverrides__c = Ctr.ScoreOverrides__c;
                Ptr.SubMetric_Name__c=Ctr.SubMetric_Name__c;
                Ptr.VsCompetetorField__c = Ctr.VsCompetetorField__c;
                Ptr.year__c = Ctr.year__c;
                PriorList.add(Ptr);
                
            }
            
            system.debug('@@@@@@@@@@@@@'+PriorList);
            if(PriorList.size()>0){insert PriorList;}
            
            // Deletes data in Cuurent Qtr Score.
           // if(CurrentList.size()>0){delete CurrentList;}
           Database.delete(scope);
        
        
    }
    
    //After execution an email notification will be send to the respective mentioned email.
    global void finish(Database.BatchableContext BC)
    {
    
     string datestring='Report Date:' + System.now().format('MMMM-dd-yyyy') + '\r\n' + '\r\n';  
        Messaging.SingleEmailMessage message = new   Messaging.SingleEmailMessage();
     
      message.setSaveAsActivity(false);
      message.setTargetObjectId(userinfo.getUserId());
      message.setSubject('Current ScoreCard Data Backup Status');
      message.setPlainTextBody(datestring +'Current Scorecrad Data Backup is completed.Please proceed with Inserting new files into the system.');
       
      
      message.setToAddresses(new String[] {userInfo.getUserEmail() });
     
      Messaging.sendEmail(new Messaging.SingleEmailMessage[] {message});  
        
    }
}