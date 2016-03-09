public with sharing class WeeklyReportGridCtr {
/*
Author: Bineet Mishra
Creatded On: Jan 2014
Description: Controller for WeeklyReportGrid Page
*/	
	List<Id> accountList;
	Set<Id>  accountIds;
	
	public boolean currentWeek{get; set;}	
	public string function{get; set;}
	public string weekEnding {get; set;}
	
	public boolean previousWeek{get; set;}
	public string toggleButtonText{get; set;}
	
	List<Weekly_Report_Item__c> weeklyItems;
	Weekly_Report__c weekly;
	Date weekEndingDate; 
	
	public WeeklyReportGridCtr(){
		accountList = new List<Id>();
		accountIds = new Set<Id>();
		 
		function = ApexPages.currentPage().getParameters().get('function');
		weekEnding = ApexPages.currentPage().getParameters().get('week');
		toggleButtonText = 'Show Previous Week Weekly';
		
		if(function == null)
			function = 'GTM';
		if(weekEnding != null){
			currentWeek = false;
			previousWeek = false;
			weekEndingDate = Date.valueOf(weekEnding);
		}
		else{
			currentWeek = true;
			previousWeek = false;
			AggregateResult[] result = [SELECT MAX(Week_Ending__c) maxDate FROM Weekly_Report__c];
			weekEndingDate = (Date)result[0].get('maxDate');
			weekEnding = String.valueOf(weekEndingDate);
		}
	}
		
	public string getAccountIdsList(){
		if(currentWeek){
			weeklyItems = [SELECT Account__c 
						FROM Weekly_Report_Item__c 
						WHERE Current_Week__c = True 
							AND Include_in_Report__c = True
							AND Function__c = :function];
		}
		else if(previousWeek){
			weeklyItems = [SELECT Account__c 
						FROM Weekly_Report_Item__c 
						WHERE Previous_Week__c = True 
							AND Include_in_Report__c = True
							AND Function__c = :function];
		}
									
		accountList.clear();												
		for(Weekly_Report_Item__c weeklyItem : weeklyItems){
			accountList.add(weeklyItem.Account__c);
		}
		return String.join(accountList,',');
	}
	
	public Weekly_Report__c getweeklyReport(){
		weekly = [SELECT Id 
						FROM Weekly_Report__c 
						WHERE Week_Ending__c = :weekEndingDate 
							AND Function__c = :function LIMIT 1];
		return weekly;
	}
	
		
	public PageReference toggleWeeklyView(){
		if(currentWeek){
			currentWeek = false;
			previousWeek = true;
			weekEnding = String.valueOf(weekEndingDate.addDays(-7));
			toggleButtonText = 'Show Current Week Weekly';
		}
		else{
			currentWeek = true;
			previousWeek = false;
			weekEnding = String.valueOf(weekEndingDate.addDays(7));
			toggleButtonText = 'Show Previous Week Weekly';
		}
			
		return null;
	}

}