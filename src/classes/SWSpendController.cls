public class SWSpendController{

    public static void createSWSpendRequestMonths(List<Project_Spend__c> swSpends){
    	List<SW_Spend_Request_Month__c> months = new List<SW_Spend_Request_Month__c>();
        for( Project_Spend__c spend: swSpends){
            if( spend.Start_Date__c == null ) continue;
            if( spend.End_Date__c == null ) continue;
            if( spend.Estimated_Spend__c == null ) continue;
        	Date startDate = spend.start_date__c.toStartOfMonth();
            Date endDate = spend.End_Date__c.toStartOfMonth();
            Integer numberOfMonths = (endDate.year() - startDate.year()) * 12 + (endDate.month() - startDate.month() + 1);
            
            for( Integer counter = 0; counter < numberOfMonths; counter++){
            	SW_Spend_Request_Month__c newMonth = new SW_Spend_Request_Month__c(SW_Spend_Request__c=spend.id,start_Date__c=startDate.addMonths(counter)
                                                                               ,end_date__c=endDate.addMonths(counter+1).addDays(-1),Estimated__c=spend.Estimated_Spend__c/numberOfMonths);
            	months.add(newMonth);
            }
        }
        
        if(months.size() > 0) insert months;
    }
    
    public static void updateSWSpendRequestMonthsValues(Map<Id,Project_Spend__c> oldSpends,List<Project_Spend__c> swSpends){
    	List<Project_Spend__c> dateChanged = new List<Project_Spend__c>();
        List<Project_Spend__c> amountChanged = new List<Project_Spend__c>();
        
        for( Project_Spend__c spend: swSpends){
            if( spend.Start_Date__c == null ) continue;
            if( spend.End_Date__c == null ) continue;
            if( spend.Estimated_Spend__c == null ) continue;
        	if(oldSpends.get(spend.id).Start_Date__c != spend.Start_Date__c || oldSpends.get(spend.id).End_Date__c != spend.End_Date__c) dateChanged.add(spend);
        	else if(oldSpends.get(spend.id).Estimated_Spend__c != spend.Estimated_Spend__c) amountChanged.add(spend);
        }
        
        // update changed dates
        delete [Select id From SW_Spend_Request_Month__c Where SW_Spend_Request__c IN :dateChanged];
        createSWSpendRequestMonths(dateChanged);
        
        // update changed Estimate amounts
        updateSWSpendRequestMonthsAmounts(amountChanged);
    }
    
    public static void updateSWSpendRequestMonthsAmounts(List<Project_Spend__c> swSpends){
    	
        // Retreive months and map to Parent SSR Records
        List<SW_Spend_Request_Month__c> months = [Select id,SW_Spend_Request__c,Estimated__c From SW_Spend_Request_Month__c Where SW_Spend_Request__c IN :swSpends];
        Map<ID,List<SW_Spend_Request_Month__c>> SSRtoSSRMmap = new Map<ID,List<SW_Spend_Request_Month__c>>();
        for( SW_Spend_Request_Month__c month: months){
        	if( !SSRtoSSRMmap.containsKey(month.SW_Spend_Request__c) ) SSRtoSSRMmap.put(month.SW_Spend_Request__c,new List<SW_Spend_Request_Month__c>());
            SSRtoSSRMmap.get(month.SW_Spend_Request__c).add(month);
        }
        
        // get new list of updated values
        months = new List<SW_Spend_Request_Month__c>();
        
        for( Project_Spend__c spend: swSpends){
            if( !SSRtoSSRMmap.containsKey(spend.id) ) continue;
        	List<SW_Spend_Request_Month__c> updateMonths = SSRtoSSRMmap.get(spend.id);
            Decimal monthlySpend = spend.Estimated_Spend__c / updateMonths.size();
            for( SW_Spend_Request_Month__c month: updateMonths) month.Estimated__c = monthlySpend;
            months.addAll(updateMonths);
        }
               
        if(months.size() > 0 ) update months;
        
    }
    
}