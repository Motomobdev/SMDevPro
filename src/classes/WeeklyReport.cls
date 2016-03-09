global class WeeklyReport implements Database.Batchable<sObject>, Database.Stateful {
    /*
    Author: Bineet Mishra
    Create Date: Jan 23, 2014 
    Description: Finalize weekly report at the end of every week.
    */ 
    
    /**
     * Modified by prelude
     * <p>
     * Added program,time period, competitive product fields to the query with where condition as time period field value equals to weekly.
     * </p>
     */
   
    public String query = 'SELECT Weekly_Report__c, Current_Week__c, Previous_Week__c,Program__c,Time_Period__c,Competitive_Product__c,Function__c ' +
                            'FROM Weekly_Report_Item__c ' +
                            'WHERE (Current_Week__c = true OR Previous_Week__c = true)' +
                            ' AND Time_Period__c = \'Weekly\'';
    List<Weekly_Report__c> weeklyReport;

    global Database.QueryLocator start(Database.BatchableContext bc) {     
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {  
        List<Weekly_Report_Item__c> itemsToUpdate = new List<Weekly_Report_Item__c>();
        Weekly_Report__c weeklyCurrent;

        for (SObject s : scope) {
            Weekly_Report_Item__c weeklyItem = (Weekly_Report_Item__c)s;
            weeklyReport = [SELECT Id FROM Weekly_Report__c 
                            WHERE Function__c = :weeklyItem.Function__c 
                            AND Week_Ending__c = :date.today() LIMIT 1];                    

            if (weeklyReport.size() == 0) {
                weeklyCurrent = createWeekly(weeklyItem.Function__c, Date.today());
            } else {
                weeklyCurrent = weeklyReport[0];
            }

            if (weeklyItem.Current_Week__c) {         
                weeklyItem.Weekly_Report__c = weeklyCurrent.Id;             
                weeklyItem.Current_Week__c = false;
                weeklyItem.Previous_Week__c = true;
                itemsToUpdate.add(weeklyItem);
            } else {
                weeklyItem.Previous_Week__c = false;
                itemsToUpdate.add(weeklyItem);
            }
        }
        update itemsToUpdate;
    }

    global void finish(Database.BatchableContext info) {

        Weekly_Report__c[] weeklyReports = [SELECT Id, Function__c FROM Weekly_Report__c 
                                            WHERE Week_Ending__c = :date.today().addDays(7)];
        Map<String, Weekly_Report__c> weeklyReportMap = new Map<String, Weekly_Report__c>();
        
        for (Weekly_Report__c wr : weeklyReports) {
            weeklyReportMap.put(wr.Function__c, wr);
        }

        Schema.DescribeFieldResult fieldResult = Weekly_Report__c.Function__c.getDescribe();
        List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();
        
        for (Schema.PicklistEntry entry: picklistEntries) {
            if (!weeklyReportMap.containsKey(entry.getValue()))
                createWeekly(entry.getValue(), date.today().addDays(7));
        }
    }

    global static Weekly_Report__c createWeekly(String function, Date weekDate) {
        Weekly_Report__c weekly = new Weekly_Report__c();           
        weekly.Name = function + '_' + String.valueOf(weekDate);
        weekly.Function__c = function;
        weekly.Week_Ending__c = weekDate;
        insert weekly;
        return weekly;
    }
}