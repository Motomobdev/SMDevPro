/**
 * JIRA Importer controller.nin
 * Responsible to encapsulate JIRA_Device business rules.
 * 
 * @since:  2/10/2015
 * @author: Elias Queiroga - eliasq@motorola.com
 */
public class JiraImporter {
    
    public static boolean updateFromJira = true;
	
	//Constants    
    private static String SQA_ISSUES 	 			= '10100';
	private static String DEVICE_ID  	 			= '16711';
    private static String SVN_KIT_NUMBER 			= '14834';
    private static String BLUR_VERSION   			= '14826';
    private static String BUILD_FINGERPRINT 		= '14827';
    private static String ISSUE_RESOLUTION_FINISHED = '11';

 
    /*
     * This method shall be executed before pulling records from Jira tables. It forces 
     * trigger to check if there are invalid devices and swkits in Jira_Device table.
     * If so, this methods forces to update their reference between related objects in salesforce.
	 */
    @TestVisible  
    private void preProcessing(){
    	List<Jira_Device__c> existingJiraDevices = [SELECT ID, Updated_From_SF__c 
                                                    FROM Jira_Device__c WHERE Updated_From_SF__c = false];
		update existingJiraDevices;
    }
    
    
    /**
     * Pull records from Jira tables and then insert or update them to Jira_Device__c table. 
     */
    public void pushJiraDevices(){    
        Map<String, String> deviceIssueMapping = new Map<String, String>();
        System.debug('Starting to push JIRA Devices...');
        try{
            
            updateFromJira = true;
            
            preProcessing();
            
            Map<String, List<Jira_Device__c>> alreadySavedJiraDeviceMapping = new Map<String,  List<Jira_Device__c>>();
    
            //TODO analyse the full scan reason 
            List<Jira_Device__c> processedJiraDevices = [SELECT Issue_ID__c, Device_ID__c FROM Jira_Device__c];
            
            System.debug('51 - Jira_Device__c.size '+processedJiraDevices.size());
            
            List<String> processedIssues = new List<String>();
            for(Jira_Device__C processedIssue : processedJiraDevices){
                processedIssues.add(processedIssue.Issue_ID__c);
                if (alreadySavedJiraDeviceMapping.containsKey(processedIssue.Device_ID__c)){
                    alreadySavedJiraDeviceMapping.get(processedIssue.Device_ID__c).add(processedIssue);
                }else{
                    alreadySavedJiraDeviceMapping.put(processedIssue.Device_ID__c, new List<Jira_Device__C>{processedIssue});
                }
            }
            
            System.debug('63 processedIssues='+processedIssues);
            
            List<JIRA_Issue_prod__c> issues =  [SELECT Issue_ID__c FROM JIRA_Issue_prod__c 
                                                  WHERE Issue_ID__c NOT IN :processedIssues
                                                  AND IssueResolution__c = :ISSUE_RESOLUTION_FINISHED];
            
            System.System.debug('69 JIRA_Issue_prod__c.size'+issues.size());
            
            List<String> issueIDs = new List<String>();
            for(JIRA_Issue_prod__c issue : issues){
                issueIDs.add(issue.Issue_ID__c);
            }
            
            System.debug('76 issueIDs='+issueIDs);
                
            List<JIRA_CustomFieldValue_prod__c> customFieldValues =  [SELECT CustomField_ID__c,Issue_ID__c,StringValue__c 
                                                                      FROM JIRA_CustomFieldValue_prod__c 
                                                                      WHERE Issue_ID__c in :issueIDs
                                                                      ORDER BY CreatedDate ASC];
            
            System.debug('83 - JIRA_CustomFieldValue_prod__c.size '+customFieldValues.size());
            
            Map<String, Jira_Device__c> JiraDeviceMapping = new Map<String, Jira_Device__c>();
            Map<String, List<Jira_Device__c>> finalJiraDeviceMapping = new Map<String, List<Jira_Device__c>>();
            
            for(JIRA_CustomFieldValue_prod__c customFieldValue : customFieldValues){
                String issueID = customFieldValue.Issue_ID__c;
                
                Jira_Device__c jiraDevice;
                Boolean alreadyInList = JiraDeviceMapping.containsKey(issueID);    
                
                if (alreadyInList){
                    jiraDevice = JiraDeviceMapping.get(issueID);                
                }else{
                    jiraDevice = new Jira_Device__c();
                }
                
                String stringValue = customFieldValue.StringValue__c;
                String customFieldID = customFieldValue.CustomField_ID__c;
                
                System.debug('103 stringValue='+stringValue+' customFieldID='+customFieldID);
                jiraDevice.Issue_ID__c = issueID;
                if (customFieldID.equals(DEVICE_ID)){
                    jiraDevice.Device_ID__c = stringValue;
                }else if (customFieldID.equals(SVN_KIT_NUMBER)){
                    jiraDevice.SW_KIT_ID__c = stringValue;
                }else if (customFieldID.equals(BLUR_VERSION)){
                    jiraDevice.Blur_Version__c = stringValue;
                }else if (customFieldID.equals(BUILD_FINGERPRINT)){
                    jiraDevice.Build_Fingerprint__c = stringValue;                
                }                       
                
                if (!alreadyInList){
                    JiraDeviceMapping.put(issueID, jiraDevice);
                }
                System.debug('118 jiraDevice='+jiraDevice);
                
            }  
            
			List<Jira_Device__c> jiraDeviceList = new List<Jira_Device__c>();
            
            //Adding in the final list only jira devices with valid SVN values.
            for (Jira_Device__c jiraDeviceValidSVN : JiraDeviceMapping.values()){                
                if (jiraDeviceValidSVN.SW_KIT_ID__c != null){
                    String SWKit = jiraDeviceValidSVN.SW_KIT_ID__c;
                	jiraDeviceValidSVN.SW_KIT_ID__c = validateSWkit(SWKit);  
                    
                    //If the SVN is valid, the jira device is added in the list.
                    if (jiraDeviceValidSVN.SW_KIT_ID__c != null){
                        jiraDeviceValidSVN.UniqueID__c = jiraDeviceValidSVN.Issue_ID__c + SWKit;
	                    jiraDeviceList.add(jiraDeviceValidSVN);
                                                
                        processedIssues.add(jiraDeviceValidSVN.Issue_ID__c);
                    }
                }
            }
        
            //This block populates a mapping that defines which issue is pointing to the latest deviceID.
            //So, it contains the issue IDs of data already saved in DB and new data to be inserted. Then,
            //we could know if the new record id newer than data already saved. If so, it will be inserted.
            //Just to remember that this behavior is only for records where they are pointing to save DeviceID.
            List<JIRA_CustomFieldValue_prod__c> customSortedByCreatedDate =  [SELECT CustomField_ID__c,Issue_ID__c,StringValue__c 
                                                                              FROM JIRA_CustomFieldValue_prod__c 
                                                                              WHERE Issue_ID__c in :processedIssues
                                                                              ORDER BY CreatedDate ASC];
            
            for(JIRA_CustomFieldValue_prod__c customFieldValue : customSortedByCreatedDate){
                String issueID = customFieldValue.Issue_ID__c;
                String customFieldID = customFieldValue.CustomField_ID__c;
                String stringValue = customFieldValue.StringValue__c;
				if (customFieldID.equals(DEVICE_ID)){
                    deviceIssueMapping.put(stringValue, issueID);
                }                
            }
        
        
            List<Jira_Device__c> jiraDeviceToBeInserted = new List<Jira_Device__c>();
            
            System.debug('jiraDeviceList='+jiraDeviceList);
            
            //Converting a issue mapping to a deviceID mapping
            //This map will be used to avoid two records point to the same deviceID.
            for (Jira_Device__c jiraDeviceToAddMapping : jiraDeviceList){
				System.debug('166 Device_ID='+jiraDeviceToAddMapping.Device_ID__c);
                System.debug('finalJiraDeviceMapping.containsKey'+finalJiraDeviceMapping.containsKey(JiraDeviceToAddMapping.Device_ID__c));
                
            	if (finalJiraDeviceMapping.containsKey(JiraDeviceToAddMapping.Device_ID__c)){
                	finalJiraDeviceMapping.get(JiraDeviceToAddMapping.Device_ID__c).add(jiraDeviceToAddMapping);
                }else{
                    finalJiraDeviceMapping.put(JiraDeviceToAddMapping.Device_ID__c, new List<Jira_Device__C>{jiraDeviceToAddMapping});
                }
            }
            
            System.debug('176 finalJiraDeviceMapping='+finalJiraDeviceMapping);
            System.debug('177 finalJiraDeviceMapping.size='+finalJiraDeviceMapping.size());

            for (List<Jira_Device__c> JiraDeviceFromList : finalJiraDeviceMapping.values()){
                System.debug('180 processing JiraDeviceFromList='+JiraDeviceFromList);
                
                System.debug('182 SWKit is not null');
                
                for (Jira_Device__c JiraDeviceDuplicatedElement : JiraDeviceFromList){
                    String issue = deviceIssueMapping.get(JiraDeviceDuplicatedElement.Device_ID__c);
                    if (JiraDeviceDuplicatedElement.Issue_ID__c.equals(issue)){
                        jiraDeviceToBeInserted.add(JiraDeviceDuplicatedElement);
                        break;
                    }
                }
            }
    
            System.debug('193 jiraDeviceToBeInserted='+jiraDeviceToBeInserted);
            
            insert jiraDeviceToBeInserted;
            
        }catch(Exception e){
            System.debug('Exception on JiraImporter class '+BOMUtils.getStackTrace(e));
        }
    }
    
       
    /*
	 * Responsible by update the result in Device__c, SW_Kit__c and Jira_Device__c objects.
	 */
    public void updateDevices(){
        try{
            updateFromJira = false;
            List<Jira_Device__c> jiraDevices = [SELECT ID, Device_ID__c, Device__c, SW_Kit__c, 
                                                SW_KIT_ID__c, Blur_Version__c, Build_Fingerprint__c,
                                                Updated_From_SF__c FROM Jira_Device__c 
                                                WHERE SW_Kit__c != null AND Updated_From_SF__c = false];
                
            System.debug('214 - Jira_Device__c.size '+jiraDevices.size());
            
            List<Device__c> devices = getDevices(jiraDevices);
            List<SW_Kit__c> swKits  = getSWKits(jiraDevices);
             
            for (Jira_Device__c jiraDevice : jiraDevices){
                for (Device__c device : devices){   
                    if (jiraDevice.Device_ID__c.equals(device.Device_ID__c)){
                        device.SW_Kit__c = jiraDevice.SW_Kit__c;
                        device.BLUR_Version_String__c = jiraDevice.Blur_Version__c;
                        device.Build_Number__c = jiraDevice.Build_Fingerprint__c;                    
                        jiraDevice.Updated_From_SF__c = true;
                        
                        break;
                    }
                }
                
                for (SW_Kit__c swKit : swKits){
                    if (jiraDevice.SW_KIT_ID__c.equals(swKit.Name)){ 
                        swKit.BLUR_Version_String__c = jiraDevice.Blur_Version__c;
                        swKit.Build_Fingerprint__c = jiraDevice.Build_Fingerprint__c;                        
                        jiraDevice.Updated_From_SF__c = true;
                         
                        break;    
                    }
                } 
            }
            
            update devices;
            update swKits;        
            upsert jiraDevices; 
        }catch(Exception e){
            System.System.debug('Exception on JiraImporter class '+BOMUtils.getStackTrace(e));
        }            
        
    }
    
