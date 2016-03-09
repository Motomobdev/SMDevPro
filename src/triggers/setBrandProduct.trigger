trigger setBrandProduct on Competitive_Product__c (before insert, before update) 
{
    if(Trigger.isBefore && Trigger.isInsert)
    {
        for(Integer i = 0; i < Trigger.New.size(); i++)
        {
            Trigger.New[i].Name = Trigger.New[i].Brand__c + ' ' + Trigger.New[i].Product__c;
        }
    }
    
    if(Trigger.isBefore && Trigger.isUpdate)
    {
        for(Integer i = 0; i < Trigger.New.size(); i++)
        {
            if(Trigger.New[i].Brand__c != Trigger.Old[i].Brand__c || Trigger.New[i].Product__c != Trigger.Old[i].Product__c)
                Trigger.New[i].Name = Trigger.New[i].Brand__c + ' ' + Trigger.New[i].Product__c;
        }
    }
}