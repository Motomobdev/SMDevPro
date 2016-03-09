/********************************************************************************************
CREATED BY : Neel Desai
CREATED ON : 28-Jan-2014
PURPOSE    : CompetitiveLandscape.trigger methods
             
TEST CLASS : CompetitiveLandscapeMethodsTest
********************************************************************************************/
public without sharing class CompetitiveLandscapeMethods 
{
    public static void beforeUpdate(Competitive_Landscape__c[] oldList, Competitive_Landscape__c[] newList)
    {
    	for(Integer i = 0; i < newList.size(); i++)
    	{
    		if(newList[i].Latest_Updates__c != oldList[i].Latest_Updates__c && oldList[i].Latest_Updates__c != '')
    		{
                String history = oldList[i].LastModifiedDate.formatGmt('MM/dd/yyyy HH:mm:ss') + ' GMT\r\n' + 
                                 oldList[i].Latest_Updates__c + 
                                 (oldList[i].History__c != null ? '\r\n----------\r\n' + oldList[i].History__c : '');
                newList[i].History__c = history; //archive old value in History
    		}
    	}
    }
}