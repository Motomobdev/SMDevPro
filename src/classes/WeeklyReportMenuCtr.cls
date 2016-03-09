public without sharing class WeeklyReportMenuCtr {
/*
Author: Bineet Mishra
Created On: Jan 20, 2014
Description: Controller class for WeeklyReportMenu page. This page will be used to display weekly report menu on users
Home page.
*/

/* This can be uncommented if the download link needs to come from attachments stored in Weekly report object.
    public List<Weekly_Report__c> getLatestWeeklyList() {
        Set<Id> weeklyIds = new Set<Id>();
        List<Weekly_Report__c> weeklyList = [SELECT Id, Function__c, Week_Ending__c FROM Weekly_Report__c ORDER BY Week_Ending__c DESC LIMIT 6];
        for(Weekly_Report__c wr : weeklyList){
            weeklyIds.add(wr.Id);
        }
            
        
        List<Weekly_Report__c> weeklyWithAttachments = [SELECT Id, Name, Function__c, Week_Ending__c, (SELECT Id, Name FROM Attachments ORDER BY LastModifiedDate DESC) 
                                                  FROM Weekly_Report__c 
                                                  WHERE Id IN :weeklyIds
                                                  ORDER BY Week_Ending__c DESC];

        return weeklyWithAttachments;
    }
*/

    public Map<String, String> getLatestWeeklyLinks() {
        Map<String, String> weeklyMap = new Map<String, String>();
        List<Weekly_Report__c> weeklyList = [SELECT Id, Function__c, Week_Ending__c FROM Weekly_Report__c ORDER BY Week_Ending__c DESC LIMIT 6];
        for(Weekly_Report__c wr : weeklyList){
            string linkText = wr.Function__c + ' : ' + string.valueOf(wr.Week_Ending__c);
            string linkParam = 'week=' + string.valueOf(wr.Week_Ending__c) + '&function=' + wr.Function__c;
            weeklyMap.put(linkText, linkParam);
        }
            
        return weeklyMap;
    }
}