/*****************************************************************************/
/* Trigger name: ValidateForecastLineDelete                                  */
/* Author: Gennady Kotlyarenko                                               */
/* Created: 2/8/2012                                                         */
/* Modified:                                                                 */
/* Purpose: Displays a validation error if the user is attempting to delete a*/
/*          Forecast Line that has related (child) Outlook line(s)           */
/* Last Modified:                                                            */
/* Test Class: RetailSalesTestUtil                                           */
/*****************************************************************************/
trigger RetailForecastLineDelete on Retail_Forecast_Line__c (before delete) {

  for (Retail_Forecast_Line__c rfl : Trigger.old) {
    
    if (rfl.Outlook_lines__c > 0) {
      rfl.addError('A Forecast Line that has related Outlook Line(s) cannot be deleted');
    }
  }
}