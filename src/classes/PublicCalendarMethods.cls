public without sharing class PublicCalendarMethods 
{
    public static String getIdByName(String calendarName)
    {
    	if(calendarName == null || calendarName == '')
    	    return null;
	    
    	String calendarId = null;
    	
    	// Get public calendar record from custom settings
    	PublicCalendar__c pubCal = PublicCalendar__c.getInstance(calendarName);
    	
    	if(pubCal != null)
    	{
    		calendarId = pubCal.ID__c;
    	}
    	
    	return calendarId;
    }

    public static String getNameById(String calendarId)
    {
        if(calendarId == null || calendarId == '')
            return null;
        
        String calendarName = null;
        
        if(calendarId != null)
            calendarId = calendarId.left(15);
        
        // Get all public calendar records from custom settings
        List<PublicCalendar__c> pubCals = PublicCalendar__c.getAll().values();
        
        for(PublicCalendar__c pubCal : pubCals)
        {
        	if(pubCal.ID__c == calendarId)
                calendarName = pubCal.Name;
        }
        
        return calendarName;
    }
}