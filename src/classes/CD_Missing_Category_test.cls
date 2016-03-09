/*
*************************************************************************************************
Description:
This Test Class is for coverage of triggers CD_Missing_Category  and CD_Populate_USDPrice_ItemCost,
CreateDistinctCDBOMStructureRecord

Revision History:
Author/Reviewer   Change Description  Created/Revised Date
 Sivani             Created             9/26/2104




*************************************************************************************************
*/
@isTest
public class CD_Missing_Category_test {
static testMethod void testcostCat(){
CD_Categories__c test = new CD_Categories__c(name='test');
insert test;

}
static testMethod void itemCost_test(){
CD_Item_Cost_Details__c items = new CD_Item_Cost_Details__c(Price__c=100,CurrencyIsoCODE='INR');
insert items;

}
static testMethod void CreateDistinctCDBOM_test(){
Cd_Items__c items = new Cd_Items__c(name='test');
insert items;
CD_Organizations__c orgs =new CD_Organizations__c(name='test');
insert orgs;
CD_BOM_Structure__c  boms = new CD_BOM_Structure__c(Top_Level_Assembly__c=items.id,OrganizationCode__c=orgs.id);
insert boms;

}




}