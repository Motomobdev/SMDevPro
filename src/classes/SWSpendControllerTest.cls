@isTest
public class SWSpendControllerTest{

    public static testMethod void testInsertOfSingleMonthRequest(){
        Date startDate = Date.today().toStartOfMonth();
        Date endDate = startDate.addMonths(1).addDays(-1);
    	Project_Spend__c spend = new Project_Spend__c(Estimated_Spend__c=100,start_date__c=startDate,end_date__c=endDate);
    	Test.startTest();
        insert spend;
        Test.stopTest();
        
        List<SW_Spend_Request_Month__c> months = [Select id,Estimated__c,Start_Date__c,end_date__c FROM SW_Spend_Request_Month__c];
        System.assertEquals(1, months.size());
        
        System.assertEquals(100, months.get(0).Estimated__c);
        System.assertEquals(startDate, months.get(0).start_date__c);
        System.assertEquals(endDate, months.get(0).end_date__c);
    }
    
    public static testMethod void testInsertOf12MonthRequest(){
        Date startDate = Date.today().toStartOfMonth();
        Date endDate = startDate.addMonths(12).addDays(-1);
    	Project_Spend__c spend = new Project_Spend__c(Estimated_Spend__c=144,start_date__c=startDate,end_date__c=endDate);
    	Test.startTest();
        insert spend;
        Test.stopTest();
        
        List<SW_Spend_Request_Month__c> months = [Select id,Estimated__c,Start_Date__c,end_date__c FROM SW_Spend_Request_Month__c];
        System.assertEquals(12, months.size());
        
        for( SW_Spend_Request_Month__c month: months) System.assertEquals(12, months.get(0).Estimated__c);
        
    }
    
    public static testMethod void testUpdatedAmountOf12MonthRequest(){
        Date startDate = Date.today().toStartOfMonth();
        Date endDate = startDate.addMonths(12).addDays(-1);
    	Project_Spend__c spend = new Project_Spend__c(Estimated_Spend__c=144,start_date__c=startDate,end_date__c=endDate);
    	insert spend;
        
        spend.Estimated_Spend__c = 288;
        
        Test.startTest();
          update spend;
        Test.stopTest();
        
        List<SW_Spend_Request_Month__c> months = [Select id,Estimated__c,Start_Date__c,end_date__c FROM SW_Spend_Request_Month__c];
        System.assertEquals(12, months.size());
        
        for( SW_Spend_Request_Month__c month: months) System.assertEquals(24, months.get(0).Estimated__c);
        
    }
    
    public static testMethod void testUpdatedDateOf12MonthRequestTo13Months(){
        Date startDate = Date.today().toStartOfMonth();
        Date endDate = startDate.addMonths(12).addDays(-1);
    	Project_Spend__c spend = new Project_Spend__c(Estimated_Spend__c=169,start_date__c=startDate,end_date__c=endDate);
    	insert spend;
        
        spend.end_date__c = endDate.addMonths(1);
        
        Test.startTest();
          update spend;
        Test.stopTest();
        
        List<SW_Spend_Request_Month__c> months = [Select id,Estimated__c,Start_Date__c,end_date__c FROM SW_Spend_Request_Month__c];
        System.assertEquals(13, months.size());
        
        for( SW_Spend_Request_Month__c month: months) System.assertEquals(13, months.get(0).Estimated__c);
        
    }
    
    public static testMethod void testUpdatedDateOf12MonthRequestTo13MonthsAndAdjustEstimate(){
        Date startDate = Date.today().toStartOfMonth();
        Date endDate = startDate.addMonths(12).addDays(-1);
    	Project_Spend__c spend = new Project_Spend__c(Estimated_Spend__c=144,start_date__c=startDate,end_date__c=endDate);
    	insert spend;
        
        spend.end_date__c = endDate.addMonths(1);
        spend.Estimated_Spend__c = 169;
        
        Test.startTest();
          update spend;
        Test.stopTest();
        
        List<SW_Spend_Request_Month__c> months = [Select id,Estimated__c,Start_Date__c,end_date__c FROM SW_Spend_Request_Month__c];
        System.assertEquals(13, months.size());
        
        for( SW_Spend_Request_Month__c month: months) System.assertEquals(13, months.get(0).Estimated__c);
        
    }
    
}