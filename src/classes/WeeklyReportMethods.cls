public with sharing class WeeklyReportMethods {
	
	private static boolean alreadyUpdated = false;
       	
    public static boolean hasAlreadyUpdated(){
    	return alreadyUpdated;
    }
    	
    public static void setAlreadyUpdated(){
    	alreadyUpdated = true;
    }

    public static void UpdateFields(Weekly_Report_Item__c weeklyItem){
		setAlreadyUpdated();
		Weekly_Report_Item__c reportItem = [SELECT Id, Weekly_Report__c, Meeting__r.Id, Meeting__r.Account__c, Account__c, Source_Type__c, Source_ID__c, Function__c FROM Weekly_Report_Item__c WHERE Id = :weeklyItem.Id];
		
		if(reportItem.Weekly_Report__c == null){
			AggregateResult[] results = [SELECT MAX(Week_Ending__c) maxdate FROM Weekly_Report__c WHERE Function__c = :reportItem.Function__c];
			Date weekEnding = (Date)results[0].get('maxdate');
			Weekly_Report__c[] weekly = [SELECT Id FROM Weekly_Report__c WHERE Function__c = :reportItem.Function__c AND Week_Ending__c = :weekEnding];
			if(!weekly.isEmpty())
				reportItem.Weekly_Report__c = weekly[0].Id;
		}
		else{
			Weekly_Report__c weekly = [SELECT Id, Function__c, Week_Ending__c FROM Weekly_Report__c WHERE Id = :reportItem.Weekly_Report__c];
			if(weekly.Function__c != reportItem.Function__c){
				Weekly_Report__c[] newWeekly = [SELECT Id FROM Weekly_Report__c WHERE Function__c = :reportItem.Function__c AND Week_Ending__c = :weekly.Week_Ending__c];
				if(!newWeekly.isEmpty())
					reportItem.Weekly_Report__c = newWeekly[0].Id;
			}
		}

		if(reportItem.Source_Type__c != null){
			if(reportItem.Source_Type__c == 'Task'){
				Task t = [SELECT WhatId FROM Task WHERE Id = :reportItem.Source_ID__c];
				Id objId = t.WhatId;
				system.debug('objId: ' + objId);
				reportItem.Source_Link__c = URL.getSalesforceBaseUrl().toExternalForm() + '/' + reportItem.Source_ID__c;
				
				Schema.SObjectType token = objId.getSObjectType();
				Schema.DescribeSObjectResult dr = token.getDescribe();
				system.debug('obj Name: ' + dr.getName());
				
				if(dr.getName() =='Account'){
					reportItem.Account__c = objId;
				}
				if(dr.getName() =='Retail_Playbook__c'){
					Retail_Playbook__c pb = [SELECT Account__r.Id FROM Retail_Playbook__c WHERE Id= :objId];
					reportItem.Account__c = pb.Account__r.Id;
				}
				if(dr.getName() =='Customer_Meeting__c'){
					Customer_Meeting__c mt = [SELECT Account__r.Id FROM Customer_Meeting__c WHERE Id= :objId];
					reportItem.Account__c = mt.Account__r.Id;
				}				       		
			}									
		}
		else if(reportItem.Meeting__c != null){
				reportItem.Source_Type__c = 'Meeting';
				reportItem.Source_ID__c = reportItem.Meeting__r.Id;
				reportItem.Source_Link__c = URL.getSalesforceBaseUrl().toExternalForm() + '/' + reportItem.Source_ID__c;
				reportItem.Account__c = reportItem.Meeting__r.Account__c;
			}			
		update reportItem;		
	}
}