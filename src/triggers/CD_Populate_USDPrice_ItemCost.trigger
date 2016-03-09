/*
*************************************************************************************************
Description:
This trigger is for calculating USD price in Item Cost Details Object

Revision History:
Author/Reviewer   Change Description  Created/Revised Date
 Sivani             Created             9/26/2104




*************************************************************************************************
*/
trigger CD_Populate_USDPrice_ItemCost on CD_Item_Cost_Details__c (before insert,before update) {

Map<string,Decimal> currencyMap = new Map<string,Decimal>();
list<CurrencyType> curencyConversion = [SELECT ISOCode, ConversionRate FROM CurrencyType WHERE IsActive=TRUE];

for(CurrencyType curr : curencyConversion)
{
currencyMap.put(curr.ISOCode,curr.ConversionRate);


}
for(CD_Item_Cost_Details__c items : Trigger.new)
{
 if(currencyMap.containsKey(items.CurrencyIsoCode)){
 
 system.debug('in contains key');
 system.debug('in contains key' + items.CurrencyIsoCode + currencyMap.get(items.CurrencyIsoCode));
 system.debug('items.Price__c' + items.Price__c);
 items.USD_Price__c=items.Price__c/currencyMap.get(items.CurrencyIsoCode);
 
 }
 else
 items.addError('Inavlid Currency');

}


}