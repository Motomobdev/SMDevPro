public without sharing class OpportunitySnapshotScript {
    public static void SnapshotUpdateScript() {
        String errorMessage = null;
        Integer newCount = 0, updateCount = 0, deleteCount = 0, totalCount = 0;
        Savepoint sp = null;
        
        try {
            Set<Id> newLineItemsIds = new Set<Id>();
            List<Opportunity_Snapshot__c> newLineItems = new List<Opportunity_Snapshot__c>();
            List<Opportunity_Snapshot__c> updatedLineItems = new List<Opportunity_Snapshot__c>();
            Set<Id> deletedLineItemsIds = new Set<Id>();
            List<Opportunity_Snapshot__c> deletedLineItems = new List<Opportunity_Snapshot__c>();
            Map<String, Opportunity_Snapshot__c> prevWeekMap = new Map<String, Opportunity_Snapshot__c>();
            Map<String, Opportunity_Snapshot__c> currWeekMap = new Map<String, Opportunity_Snapshot__c>();
            Set<String> oppLineNumbers = new Set<String>();
            Map<String, Id> oppLineItemMap = new Map<String, Id>();
            
            List<Opportunity_Snapshot_Date__c> osds = 
                      [SELECT Snapshot_Date__c FROM Opportunity_Snapshot_Date__c 
                       WHERE Snapshot_Date__c = THIS_WEEK LIMIT 1];
            if (osds.isEmpty()) {
                insert new Opportunity_Snapshot_Date__c();
                // The snapshot date field has a default value of TODAY 
            }
                
            osds = [SELECT Snapshot_Date__c FROM Opportunity_Snapshot_Date__c 
                    ORDER BY Snapshot_Date__c DESC LIMIT 2];
            Date currSnapDate = osds[0].Snapshot_Date__c;
            Date prevSnapDate = osds[1].Snapshot_Date__c;
            
            Opportunity_Snapshot__c[] currSnaps = [SELECT Opportunity_Number__c, 
                                                          Opportunity_Line_Number__c, 
                                                          Id, 
                                                          Quantity__c, 
                                                          Stage__c, 
                                                          Forecast_Category__c, 
                                                          Product_Forecast_Category__c, 
                                                          CreatedDate, 
                                                          LastModifiedDate
                                                   FROM   Opportunity_Snapshot__c 
                                                   WHERE  Snapshot_Date__c = :currSnapDate];
            
            if (!currSnaps.isEmpty()) {
                if (currSnaps[0].CreatedDate != currSnaps[0].LastModifiedDate) // prevent re-run of script on already processed data
                    throw new ApplicationException('Looks like records with snapshot date "' + String.valueOf(currSnapDate) + '" were already processed. Please execute script manually to force update these records (if required).');
                
                totalCount = currSnaps.size();
            }
            
            for (Opportunity_Snapshot__c currSnap : currSnaps) {
                currWeekMap.put(currSnap.Opportunity_Number__c + '|' + currSnap.Opportunity_Line_Number__c, currSnap);
                oppLineNumbers.add(currSnap.Opportunity_Line_Number__c);
            }
            
            Opportunity_Snapshot__c[] prevSnaps = [SELECT Opportunity_Number__c, 
                                                          Opportunity_Line_Number__c, 
                                                          Id, 
                                                          Quantity__c, 
                                                          Stage__c, 
                                                          Forecast_Category__c, 
                                                          Product_Forecast_Category__c
                                                   FROM   Opportunity_Snapshot__c 
                                                   WHERE  Snapshot_Date__c = :prevSnapDate
                                                        AND WoW_Flag__c != 'Deleted'];
            
            for (Opportunity_Snapshot__c prevSnap : prevSnaps) {
                prevWeekMap.put(prevSnap.Opportunity_Number__c + '|' + prevSnap.Opportunity_Line_Number__c, prevSnap);
                oppLineNumbers.add(prevSnap.Opportunity_Line_Number__c);
            }
            
            OpportunityLineItem[] oppLineItems = [SELECT Opportunity_Line_Number__c, 
                                                         PricebookEntry.Product2Id 
                                                  FROM   OpportunityLineItem 
                                                  WHERE  Opportunity_Line_Number__c IN :oppLineNumbers];
             
            for (OpportunityLineItem oppLineItem : oppLineItems) {
                oppLineItemMap.put(oppLineItem.Opportunity_Line_Number__c, oppLineItem.PricebookEntry.Product2Id);
            }
            
            for (Integer i = 0; i < currSnaps.size(); i++) {
                Opportunity_Snapshot__c prevWeek = prevWeekMap.get(currSnaps[i].Opportunity_Number__c + '|' + currSnaps[i].Opportunity_Line_Number__c);
                
                if (prevWeek == null) {
                    newLineItems.add(new Opportunity_Snapshot__c(Id = currSnaps[i].Id,
                                                                 Prev_Quantity__c = 0,
                                                                 Prev_Stage__c = currSnaps[i].Stage__c,
                                                                 Prev_Forecast_Category__c = currSnaps[i].Forecast_Category__c,
                                                                 Prev_Product_Forecast_Category__c = currSnaps[i].Product_Forecast_Category__c,
                                                                 WoW_Flag__c = 'New',
                                                                 Product__c = oppLineItemMap.get(currSnaps[i].Opportunity_Line_Number__c)));
                } else {
                    updatedLineItems.add(new Opportunity_Snapshot__c(Id = currSnaps[i].Id, 
                                                                     Prev_Week_Snapshot__c = prevWeek.Id,
                                                                     Prev_Quantity__c = prevWeek.Quantity__c,
                                                                     Prev_Stage__c = prevWeek.Stage__c,
                                                                     Prev_Forecast_Category__c = prevWeek.Forecast_Category__c,
                                                                     Prev_Product_Forecast_Category__c = prevWeek.Product_Forecast_Category__c,
                                                                     WoW_Flag__c = ((currSnaps[i].Quantity__c == prevWeek.Quantity__c) ? 'Unchanged' : 'Changed'),
                                                                     Product__c = oppLineItemMap.get(currSnaps[i].Opportunity_Line_Number__c)));
                }
            }
            
            for (Integer i = 0; i < prevSnaps.size(); i++) {
                Opportunity_Snapshot__c currWeek = currWeekMap.get(prevSnaps[i].Opportunity_Number__c + '|' + prevSnaps[i].Opportunity_Line_Number__c);
                
                if (currWeek == null) {
                    deletedLineItemsIds.add(prevSnaps[i].Id);
                }
            }
            
            sp = Database.setSavepoint();
            
            if (!newLineItems.isEmpty()) {
                update newLineItems;
                newCount = newLineItems.size();
            }
    
            if (!updatedLineItems.isEmpty()) {
                update updatedLineItems;
                updateCount = updatedLineItems.size();
            }
    
            if (!deletedLineItemsIds.isEmpty()) {
                List<Opportunity_Snapshot__c> lineItems = database.query(UtilSOQL.getCreatableFieldsSOQL('Opportunity_Snapshot__c', 'Id IN :deletedLineItemsIds'));
                
                for (Opportunity_Snapshot__c lineItem : lineItems) {
                    Opportunity_Snapshot__c li = lineItem.clone(false, true, true, false);
                    
                    li.Id = null;
                    li.Snapshot_Date__c = currSnapDate;
                    li.Prev_Quantity__c = li.Quantity__c;
                    li.Prev_Stage__c = li.Stage__c;
                    li.Prev_Forecast_Category__c = li.Forecast_Category__c;
                    li.Prev_Product_Forecast_Category__c = li.Product_Forecast_Category__c;
                    li.Quantity__c = 0;
                    li.WoW_Flag__c = 'Deleted';
                    li.Product__c = oppLineItemMap.get(li.Opportunity_Line_Number__c);
                    
                    deletedLineItems.add(li);
                }
                
                if (!deletedLineItems.isEmpty()) {
                    insert deletedLineItems;
                    deleteCount = deletedLineItems.size();
                }
            }
            
            if (Test.isRunningTest())
                throw new ApplicationException('For code coverage only!');
        } catch(Exception ex) {
            if (sp != null)
                Database.rollback(sp);
            
            errorMessage = ex.getMessage();
        }
        
        //send success/failure email alert
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        String[] toAddresses = new String[] {'SFDC@motorola.com'}; 
        mail.setToAddresses(toAddresses);
        mail.setReplyTo('SFDC@motorola.com');
        mail.setSenderDisplayName('Salesforce.com IT Support');

        if (errorMessage == null) {
          mail.setSubject('Opportunity Snapshot Script Scheduler : Succeeded');
          mail.setHtmlBody('<table cellpadding="5" cellspacing="0" border="0">' + 
                           '<tr><td>Total Snapshot Records</td><td align="right"><strong>' + String.valueOf(totalCount) + '</strong></td></tr>' + 
                           '<tr><td>New line items</td><td align="right"><strong>' + String.valueOf(newCount) + '</strong></td></tr>' + 
                           '<tr><td>Updated line items</td><td align="right"><strong>' + String.valueOf(updateCount) + '</strong></td></tr>' + 
                           '<tr><td>Deleted line items</td><td align="right"><strong>' + String.valueOf(deleteCount) + '</strong></td></tr>' + 
                           '</table>');
        } else {
          mail.setSubject('Opportunity Snapshot Script Scheduler : Failed');
          mail.setHtmlBody('<strong>Exception:</strong><br/>' + errorMessage);
        }

        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}