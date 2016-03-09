/**********************************************************/
// Created by: José Elias Araújo
// Created Date: 28/02/2014
// Last Modified: José Elias Araújo
// Last Modified by: 08/22/2014
//
// Description:
// This class represents a record retrivied from Emporium.
// 
// Test Class: 
// 
/**********************************************************/
public class EmporiumApplicationDownloadStats{
    private Application application;
    private MotorolaCoreDirectory uploadedBy;
    private Application_Download_Stats__c sObjectApplicationStats;
    private List<EmporiumActiveUserByApplicationVersion> activeUsersByVersion;

    public void addActiveUsersByVersion(EmporiumActiveUserByApplicationVersion activeUserByVersion){
        activeUserByVersion.uniqueID = getUniqueID() + '-' + activeUserByVersion.version;
        activeUsersByVersion.add(activeUserByVersion);
    }
    
    public List<EmporiumActiveUserByApplicationVersion> getActiveUsersByVersion(){
        return activeUsersByVersion;
    }
    
    // Description:  
	// Constructor method.
	//
	// Input: none
	//
	// Returns: none
    public EmporiumApplicationDownloadStats(){
        sObjectApplicationStats = new Application_Download_Stats__c();
        activeUsersByVersion = new List<EmporiumActiveUserByApplicationVersion>();
    }        

    // Description:  
	// Constructor method.
	//
	// Input: ApplicationStats (Custom object that represents 
    //                          a record on Emporium)
	//
	// Returns: none
    public EmporiumApplicationDownloadStats(Application_Download_Stats__c ApplicationStats){
        sObjectApplicationStats = ApplicationStats;
    }

    // Description:  
	// Gets the package name of application
	//
	// Input: none
	//
	// Returns: String of package name    
    public String getPackageName(){
    	return sObjectApplicationStats.Package_Name__c;
    }

    // Description:  
	// Sets the package name of application
	//
	// Input: packageName (Package name of application)
	//
	// Returns: none
    public void setPackageName(String packageName){
   		sObjectApplicationStats.Package_Name__c = packageName;
    }   

    // Description:  
	// Gets the unique identification of application
	//
	// Input: none
	//
	// Returns: String of unique identification    
    public String getUniqueID(){
		return sObjectApplicationStats.UniqueID__c;         
    }

    // Description:  
	// Sets the unique identification of application
	//
	// Input: uniqueID (Unique identificationof application)
	//
	// Returns: none    
    public void setUniqueID(String uniqueID){
        sObjectApplicationStats.UniqueID__c = uniqueID;
    }    

    // Description:  
	// Sets the version of application
	//
	// Input: version (version of application)
	//
	// Returns: none      
    public void setVersion(String version){
        sObjectApplicationStats.version__c = version;
    }

    // Description:  
	// Gets the version of application
	//
	// Input: none
	//
	// Returns: String of application version
    public String getVersion(){
        return sObjectApplicationStats.version__c;
    }
    
    // Description:  
	// Sets the number of downloaded.
	//
	// Input: numberOfDownloads (number of downloads)
	//
	// Returns: none      
    public void setNumberOfDownloads(Integer numberOfDownloads){
  		sObjectApplicationStats.Number_of_downloads__c  = numberOfDownloads;
    }

    // Description:  
	// Gets the number of downloads.
	//
	// Input: none
	//
	// Returns: Integer of application version.
    public Integer getNumberOfDownloads(){
		return sObjectApplicationStats.Number_of_downloads__c.intValue();
    }

    // Description:  
	// Sets the date of last download.
	//
	// Input: dateLastDownloaded (date of last download)
	//
	// Returns: none       
    public void setDateLastDownloaded(Date dateLastDownloaded){
        sObjectApplicationStats.Date_last_download__c = dateLastDownloaded;
    }
    
    // Description:  
	// Sets the date when application has been uploaded.
	//
	// Input: uploadedOn (date when application has been uploaded)
	//
	// Returns: none       
    public void setUploadedOn(Date uploadedOn){
        sObjectApplicationStats.Uploaded_on__c = uploadedOn;
    }
    
    // Description:  
	// Gets the date when application has been uploaded
	//
	// Input: none
	//
	// Returns: Date when application has been uploaded
    public Date getUploadedOn(){
        return sObjectApplicationStats.Uploaded_on__c;
    }
    
    // Description:  
	// Gets the date of last download.
	//
	// Input: none
	//
	// Returns: Date of last download.
    public Date getDateLastDownloaded(){
        return sObjectApplicationStats.Date_last_download__c;
    }
        
    // Description:  
	// This method receive a instance of Application_Download_Stats__c
    // in order to refresh all information with new values.
	//
	// Input: ApplicationStats (Custom object to be used as data source)
	//
	// Returns: none.
    public void refresh(Application_Download_Stats__c ApplicationStats){
        sObjectApplicationStats = ApplicationStats;
        sObjectApplicationStats.Application__c = application.getSObject().ID; 
        
        if (this.uploadedBy != null){
	        sObjectApplicationStats.Uploaded_by__c = uploadedBy.getSObject().ID;
        }else{
        	sObjectApplicationStats.Uploaded_by__c = null;  
        }        
    }
    
    // Description:  
	// Gets the reference of Application that
    // represents an application registered on Emporium.
	//
	// Input: none
	//
	// Returns: Application registered in emporium
    public Application getApplication(){
        return this.application;
    }

    // Description:  
	// Sets a reference of Application.
	//
	// Input: application (Application registered on Emporium)
	//
	// Returns: none      
    public void setApplication(Application application){
        this.application = application;
        sObjectApplicationStats.Application__c = application.getSObject().ID; 
    }

    // Description:  
	// Gets the reference of MotorolaCoreDirectory that
    // constains information about who uploaded the application
    // on Emporium.
	//
	// Input: none
	//
	// Returns: MotorolaCoreDirectory of responsible for uploading app.
    public MotorolaCoreDirectory getUploadedBy(){
        return this.uploadedBy;
    }

    // Description:  
	// Sets the reference of MotorolaCoreDirectory that
    // constains information about who uploaded the application
    // on Emporium.
	//
	// Input: uploadedBy (Responsible for uploading the app on Emporium)
	//
	// Returns: none
    public void setUploadedBy(MotorolaCoreDirectory uploadedBy){
        this.uploadedBy = uploadedBy;
        
        if (uploadedBy != null){
	        sObjectApplicationStats.Uploaded_by__c = uploadedBy.getSObject().ID;
        }else{
        	sObjectApplicationStats.Uploaded_by__c = null;  
        }
    }    
           
    // Description:  
    // Build a custom object from a instance of
    // EmporiumApplication.
    //
    // Input: List<EmporiumApplication> of applications to be stored.
    //
    // Returns: none
	//     
    public Application_Download_Stats__c getSObject(){
 		return sObjectApplicationStats;
    }
    
    // Description:  
	// Sets the category of application
	//
	// Input: category (category of application)
	//
	// Returns: none     
    public void setCategory(String category){
        sObjectApplicationStats.category__c = category;
    }

    // Description:  
	// Gets the category of application
	//
	// Input: none
	//
	// Returns: String of application category
    public String getCategory(){
        return sObjectApplicationStats.category__c;
    }
    
    // Description:  
	// Sets the Name of application
	//
	// Input: NAme (Name of application)
	//
	// Returns: none     
    public void setName(String name){
        sObjectApplicationStats.Name = name;
    }

    // Description:  
	// Gets the name of application
	//
	// Input: none
	//
	// Returns: String of application name
    public String getName(){
        return sObjectApplicationStats.Name;
    }
    
}