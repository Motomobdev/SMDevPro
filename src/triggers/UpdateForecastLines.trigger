trigger UpdateForecastLines on Retail_Price_Book_Line__c (after update) {

    /*
     * Author: Rajesh Krishnaiah
     * Date  : 17-Nov-2011
     * Test Class: <TO-DO>
     * Description:
     *   A forecast lines is a clone of a price book line. Changes to a price book line 
     *   should result in updates to the corresponding forecast lines only if the 
     *   quarter being updated is NOT locked in the forecast
     *
     */
    List<Retail_Forecast_Line__c> rfls = [ select id, asp__c, mcpu__c,
                                                      retail_forecast__r.locked__c,
                                                      retail_forecast__r.forecast_quarter__c,
                                                      Retail_Price_Book_Line__c
                                           from Retail_Forecast_Line__c
                                           where Retail_Price_Book_Line__c in :trigger.newMap.keyset()
                                           order by Retail_Price_Book_Line__c];
    
    // Build a map of price book line ID with values of the related retail forecast lines list
    Map<Id, List<Retail_Forecast_Line__c>> rpblMap = new Map<Id, List<Retail_Forecast_Line__c>>();
    for (Retail_Forecast_Line__c rfl : rfls) {
    
        List<Retail_Forecast_Line__c> rflList = rpblMap.get(rfl.Retail_Price_Book_Line__c);
        if (rflList != null) {
            rflList.add(rfl);
        } else {
            rflList = new List<Retail_Forecast_Line__c>();
            rflList.add(rfl);
            
            rpblMap.put(rfl.Retail_Price_Book_Line__c, rflList);
        }
    }
    
    // Create a list of forecast lines to update
    List<Retail_Forecast_Line__c> rflToUpdate = new List<Retail_Forecast_Line__c>();
    
    // Loop through the modifed retail price book lines
    for (Integer x = 0; x < Trigger.new.size(); x++) {
        Boolean q1Changed = false;
        Boolean q2Changed = false;
        Boolean q3Changed = false;
        Boolean q4Changed = false;
        
        Retail_Price_Book_Line__c rpblNew = Trigger.new[x];
        Retail_Price_Book_Line__c rpblOld = Trigger.old[x];
        
        // identify the updated quarter
        if (rpblNew.q1_asp__c != rpblOld.q1_asp__c || rpblNew.q1_mcpu__c != rpblOld.q1_mcpu__c )
          q1Changed = true;
        if (rpblNew.q2_asp__c != rpblOld.q2_asp__c || rpblNew.q2_mcpu__c != rpblOld.q2_mcpu__c )
          q2Changed = true;        
        if (rpblNew.q3_asp__c != rpblOld.q3_asp__c || rpblNew.q3_mcpu__c != rpblOld.q3_mcpu__c )
          q3Changed = true;
        if (rpblNew.q4_asp__c != rpblOld.q4_asp__c || rpblNew.q4_mcpu__c != rpblOld.q4_mcpu__c )
          q4Changed = true;
    
        // Find the forecast lines relating to this price book line
        List<Retail_Forecast_Line__c> rflList = rpblMap.get(rpblNew.id);
        
        if (rflList != null) {
            // For each forecast line related to this price book line
            for (Retail_Forecast_Line__c rfl : rflList) {
    
                if (rfl.retail_forecast__r.locked__c == false && 
                    rfl.retail_forecast__r.forecast_quarter__c == 'Q1' && 
                    q1Changed == true) {
                    rfl.asp__c = rpblnew.q1_asp__c;
                    rfl.mcpu__c = rpblnew.q1_mcpu__c;
                }
    
                if (rfl.retail_forecast__r.locked__c == false && 
                    rfl.retail_forecast__r.forecast_quarter__c == 'Q2' && 
                    q2Changed == true) {
                    rfl.asp__c = rpblnew.q2_asp__c;
                    rfl.mcpu__c = rpblnew.q2_mcpu__c;
                }
                
                if (rfl.retail_forecast__r.locked__c == false && 
                    rfl.retail_forecast__r.forecast_quarter__c == 'Q3' && 
                    q3Changed == true) {
                    rfl.asp__c = rpblnew.q3_asp__c;
                    rfl.mcpu__c = rpblnew.q3_mcpu__c;
                }
                
                if (rfl.retail_forecast__r.locked__c == false && 
                    rfl.retail_forecast__r.forecast_quarter__c == 'Q4' && 
                    q4Changed == true) {
                    rfl.asp__c = rpblnew.q4_asp__c;
                    rfl.mcpu__c = rpblnew.q4_mcpu__c;
                }
                
                // If there are changes to any one of the quarters, flag the retail forecast line for an update
                if (q1Changed || q2Changed || q3Changed || q4Changed)
                    rflToUpdate.add(rfl);
            }
        }
    }
    
    if (!rflToUpdate.isEmpty())
        update rflToUpdate;
}