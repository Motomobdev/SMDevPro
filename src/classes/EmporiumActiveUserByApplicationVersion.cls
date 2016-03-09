/**********************************************************/
// Created by: José Elias Araújo
// Created Date: 08/20/2014
// Last Modified: José Elias Araújo
// Last Modified by: 08/20/2014
//
// Description:
// This class represents the information about version of
// a Application saved in Emporum.
// 
// Test Class: 
// 
/**********************************************************/
public class EmporiumActiveUserByApplicationVersion {

    private Active_Users_By_Application_Version__c applicationDownloadStatsVersionCustom;

    public EmporiumActiveUserByApplicationVersion(){
        applicationDownloadStatsVersionCustom = new Active_Users_By_Application_Version__c();
    }
    
    public Integer numberOfDownloads { 
		get{
			return applicationDownloadStatsVersionCustom.Number_of_downloads__c.intValue();
		} 
		set{
			applicationDownloadStatsVersionCustom.Number_of_downloads__c = value;
		}
 	}
    
    public String version { 
		get{
			return applicationDownloadStatsVersionCustom.Version__c ;
		} 
		set{
			applicationDownloadStatsVersionCustom.Version__c  = value;
		}
 	}
    
    public String uniqueID { 
		get{
			return applicationDownloadStatsVersionCustom.UniqueID__c ;
		} 
		set{
			applicationDownloadStatsVersionCustom.UniqueID__c  = value;
		}
 	}    
    
    public Active_Users_By_Application_Version__c getSObject(){
		return applicationDownloadStatsVersionCustom;
	}
}