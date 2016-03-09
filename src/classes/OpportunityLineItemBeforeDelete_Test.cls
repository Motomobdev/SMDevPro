@isTest (SeeAllData = true) 
private class OpportunityLineItemBeforeDelete_Test
{
static testMethod void testOpportunityLineItemDeletion()
{
Profile pf = [Select Id from Profile where Name = 'System Administrator'];
User u = new User();
u.FirstName = 'Test';
u.LastName = 'User';
u.Email = 'testuser@test123456789.com';
u.CompanyName = 'test.com';
u.Title = 'Test User';
u.Username = 'testuser@test123456789.com';
u.Alias = 'testuser';
u.CommunityNickname = 'Test User';
u.TimeZoneSidKey = 'America/Mexico_City';
u.LocaleSidKey = 'en_US';
u.EmailEncodingKey = 'ISO-8859-1';
u.ProfileId = pf.Id;
//u.Default_Group__c='All';
u.LanguageLocaleKey = 'en_US';
//insert u;
system.runAs(u)
{
Account act = new Account();
act.Name='TestAccount';
act.Allow_Opportunities__c = true;
//insert act;
 
Opportunity op = new Opportunity();
op.Name='TestOpp';
op.AccountId=act.Id;
op.StageName = '1. Prospecting';
op.CloseDate=system.today();

insert op;
 
 
// Create a new product
Product2 product = new Product2();
product.Name='Additional Client Licenses';
product.IsActive=true;
insert product ;
 
 
//Create a custom pricebook
Pricebook2 pb= [select Id,IsActive from PriceBook2 where IsStandard=True];
//if(pb!=null && pb.size() > 0)
//{
//pb.IsActive = true;
//update pb;
//}
// Create a pricebook entry for custom pricebook
PricebookEntry pbe = new PricebookEntry();
pbe.UseStandardPrice = false;
pbe.Pricebook2Id=pb.id;
pbe.Product2Id=product.id;
pbe.IsActive=true;
pbe.UnitPrice=100.0;
//pbe.UseStandardPrice =true;
insert pbe;
 
 
OpportunityLineItem NewRec = new OpportunityLineItem();
NewRec.UnitPrice=200;
NewRec.Quantity=3;
NewRec.OpportunityId=op.Id;
NewRec.PricebookEntryId=pbe.id;
NewRec.Product_Forecast_Category__c='Pipeline';
NewRec.ServiceDate=System.Today();
NewRec.Reason_for_Current_Forecast_Category__c='test';

insert NewRec;
OpportunityLineItem updateRec = new OpportunityLineItem(id=NewRec.id);
updateRec = [Select id, Quantity from OpportunityLineItem where id=:NewRec.id];

update updateRec;
OpportunityLineItem deleteRec = new OpportunityLineItem();
deleteRec = [Select id, Quantity from OpportunityLineItem where id=:NewRec.id];
delete NewRec ; 
 
 
 
 
}
}
}