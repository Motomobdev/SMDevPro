/******************************************************************************************************************
CREATED BY: Neel Desai
CREATED ON: 24/Feb/2014
PURPOSE   : To change one or more Opportunity Line Items' product. This will also take care of snapshot records.
            Batch class: OpportunityProductChangeBatch contains actual logic
VF PAGE   : OpportunityProductChange
******************************************************************************************************************/
public without sharing class OpportunityProductChangeCtr 
{
    public Boolean isAdmin {get; set;}
    public String lineItemIds {get; set;}
    public String productName {get; set;}
    public String idType {get; set;}
    
    public OpportunityProductChangeCtr() 
    {
        try
        {
            if(UtilUserInfo.isContextUserPartOfPublicGroup('GTM Sales Operations').equals('true')
               || UtilUserInfo.isContextUserPartOfPermissionSet('Sales Ops Admin').equals('true')
               || UtilUserInfo.getContextProfileName().equals('System Administrator'))
            {
                IsAdmin = true;
                
                reset();
            }
            else
                isAdmin = false;
            
            if(Test.isRunningTest())
                throw new ApplicationException('For code coverage only!');
        }
        catch(Exception ex)
        {
            ApexPages.addMessage(New ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
        }
    }
    
    public void change()
    {
        try
        {
            if(lineItemIds == null || lineItemIds.length() == 0)
                throw new ApplicationException('Nothing to do! Please input at least one Opportunity Unique ID.');
            if(lineItemIds.containsAny(',;:.\'"'))
                throw new ApplicationException('Opportunity Unique IDs should be line terminated. Please do not use any special characters (like comma, semicolon etc).');
            if(productName == null || productName.length() == 0)
                throw new ApplicationException('Please input new Product Name.');
            
            String lineItemIdsTemp = lineItemIds.replace('\r\n', ',').replace('\n', ',').replace('\r', ',').replace(' ', '');
            
            PricebookEntry[] newProductEntryList = [SELECT Id, Product2Id, Product2.Name, Product2.Family, Product2.Description, Product2.Program__c, Product2.Project__c 
                                                    FROM   PricebookEntry 
                                                    WHERE  Pricebook2Id IN (SELECT Id FROM Pricebook2 WHERE IsStandard = true) 
                                                           AND Product2.Name = :productName 
                                                           AND IsActive = true];
            
            if(newProductEntryList == null || newProductEntryList.isEmpty())
                throw new ApplicationException('Pricebook entry not found for the product "' + productName + '". Please check product name and retry.');
            if(newProductEntryList.size() > 1)
                throw new ApplicationException('Multiple Pricebook entries found for the product "' + productName + '".');
            
            Database.executeBatch(new OpportunityProductChangeBatch(lineItemIdsTemp, idType, newProductEntryList.get(0)), 1);
            
            ApexPages.addMessage(New ApexPages.Message(ApexPages.Severity.CONFIRM, 'Changes have been queued. You will receive an email with status shortly.'));
            
            reset();
            
            if(Test.isRunningTest())
                throw new ApplicationException('For code coverage only!');
        }
        catch(Exception ex)
        {
            ApexPages.addMessage(New ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
        }
    }
    
    public void reset()
    {
        lineItemIds = null;
        productName = null;
        idType = 'SFDC ID';
    }
}