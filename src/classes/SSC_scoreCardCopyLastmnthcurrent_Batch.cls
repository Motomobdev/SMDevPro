/**********************************************************/
// Created by:Sivani Mallampalli
// Created Date: 06/10/2015
// 
//
// Description:
// This class is used to copy last month's data as this month's data 
// into current quarterscore object
// 
// Test Class: 
// Ssc_scorecopylastmnthtocurrent_Test.cls
/**********************************************************/
global class SSC_scoreCardCopyLastmnthcurrent_Batch implements Database.Batchable<sObject>{
    
    global  String Query;
    
  
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
       Query='Select id,Name,Account__r.Id,Comments__c,GenerationDate__c,Month__c,Score__c,ScoreOverrides__c,SubMetric_Name__c,L3SubMetricName__c,VsCompetetorField__c,year__c from SSC_CurrentQuarterScore__c';
        System.debug('###############'+query);
        return Database.getQueryLocator(query);
    }
    
    
     global void execute(Database.BatchableContext BC,list<SSC_CurrentQuarterScore__c> scope)
    {
        
         List<SSC_PriorQuarterScore__c> PriorList = new List<SSC_PriorQuarterScore__c>();
         List<SSC_CurrentQuarterScore__c> updateList = new List<SSC_CurrentQuarterScore__c>();
         string month;
 if(system.today().month()==1)
{
month='Januray';
}
if(system.today().month()==2)
{
month='February';
}
if(system.today().month()==3)
{
month='March';
}
if(system.today().month()==4)
{
month='April';
}
if(system.today().month()==5)
{
month='May';
}
if(system.today().month()==6)
{
month='June';
}
if(system.today().month()==7)
{
month='July';
}
if(system.today().month()==8)
{
month='August';
}
if(system.today().month()==9)
{
month='September';
}
if(system.today().month()==10)
{
month='October';
}
if(system.today().month()==11)
{
month='November';
}
if(system.today().month()==12)
{
month='December';
}
       
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
                Ctr.month__c=month;
                Ctr.year__c=string.valueof(system.today().year());
                Ctr.GenerationDate__c=DateTime.ValueOf(system.now());
                updateList.add(Ctr);
                
                
                
                
            }
            
            system.debug('@@@@@@@@@@@@@'+PriorList);
            if(PriorList.size()>0){insert PriorList;}
            if(updateList!=null && updateList.size()>0)
            {
              database.update(updateList);
            
            }
            
          
           
        
        
    }
 
    //After execution an email notification will be send to the respective mentioned email.
    global void finish(Database.BatchableContext BC)
    {
    
     string datestring='Report Date:' + System.now().format('MMMM-dd-yyyy') + '\r\n' + '\r\n';  
        Messaging.SingleEmailMessage message = new   Messaging.SingleEmailMessage();
     
      message.setSaveAsActivity(false);
      message.setTargetObjectId(userinfo.getUserId());
      message.setSubject('Scorecard Data Copy Status');
      message.setPlainTextBody(datestring +'Previous month data is copied into current month.Please check the scorecards');
       
      
      message.setToAddresses(new String[] {userInfo.getUserEmail() });
     
      Messaging.sendEmail(new Messaging.SingleEmailMessage[] {message});  
        
    }
}