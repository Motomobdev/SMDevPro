/***************************
// Created By: Gram Bischof
// Last Modified: 11/12/2013
// Description:
// Controller file for GPSFileUpload.page.
// It loads several csv formatted files 
// from the Google Play Store into custom
// Objects.
//
// Test Class:
// TestGPSFileUpload.cls
****************************/

public class GPSFileUpload{

    public Blob overall_Installs {get;set;}
    public Blob overall_ratings {get;set;}
    
    public Blob app_version_Installs {get;set;}
    public Blob app_version_ratings {get;set;}
    public Blob carrier_Installs {get;set;}
    public Blob carrier_ratings {get;set;}
    public Blob country_Installs {get;set;}
    public Blob country_ratings {get;set;}
    public Blob device_Installs {get;set;}
    public Blob device_ratings {get;set;}
    public Blob language_Installs {get;set;}
    public Blob language_ratings {get;set;}
    public Blob os_version_Installs {get;set;}
    public Blob os_version_ratings {get;set;}
    
    public String overall_Installs_Name {get;set;}
    public String overall_ratings_Name {get;set;}
    
    public String app_version_Installs_Name {get;set;}
    public String app_version_ratings_Name {get;set;}
    public String carrier_Installs_Name {get;set;}
    public String carrier_ratings_Name {get;set;}
    public String country_Installs_Name {get;set;}
    public String country_ratings_Name {get;set;}
    public String device_Installs_Name {get;set;}
    public String device_ratings_Name {get;set;}
    public String language_Installs_Name {get;set;}
    public String language_ratings_Name {get;set;}
    public String os_version_Installs_Name {get;set;}
    public String os_version_ratings_Name {get;set;}
    
    public Blob file {get;set;}
    public String filename {get;set;}
    
    public Boolean insertedOverall {get;set;}
    public Boolean hasApplication {get;set;}
    public Boolean insertAppVersion {get;set;}
    public Boolean insertCarrier {get;set;}
    public Boolean insertCountry {get;set;}
    public Boolean insertDevice {get;set;}
    public Boolean insertLanguage {get;set;}
    public Boolean insertCompleted {get;set;}
    
    public List<GPSappVersion> appVersions {get;set;}
    public Application_Download_Stats__c ParentAppHolder {get;set;}
    public Map<String,Application_Download_Stats__c> nameToApplication_Download_Stats;
    
    
    public class GPSappVersion{
        public Decimal daily_avg_rating {get;set;}
        public Decimal total_avg_rating {get;set;}
        public String dateString {get;set;}
        public Decimal daily_user_installs {get;set;}
        public Decimal total_user_installs {get;set;}
        public Decimal current_user_installs {get;set;}
        public Decimal daily_user_uninstalls {get;set;} 
        public Decimal current_device_installs {get;set;}
        public Decimal daily_device_installs {get;set;} 
        public Decimal daily_device_upgrades {get;set;}
        public Decimal daily_device_uninstalls {get;set;}
        
        public String app_version {get;set;}
        public String carrier {get;set;}
        public String country {get;set;}
        public String device {get;set;}
        public String language {get;set;}
        public String os_version {get;set;}
    }
    
    
    public GPSFileUpload(){
        // alloc containers and objects
        appVersions = new List<GPSappVersion>();
        ParentAppHolder = new Application_Download_Stats__c();
        nameToApplication_Download_Stats = new Map<String,Application_Download_Stats__c>();
        
    	// set bools to false
        insertedOverall = false;
        hasApplication = false;
        insertCompleted = false;
        
    }
    
    public Integer getNumberOfDownloads(){
    	return nameToApplication_Download_Stats.size();
    }
    
    public List<Application_Download_Stats__c> getApplication_Download_Stats(){
        return nameToApplication_Download_Stats.values();
    }
    
    public void assignApplication(){
    	hasApplication = true;    
    }
    
