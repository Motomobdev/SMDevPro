public class QuoteTriggerHelper {

    //This method grabs the account ID via a formula field and syncs a custom field with the Account Id that can be used for a Related List on Account
    public static void copyAccountId(List<Quote> quotes){
        for(Quote q : quotes){
            q.Account__c = q.Opportunity_Account_ID__c;
            system.debug('Quote.Id='+q.Id+', Quote.Account__c='+q.Account__c+', Quote.Opportunity_Account_ID='+q.Opportunity_Account_ID__c);
        }
    }
}