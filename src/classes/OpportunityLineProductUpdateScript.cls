public without sharing class OpportunityLineProductUpdateScript {
    private void script() {
        // Script can process upto 10 line items at a time
        List<String> oldOppLineIdList = new List<String> { '' };
        List<String> newProductList = new List<String> { '' };
        
        String emailBody = '';
        
        for (Integer i = 0; i < oldOppLineIdList.size(); i++) {
            String oldLineId = oldOppLineIdList[i];
            String newProductName = newProductList[i];
            
            String msg = '<strong>Id:</strong> '+ oldLineId;
            
            List<PricebookEntry> newProductEntryList = 
                [SELECT Id, Product2Id, Product2.Name, Product2.Family, Product2.Description, 
                 Product2.Program__c, Product2.Project__c 
                 FROM PricebookEntry 
                 WHERE Product2.Name = :newProductName 
                 AND IsActive = true];
            if (newProductEntryList == null || newProductEntryList.isEmpty())
                msg += ' | <strong>Error:</strong> Pricebook entry not found for the product "' + newProductName + '"';
            else if (newProductEntryList.size() > 1)
                msg += ' | <strong>Error:</strong> Multiple pricebook entry found for the product "' + newProductName + '"';
            else {
                PricebookEntry newProductEntry = newProductEntryList.get(0);
                
                String q = UtilSOQL.getCreatableFieldsSOQL('OpportunityLineItem', 'Id = :oldLineId');
                q = q.replace('External_ID__c', 'Opportunity_Line_Number__c');
                q = q.replace('TotalPrice', '');
                q = q.replace('Discount', '');
                q = q.replace(',,', ',');
                
                List<OpportunityLineItem> oldOppLineList = database.query(q);
                if (oldOppLineList == null || oldOppLineList.isEmpty())
                    msg += ' | <strong>Error:</strong> Opportunity line item does not exist!';
                else {
                    OpportunityLineItem oldOppLine = oldOppLineList.get(0);
                    
                    if (oldOppLine.PricebookEntryId == newProductEntry.Id)
                        msg += ' | <strong>Error:</strong> No updation is required (already new product).';
                    else {
                        OpportunityLineItem newOppLine = oldOppLine.clone(false, true, false, false);
                        newOppLine.PricebookEntryId = newProductEntry.Id;
                        newOppLine.Skip_Validation__c = true;
                    
                        Savepoint sp = database.setSavepoint();
                    
                        try {
                            String oldOppLineNumber = oldOppLine.Opportunity_Line_Number__c;
                            
                            insert newOppLine;
                            delete oldOppLine;
                            
                            OpportunityLineItem temp = [SELECT Opportunity_Line_Number__c 
                                                        FROM OpportunityLineItem 
                                                        WHERE Id = :newOppLine.Id];
                            String newOppLineNumber = temp.Opportunity_Line_Number__c;
                            
                            List<Opportunity_Snapshot__c> oldSnapshotList = [SELECT Id 
                                                                             FROM Opportunity_Snapshot__c 
                                                                             WHERE Opportunity_Line_Number__c = :oldOppLineNumber];
                            
                            for (Integer j = 0; j < oldSnapshotList.size(); j++) {
                                oldSnapshotList[j].Opportunity_Line_Number__c = newOppLineNumber;
                                oldSnapshotList[j].Product__c = newProductEntry.Product2Id;
                                oldSnapshotList[j].Product_Name__c = newProductEntry.Product2.Name;
                                oldSnapshotList[j].Product_Family__c = newProductEntry.Product2.Family;
                                oldSnapshotList[j].Product_Description__c = newProductEntry.Product2.Description;
                                oldSnapshotList[j].Program__c = newProductEntry.Product2.Program__c;
                                oldSnapshotList[j].Project__c = newProductEntry.Product2.Project__c;
                            }
                            
                            update oldSnapshotList;
                            
                            msg += ' | <strong>New Product:</strong> ' + newProductEntry.Product2.Name + ' | <strong>Snapshot Records:</strong> ' + String.valueOf(oldSnapshotList.size()) + ' | <strong>Success!</strong>';
                        } catch(Exception ex) {
                            if (sp != null)
                                database.rollback(sp);
                            
                            msg += ' | <strong>Error:</strong> ' + ex.getMessage() + '';
                        }
                    }
                }
            }
            
            system.debug(msg);
            msg += '<br /><br />';
            emailBody += msg;
        }
        
        system.debug(emailBody);
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'sfdc@motorola.com'};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Opportunity Line Item - Product change');
        mail.setHtmlBody(emailBody);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}