public with sharing class WeeklyAccountSummaryCtr {
    
    public boolean currentWeek{get; set;}
    public string toggleButtonText{get; set;}
    public string weekEnding{get; set;}

    date weekEndingdate; 
    
    public WeeklyAccountSummaryCtr(ApexPages.StandardController controller){
        currentWeek = true;
        toggleButtonText = 'Show Last Week Items';
        Account acct = (Account)controller.getRecord();
        AggregateResult[] results = [SELECT MAX(Week_Ending__c) maxDate FROM Weekly_Report__c];
        weekEndingdate = (Date)results[0].get('maxDate');
        weekEnding = String.valueOf(weekEndingdate);
    }
    
    public PageReference toggleWeeklyView(){
        if(currentWeek){
            currentWeek = false;
            weekEnding = String.valueOf(weekEndingdate.addDays(-7));
            toggleButtonText = 'Show Current Week Items';
        }
        else{
            currentWeek = true;
            weekEnding = String.valueOf(weekEndingdate);
            toggleButtonText = 'Show Last Week Items';
        }
            
        return null;
    }

}