/*
* Created by: Daniel Weber
* Creation date: 23-Nov-2011
* Description: This trigger updates the RO Price / RO Units of an outlook line based on inserted/updated/deleted
*              Risks and Opportunities.
* Change history:
*/

trigger RetailOutLookRO on Retail_Outlook_RO__c (after insert, after update, after delete)
{
    set<id> outlookLineIdSet = new set<id>();
    set<id> processedOutlookLineIdSet = new set<id>();
    map<id,Retail_Outlook_Line__c> outlookLineMap;
    list<Retail_Outlook_RO__c> outlookRoList;

    if(trigger.isAfter)
    {
        if(trigger.new != null)
        {
            for(Retail_Outlook_Ro__c roro : trigger.new)
            {
                if(roro.Retail_Outlook_Line__c != null)
                {
                    outlookLineIdSet.add(roro.Retail_Outlook_Line__c);
                }
            }
        }

// loop through trigger.old in order to also catch outlook lines affected by deletes only

        if(trigger.old != null)
        {
            for(Retail_Outlook_Ro__c roro : trigger.old)
            {
                if(roro.Retail_Outlook_Line__c != null)
                {
                    outlookLineIdSet.add(roro.Retail_Outlook_Line__c);
                }
            }
        }

        outlookLineMap = new map<id,Retail_Outlook_Line__c>(
            [select id, RO_Price__c, RO_Units__c
             from Retail_Outlook_Line__c
             where id in :outlookLineIdSet]
        );

        outlookRoList = new list<Retail_Outlook_RO__c>(
            [select Retail_Outlook_Line__c, RO__c, RO_Price__c, RO_Units__c, RO_Probability__c, RO_Type__c
             from Retail_Outlook_RO__c
             where Retail_Outlook_Line__c in :outlookLineIdSet]
        );
        
        for(Retail_Outlook_RO__c roro : outlookRoList)
        {
            Retail_Outlook_Line__c rol = outlookLineMap.get(roro.Retail_Outlook_Line__c);
            
            if(!processedOutlookLineIdSet.contains(roro.Retail_Outlook_Line__c))
            {
                rol.RO_Price__c = 0;
                rol.RO_Units__c = 0;
                processedOutlookLineIdSet.add(roro.Retail_Outlook_line__c);
            }
            
            if(roro.RO_Probability__c.equals('High') || roro.RO_Probability__c.equals('Medium'))
            {
                if(roro.RO_Type__c.equals('Price'))
                {
                    rol.RO_Price__c = (roro.RO__C.equals('Risk') ? rol.RO_Price__c - roro.RO_Price__c : rol.RO_Price__c + roro.RO_Price__c);
                }

                else
                {
                    rol.RO_Units__c = (roro.RO__C.equals('Risk') ? rol.RO_Units__c - roro.RO_Units__c : rol.RO_Units__c + roro.RO_Units__c);
                }
            }
        }

        update outlookLineMap.values();
    }
}