trigger ValidatePriceBookLineDelete on Retail_Price_Book_Line__c (before delete) {
/*****************************************************************************/
/* Trigger name: ValidatePriceBookLineDelete                                 */
/* Author: Tom wozek                                                         */
/* Created: 4/10/2012                                                        */
/* Modified:                                                                 */
/* Purpose: Displays a validation error if the user is attempting to delete a*/
/*          Pricebook Line that has related Forecast lines                 */
/* Last Modified:                                                            */
/* Test Class: RetailSalesTestUtil                                           */
/*****************************************************************************/

  
  Map<Id, Retail_Price_Book_Line__c> Product_Map = 
      new Map<Id, Retail_Price_Book_Line__c>([ 
          SELECT id, Product__r.Name 
          FROM Retail_Price_Book_Line__c WHERE Id in :Trigger.oldMap.keySet()
      ]);
  
  AggregateResult[] cResults  = [SELECT Retail_Price_Book_line__c, count(id) FROM Retail_Forecast_Line__c where Retail_Price_Book_Line__c in :Trigger.oldMap.keySet() GROUP BY Retail_Price_Book_line__c];
  
  for (AggregateResult ar : cResults)  {
     Integer tCount = Integer.valueof(ar.get('expr0'));
     ID tId = String.valueof(ar.get('Retail_Price_Book_Line__c'));
     
     if (tCount > 0 ) {
        Retail_Price_Book_Line__c rpbl = Product_Map.get(tId);
        String tProduct = rpbl.product__r.name;

        String tErrMessage = 'Pricebook line for product ' + tProduct + ' has related Forecast Line(s); cannot be deleted.';
      
        Trigger.oldMap.get(tId).addError(tErrMessage);
        }
  }
}