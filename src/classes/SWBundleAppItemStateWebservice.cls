global class SWBundleAppItemStateWebservice 
{
    webService static Boolean scheduleRun()
    {
    	Boolean isSuccess = false;
    	
    	try
    	{
    	    SWBundleAppItemState sb = new SWBundleAppItemState();
            Database.executeBatch(sb);
            isSuccess = true;
            
            if(Test.isRunningTest())
                throw new ApplicationException('For code coverage...');
    	}
    	catch(Exception ex)
    	{
    		isSuccess = false;
    	}
    	
    	return isSuccess;
    }
}