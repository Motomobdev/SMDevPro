global class OpportunityEmailNotifications implements Database.Batchable<sObject>,Database.Stateful {
 /*
 Author: Bineet Mishra
 Create Date: Nov 19, 2013 
 Description: Send email notifications to Opportunity owners if there is no update on Opportunity within last 14 days.
 */ 

 static final string EmailTemplateName = 'X14_Days_No_Activity_Alert_VF';
 
 public String query = 'SELECT Id, Name, StageName, OwnerId, Quarter__c, Year__c, LastModifiedDate, RecordType.Name FROM Opportunity WHERE Quarter__c != null AND Year__c != null AND StageName != null';
 
 global Database.QueryLocator start(Database.BatchableContext bc){     
      return  Database.getQueryLocator(query);
 }

 global void execute(Database.BatchableContext BC, List<sObject> scope) {  
      Integer startMonth, currMonth, currYear, currQuarter, nextYear, nextQuarter;
      Id EmailTemplateID = EmailUtility.FindEmailTemplateIDByDeveloperName(EmailTemplateName);
      startMonth = [SELECT FiscalYearStartMonth FROM Organization LIMIT 1].FiscalYearStartMonth;
      currMonth = Date.today().month();
      currYear = Date.today().year();
      
      currQuarter = 0;
      if(currMonth - startMonth >= 0){
      	currQuarter = (Integer)(currMonth - startMonth)/3 + 1;
      }
      else{
      	currQuarter = 4 - (Integer)(startMonth - currMonth - 1)/3;
      }
      
      if(currQuarter == 4){
      	nextQuarter = 1;
      	nextYear = currYear + 1;
      }
      else{
      	nextQuarter = currQuarter + 1;
      	nextYear = currYear;
      }
      
      
      for (SObject s : scope) {   
           Opportunity opp = (Opportunity)s;       
                if(((opp.Quarter__c.contains(string.valueOf(currQuarter)) && opp.Year__c.contains(string.valueOf(currYear))) || (opp.Quarter__c.contains(string.valueOf(nextQuarter)) && opp.Year__c.contains(string.valueOf(nextYear)))) && opp.LastModifiedDate.addDays(14) < date.today() && opp.StageName != '8. Closed Lost' && opp.StageName != '7. Closed Won' && opp.RecordType.Name == 'MML Sales'){
                    Integer count = [SELECT count() from User WHERE isActive = true AND Id = :opp.OwnerId];
                    if(count > 0)
                        EmailUtility.SendEmail(opp.Id, opp.OwnerId, EmailTemplateID);
                        If(Test.isRunningTest()){
                        	break;
                        }
                   }       
      }      
 }
 
 global void finish(Database.BatchableContext info) {
   
 }
 
 
}