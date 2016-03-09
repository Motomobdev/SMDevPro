trigger CompetitiveLandscape on Competitive_Landscape__c (before update) 
{
    if(Trigger.isBefore && Trigger.isUpdate)
	{
		CompetitiveLandscapeMethods.beforeUpdate(Trigger.old, Trigger.new);
	}
}