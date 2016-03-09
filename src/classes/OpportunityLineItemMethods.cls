/****************************************************
Methods for OpportunityLineItem.trigger
****************************************************/
public with sharing class OpportunityLineItemMethods {

    public static Boolean allowProductBundleLineDeletes = false;

    public static void beforeUpdate(List<OpportunityLineItem> oldList, List<OpportunityLineItem> newList) {

        for (Integer i = 0; i < newList.size(); i++) {
            if ((oldList[i].Product_Forecast_Category__c == 'Pipeline' || oldList[i].Product_Forecast_Category__c == 'Best Case') //previous fc is pipeline/best case
               && (newList[i].Product_Forecast_Category__c != 'Pipeline' && newList[i].Product_Forecast_Category__c != 'Best Case') //current fc is not pipeline/best case
               && (oldList[i].Reason_for_Current_Forecast_Category__c == newList[i].Reason_for_Current_Forecast_Category__c)) //reason field is not changed
                newList[i].Reason_for_Current_Forecast_Category__c = null;
        }
    }

    public static void beforeDelete(List<OpportunityLineItem> oldList) {
        for (Integer i = 0; i < oldList.size(); i++) {
            if (!allowProductBundleLineDeletes && oldList[i].Product_Bundle_Line__c != null)
                oldList[i].addError('You cannot delete an opportunity line that is part of a bundle');
        }
    }
}