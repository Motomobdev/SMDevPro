/******************************************************************************************************************
CREATED BY: Neel Desai
CREATED ON: 25/Feb/2014
PURPOSE   : Batch class. Contains actual logic. To be called from OpportunityProductChangeCtr class.
******************************************************************************************************************/
global without sharing class OpportunityProductChangeBatch implements Database.Batchable<sObject>, Database.Stateful
{
    global final String lineItemsIds;
    global final String idType;
    global final PricebookEntry newProductEntry;
    
    global final List<String> LineItemIdList;
    global Set<String> LineItemIdSet;
    global List<String> emailBodyLineList;
    
    global OpportunityProductChangeBatch(String lineItemsIds, String idType, PricebookEntry newProductEntry)
    {
        this.lineItemsIds = lineItemsIds;
        this.idType = idType;
        this.newProductEntry = newProductEntry;
        
        emailBodyLineList = new List<String>();
        emailBodyLineList.add('<table cellpadding="3" cellspacing="0" border="1" style="font-size: 8pt;">');
        emailBodyLineList.add('<caption>** Request was initiated by ' + UserInfo.getName() + ' **</caption>');
        emailBodyLineList.add('<tr><th>Old Id</th><th>Old Line Num</th><th>Old Product</th><th>New Id</th><th>New Line Num</th><th>New Product</th><th>Updated Snapshot Records</th></tr>');
        
        LineItemIdList = lineItemsIds.split(',', 0);
        LineItemIdSet = new Set<String>(LineItemIdList);
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) 
    {
        String query;
        
        if(idType.equals('SFDC ID'))
            query = UtilSOQL.getCreatableFieldsSOQL('OpportunityLineItem', 'Id IN :LineItemIdList');
        else
            query = UtilSOQL.getCreatableFieldsSOQL('OpportunityLineItem', 'Opportunity_Line_Number__c IN :LineItemIdList');
        
        query = query.replace('External_ID__c', 'Opportunity_Line_Number__c');
        query = query.replace('TotalPrice', '');
        query = query.replace('Discount', '');
        
        //updated by swetha from query = query.replace(',,', ',') to query = query.replace(',,', ',').replace(',,', ',')
        query = query.replace(',,', ',').replace(',,', ',');
        
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<sObject> scope) 
    {
        for(Integer i = 0; i < scope.size(); i++)
        {
            OpportunityLineItem oldOppLine = (OpportunityLineItem)scope[i];
            
            PricebookEntry oldProductEntry = [SELECT Product2.Name 
                                              FROM   PricebookEntry 
                                              WHERE  Id = :oldOppLine.PricebookEntryId];
            
            if(idType.equals('SFDC ID'))
            {
                LineItemIdSet.remove(String.valueOf(oldOppLine.Id));
                LineItemIdSet.remove(String.valueOf(oldOppLine.Id).left(15));
            }
            else
                LineItemIdSet.remove(oldOppLine.Opportunity_Line_Number__c);
            
            String row = '<tr>';
            
            row += '<td>' + String.valueOf(oldOppLine.Id).left(15) + '</td>' +
                   '<td>' + oldOppLine.Opportunity_Line_Number__c + '</td>' +
                   '<td>' + oldProductEntry.Product2.Name + '</td>';
                    
            if(String.valueOf(oldOppLine.PricebookEntryId).left(15) == String.valueOf(newProductEntry.Id).left(15))
                row += '<td colspan="4"><strong>Info:</strong> No updation is required (already new product).</td>';
            else
            {
                OpportunityLineItem newOppLine = oldOppLine.clone(false, true, false, false);
                newOppLine.PricebookEntryId = newProductEntry.Id;
                newOppLine.Skip_Validation__c = true;
            
                Savepoint sp = database.setSavepoint();
            
                try
                {
                    String oldOppLineNumber = oldOppLine.Opportunity_Line_Number__c;
                    
                    insert newOppLine;
                    delete oldOppLine;
                    
                    OpportunityLineItem temp = [SELECT Opportunity_Line_Number__c FROM OpportunityLineItem WHERE Id = :newOppLine.Id];
                    String newOppLineNumber = temp.Opportunity_Line_Number__c;
                    
                    List<Opportunity_Snapshot__c> oldSnapshotList = [SELECT Id FROM Opportunity_Snapshot__c WHERE Opportunity_Line_Number__c = :oldOppLineNumber];
                    
                    for(Integer j = 0; j < oldSnapshotList.size(); j++)
                    {
                        oldSnapshotList[j].Opportunity_Line_Number__c = newOppLineNumber;
                        oldSnapshotList[j].Product__c = newProductEntry.Product2Id;
                        oldSnapshotList[j].Product_Name__c = newProductEntry.Product2.Name;
                        oldSnapshotList[j].Product_Family__c = newProductEntry.Product2.Family;
                        oldSnapshotList[j].Product_Description__c = newProductEntry.Product2.Description;
                        oldSnapshotList[j].Program__c = newProductEntry.Product2.Program__c;
                        oldSnapshotList[j].Project__c = newProductEntry.Product2.Project__c;
                    }
                    
                    update oldSnapshotList;
                    
                    row += '<td>' + String.valueOf(newOppLine.Id).left(15) + '</td>' +
                           '<td>' + newOppLineNumber + '</td>' +
                           '<td>' + newProductEntry.Product2.Name + '</td>' +
                           '<td>' + String.valueOf(oldSnapshotList.size()) + '</td>';
                }
                catch(Exception ex)
                {
                    if(sp != null)
                        database.rollback(sp);
                    
                    row += '<td colspan="4"><strong>Error:</strong> ' + ex.getMessage() + '</td>';
                }
            }
            
            row += '</tr>';
            emailBodyLineList.add(row);
        }

    }
    
    global void finish(Database.BatchableContext BC) 
    {
        for(String LineItemId : LineItemIdSet)
        {
            if(idType.equals('SFDC ID'))
                emailBodyLineList.add('<tr><td>' + LineItemId.left(15) + '</td><td></td><td></td><td colspan="4"><strong>Error:</strong> Invalid value. No Opportunity Line exists with this SFDC ID.</td></tr>');
            else
                emailBodyLineList.add('<tr><td></td><td>' + LineItemId.left(15) + '</td><td></td><td colspan="4"><strong>Error:</strong> Invalid value. No Opportunity Line exists with this Line Number.</td></tr>');
        }
        
        emailBodyLineList.add('</table>');
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] { UserInfo.getUserEmail() };
        mail.setToAddresses(toAddresses);
        String[] ccAddresses = new String[] { 'sfdc@motorola.com', 'jshah2@motorola.com', 'pankajmarkandey@motorola.com', 'neeldesai@motorola.com' };
        mail.setCcAddresses(ccAddresses);
        mail.setSubject('Opportunity Line Item - Product change request');
        mail.setHtmlBody(String.join(emailBodyLineList, '\n'));
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}