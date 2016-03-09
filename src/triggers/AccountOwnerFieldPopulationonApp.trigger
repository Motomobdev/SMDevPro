trigger AccountOwnerFieldPopulationonApp on Application__c (before insert) { 
   PopulateAccountOwnerLookuponApp.setPopulateAccountOwneronApp(Trigger.new);
}