    public PageReference insertOverallStats(){
        try{
            List<Blob> blobs = new List<Blob>();
            blobs.add(overall_Installs);
            blobs.add(overall_ratings);
            processAppVersions(blobs);
            upsert nameToApplication_Download_Stats.values();
            if(nameToApplication_Download_Stats.size() > 0)ParentAppHolder.Overall__c = nameToApplication_Download_Stats.values().get(0).id;
            //nameToApplication_Download_Stats.put(ParentAppHolder.Name,ParentAppHolder);
    		insertedOverall = true;
            return new PageReference('/apex/GPSFileUploadAppVersion');
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,e.getMessage()));
            return null;
        }
    }
    
    public PageReference AddAppVersion(){
        try{
            List<Blob> blobs = new List<Blob>();
            blobs.add(app_version_Installs);
            blobs.add(app_version_ratings);
            processAppVersions(blobs);
            //upsert nameToApplication_Download_Stats.values();
            insertAppVersion = true;
            return new PageReference('/apex/GPSFileUploadCountry');
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,e.getMessage()));
        	return null;
        }
    }
    
    public PageReference AddCarrier(){
        try{
            List<Blob> blobs = new List<Blob>();
            blobs.add(carrier_Installs);
            blobs.add(carrier_ratings);
			processAppVersions(blobs);
            System.debug(nameToApplication_Download_Stats.size());
            //upsert nameToApplication_Download_Stats.values();
            insertCarrier = true;
            return new PageReference('/apex/GPSFileUploadCountry');
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,e.getMessage()));
            return null;
        }
    }
    
    public PageReference AddCountry(){
        try{
            List<Blob> blobs = new List<Blob>();
            blobs.add(country_Installs);
            blobs.add(country_Ratings);
			processAppVersions(blobs);
            //upsert nameToApplication_Download_Stats.values();
            insertCountry = true;
            return new PageReference('/apex/GPSFileUploadDevice');
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,e.getMessage()));
            return null;
        }
    }
    
    public PageReference AddDevice(){
        try{
            List<Blob> blobs = new List<Blob>();
            blobs.add(device_Installs);
            blobs.add(device_Ratings);
			processAppVersions(blobs);
            //upsert nameToApplication_Download_Stats.values();
            insertDevice = true;
            return new PageReference('/apex/GPSFileUploadLanguage');
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,e.getMessage()));
            return null;
        }
    }
    
    public PageReference AddLanguage(){
        try{
            List<Blob> blobs = new List<Blob>();
            blobs.add(language_Installs);
            blobs.add(language_ratings);
			processAppVersions(blobs);
            //upsert nameToApplication_Download_Stats.values();
            insertLanguage = true;
            return new PageReference('/apex/GPSFileUploadOS');
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,e.getMessage()));
            return null;
        }
    }
    
    public PageReference AddFinalStats(){
        try{
            List<Blob> blobs = new List<Blob>();
            blobs.add(os_version_Installs);
            blobs.add(os_version_ratings);
            processAppVersions(blobs);
            
            upsert nameToApplication_Download_Stats.values();
            insertCompleted = true;
            
            // remove files from view state
            overall_Installs = null;
    		overall_ratings = null;
    
        	app_version_Installs = null;
    		app_version_ratings = null;
    		carrier_Installs = null;
    		carrier_ratings = null;
    		country_Installs = null;
    		country_ratings = null;
    		device_Installs = null;
    		device_ratings = null;
    		language_Installs = null;
    		language_ratings = null;
    		os_version_Installs = null;
    		os_version_ratings = null;
            
            return new PageReference('/apex/GPSFileUploadSummary');
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,e.getMessage()));
            return null;
        }
    }
    
    public void processAppVersions(List<Blob> blobs){
    	String modifiedFiles = modifyFiles(getJSONFormatFromList(blobs,4));
        List<String> newblobs = (List<String>)JSON.deserialize(modifiedFiles, List<String>.class);
        List<Blob> modBlobs = new List<Blob>();
        for(String s: newBlobs) modBlobs.add(EncodingUtil.base64Decode(s));
        String csvFiles = getJSONBreakdownfromBlobCSV(getJSONFormatFromList(modBlobs));
        System.debug(csvFiles);
        appVersions = (List<GPSappVersion>)JSON.deserialize(csvFiles, List<GPSappVersion>.class);
        System.debug(appVersions.size());
        for(GPSappVersion app: appVersions){
            if( ParentAppHolder.Application__c == null ){
            	ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Invalid Application ID. Please start over.'));
            	break;
            }
            String uniqueID = getUniqueID(app,String.valueOF(ParentAppHolder.Application__c).substring(0,15));
            Application_Download_Stats__c newADS;
            if(!nameToApplication_Download_Stats.containsKey(uniqueID)) newADS = updateFields(null,app,ParentAppHolder.Application__c,ParentAppHolder.Overall__c);
           	else newADS = updateFields(nameToApplication_Download_Stats.get(uniqueID),app,ParentAppHolder.Application__c,ParentAppHolder.Overall__c);
            nameToApplication_Download_Stats.put(newADS.UniqueID__c,newADS);
        }
    }
    
    public static String modifyFiles(String jsonString){
    	String body = jsonString;
        String url = 'http://sheltered-dawn-3577.herokuapp.com/api/v1.0/removefileLines';
        Map<String,String> headers = new  Map<String,String>();
        headers.put('Content-Type','application/json');
        if(Test.isRunningTest()) return '[]';
        return REST_Utility.callAPI('POST',url,body, headers);
    }
    
    public static String getJSONBreakdownfromBlobCSV(String jsonString){
        String body = jsonString;
        String url = 'http://sheltered-dawn-3577.herokuapp.com/api/v1.0/convertCSVtoJSON';
        Map<String,String> headers = new  Map<String,String>();
        headers.put('Content-Type','application/json');
        if(Test.isRunningTest()) return '[]';
        return REST_Utility.callAPI('POST',url,body, headers);
    }
    
    public static String getJSONFormatFromList(List<Blob> blobs, Integer lines){
        String JSONString = '{"files":';
        JSONString += JSON.serialize(blobs);
        return JSONString + ', "lines":"'+lines+'"}';
    }
    
    public static String getJSONFormatFromList(List<Blob> blobs){
        String JSONString = '{"files":';
        JSONString += JSON.serialize(blobs);
        return JSONString + '}';
    }
    
    public static String getUniqueID(GPSappVersion app,String AppId){
        String uniqueID = app.dateString+AppId;
        if(app.app_version != null) uniqueID += app.app_version;
        if(app.carrier != null) uniqueID += app.carrier;
        if(app.country != null) uniqueID += app.country;
        if(app.language != null) uniqueID += app.language;
        if(app.device != null) uniqueID += app.device;
        if(app.os_version != null) uniqueID += app.os_version;
        return uniqueID;
    }
    
    public static Date convertDate(String dateString){
    	Date converted = Date.parse(dateString.substring(4,6)+'/'+dateString.substring(6,8)+'/'+dateString.substring(0,4));
        return converted;
    }
    
    public static Application_Download_Stats__c updateFields(Application_Download_Stats__c appDownload,GPSappVersion appVersion, ID applicationID, ID overallID){
    	if(appDownload == null) appDownload = new Application_Download_Stats__c(Application__c=applicationID, Overall__c=overallId);
        
        appDownload.UniqueID__c = getUniqueID(appVersion,String.valueOF(appDownload.Application__c).substring(0,15));
        if(appVersion.dateString != null && appVersion.dateString != 'null') appDownload.Date__c = convertDate(appVersion.dateString);
        if(appVersion.current_device_installs != null) appDownload.current_device_installs__c = appVersion.current_device_installs;
        if(appVersion.current_user_installs != null) appDownload.current_user_installs__c = appVersion.current_user_installs;
        if(appVersion.daily_device_uninstalls != null) appDownload.daily_device_uninstalls__c = appVersion.daily_device_uninstalls;
        if(appVersion.daily_device_upgrades != null) appDownload.daily_device_upgrades__c = appVersion.daily_device_upgrades;
        if(appVersion.daily_user_installs != null) appDownload.daily_user_installs__c = appVersion.daily_user_installs;
        if(appVersion.daily_user_uninstalls != null) appDownload.daily_user_uninstalls__c = appVersion.daily_user_uninstalls;
        if(appVersion.total_user_installs != null) appDownload.total_user_installs__c = appVersion.total_user_installs;
        if(appVersion.daily_avg_rating != null && appVersion.daily_avg_rating >= 0) appDownload.daily_avg_rating__c = appVersion.daily_avg_rating;
        if(appVersion.total_avg_rating != null && appVersion.total_avg_rating >= 0) appDownload.total_avg_rating__c = appVersion.total_avg_rating;
        if(appVersion.carrier != null ) appDownload.carrier_Input__c = appVersion.carrier;
        if(appVersion.country != null ) appDownload.Country_Input__c = appVersion.country;
        if(appVersion.language != null) appDownload.Language_Input__c = appVersion.language;
        if(appVersion.device != null) appDownload.Device__c = appVersion.device;
        if(appVersion.os_version != null) appDownload.os_version__c = appVersion.os_version;
        if(appVersion.app_version != null) appDownload.Version__c = appVersion.app_version;
        
        return appDownload;
    }
    
    public static PageReference start(){
    	PageReference p = new PageReference('/apex/GPSFileUpload');
        return p.setRedirect(true);
    }
}