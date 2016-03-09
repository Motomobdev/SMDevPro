/**
Author: Bineet Mishra
 Create Date: Nov 25, 2013 
 Description: Send email notifications to customer meetings owners if meeting notes not updated within 3 days of meeting start date.
 */
@isTest (SeeAllData=true)
private class OpportunityEmailNotificationsTest {

static testmethod void TestOpportunityEmailNotifications() {
        
    test.startTest();
    
    OpportunityEmailNotifications OEN = new OpportunityEmailNotifications();
    OEN.query = 'SELECT Id, Name, StageName, OwnerId, Quarter__c, Year__c, LastModifiedDate, Recordtype.Name FROM Opportunity WHERE Quarter__c != null AND Year__c != null AND StageName != null AND LastModifiedDate != LAST_N_DAYS:14 LIMIT 200';
    integer batchSize = 200;
    database.executebatch(OEN, batchSize);
         
    test.stopTest();
   
  }
}