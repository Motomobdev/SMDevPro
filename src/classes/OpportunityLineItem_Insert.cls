public without sharing class OpportunityLineItem_Insert 
{
    public static void beforeInsert(List<OpportunityLineItem> newList)
    {
        setProductForecastCategory(newList);
    }
    
    private static void setProductForecastCategory(List<OpportunityLineItem> newList)
    {
    	Opportunity opp = [SELECT ForecastCategoryName FROM Opportunity WHERE Id = :newList[0].OpportunityId];
    	
        for(Integer i = 0; i < newList.size(); i++)
        {
        	newList[i].Product_Forecast_Category__c = opp.ForecastCategoryName;
        }
    }
}