    @TestVisible     
    private List<Device__c> getDevices(List<Jira_Device__c> devicesFromJira){
        List<String> deviceIds = new List<String>();    
        for (Jira_Device__c jiraDevice : devicesFromJira){
            if (jiraDevice.Device_ID__c != null && jiraDevice.Device__c != null){
	            deviceIds.add(jiraDevice.Device_ID__c);
            }
        }
        
        List<Device__c> devices = [select ID, Device_ID__c, SW_Kit__c, BLUR_Version__c, BLUR_Version_String__c, Build_Number__c from Device__c where Device_ID__c in :deviceIds];
        
        return devices;
    }
    
    /*
     * Returns a List of SW_Kit__c based on SW_KIT Ids.
     */
    @TestVisible 
    private List<SW_Kit__c> getSWKits(List<Jira_Device__c> swkitsFromJira){
        List<String> swkitIds = new List<String>();    
        for (Jira_Device__c jiraDevice : swkitsFromJira){
            swkitIds.add(jiraDevice.SW_KIT_ID__c);
        }
        
        List<SW_Kit__c> swKits = [select ID, Name, BLUR_Version_String__c, Build_Fingerprint__c from SW_Kit__c where Name in :swkitIds];
        
        return swKits;
    }
    
    /*
     * This method validates a SWKit number, so it receives a SWKit number and
     * verifies if it follows the pattern. It returns the SVN validated if
     * it is right or null otherwise.
     * 
     * Other validations is executed such as removing a comma in the end of
     * value passed. Sometimes the SWKit number is "SVN00010," so the comma
     * or blank space are removed.
     */
    @TestVisible 
    private String validateSWkit(String swKit){
        if (swKit != null){
            swKit = swKit.replaceAll(',', '');
	        Pattern svnPattern = Pattern.compile('SVN([a-z]|[A-Z]|[0-9])*');
			Matcher svnMatcher = svnPattern.matcher(swKit);
            if (svnMatcher.matches()){
                return swKit.replaceAll(' ', '');
            }else{
                return null;
            }
         }else{
            return null;
         }
    }
}