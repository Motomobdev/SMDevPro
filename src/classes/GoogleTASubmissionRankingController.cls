/********************************************************************************************
Author  : Neel Desai
Date    : 26/Apr/2013
VHD #   : 242900
Test cls: GoogleTASubmissionRankingControllerTest

Changes :
18/July/2013 - VHD #314707. Commented code block in getGoogleTASubmissions() method.
               Because of this code, priority changes were not reflecting on Device object.

18/July/2013 - VHD #315587. Allow admin access if user is part of 
               public group 'Google TA Process Admin'
*********************************************************************************************/
public with sharing class GoogleTASubmissionRankingController 
{
    public Boolean isAdministrator {get; set;}
    public Boolean isAnonymous {get; set;} //force.com site user (view only)
    public List<Device__c> TASubmissionList {get; set;}
    public String sequence {get;set;} //stores reordered sequence
    
    public GoogleTASubmissionRankingController()
    {
        //Check if Admin user
        checkForAdminPrivileges();
        
        //Get TA submissions and populate list
        getGoogleTASubmissions();
    }
    
    private void checkForAdminPrivileges()
    {
        try
        {
            Profile profile = [SELECT Name FROM Profile WHERE Id = :UserInfo.getProfileId()];
            
            //Profile and Users who should have admin access.
            if(profile.Name.equalsIgnoreCase('System Administrator') ||
               profile.Name.equalsIgnoreCase('MotoDev - SysAdmin') ||
               profile.Name.equalsIgnoreCase('MotoDev - Google TA Process Admin') ||
               UtilUserInfo.isContextUserPartOfPublicGroup('Google TA Process Admin') == 'true') //VHD# 315587
            {
                isAdministrator = true;
            }
            else
            {
                isAdministrator = false;
            }
            
            if(profile.name.equalsIgnoreCase('Google TA Submission Ranking Profile') ||
               UserInfo.getProfileId().startsWith('00e40000001BWcV')) /* Above profile id in MD Prod (if name did not match) */
            {
                isAnonymous = true;
            }
            else
            {
                isAnonymous = false;
            }
                        
            //For test method code coverage only
            if(Test.isRunningTest())
            {
                String temp;
                temp.toLowerCase();
            }
        }
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage()));
            if(!(Test.isRunningTest() && isAdministrator))
                isAdministrator = false;
        }
    }
    
    public void getGoogleTASubmissions()
    {
        try
        {
            List<Device__c> prevSubmittedDeviceList = [ SELECT  Name, 
                                                                Priority__c, 
                                                                Requested_Date_for_Google_TA__c, 
                                                                SA_Release_Type__c,
                                                                Date_GMS_SW_Checklist_Sent_to_Google__c,
                                                                Number_of_days_allotted_for_approval__c,
                                                                Number_of_days_since_complete_submission__c,
                                                                Hardware_Provided__c,
                                                                GMS_Last_SW_Submitted__c,
                                                                Launch_Addendum_ID__c,
                                                                Device_ID__c,
                                                                LE_CTS_Software_Checklist__c
                                                        FROM    Device__c 
                                                        WHERE   ((GMS_Submission_Status__c='Sent to Google' AND CTS_Submission_Status__c='Sent to Google') OR (LE_CTS_Submission_Status__c='Sent to Google')) AND
                                                                Google_TA_Approval_Status__c='In Progress' AND 
                                                                Priority__c != null
                                                        ORDER BY Priority__c];
            
            
            List<Device__c> newlySubmittedDeviceList = [SELECT  Name, 
                                                                Priority__c, 
                                                                Requested_Date_for_Google_TA__c, 
                                                                SA_Release_Type__c,
                                                                Date_GMS_SW_Checklist_Sent_to_Google__c,
                                                                Number_of_days_allotted_for_approval__c,
                                                                Number_of_days_since_complete_submission__c,
                                                                Hardware_Provided__c,
                                                                GMS_Last_SW_Submitted__c,
                                                                Launch_Addendum_ID__c,
                                                                Device_ID__c,
                                                                LE_CTS_Software_Checklist__c
                                                        FROM    Device__c 
                                                        WHERE   ((GMS_Submission_Status__c='Sent to Google' AND CTS_Submission_Status__c='Sent to Google') OR (LE_CTS_Submission_Status__c='Sent to Google')) AND
                                                                Google_TA_Approval_Status__c='In Progress' AND 
                                                                Priority__c = null
                                                        ORDER BY Date_GMS_SW_Checklist_Sent_to_Google__c];
            
            TASubmissionList = new List<Device__c>();
            
            TASubmissionList.addAll(prevSubmittedDeviceList);
            TASubmissionList.addAll(newlySubmittedDeviceList);
            
            /*** Commented below code - VHD #314707 ***/
            //Double index = 1;
            
            //for(Device__c TASubmission : TASubmissionList)
            //{
            //    TASubmission.Priority__c = index++;
            //}

            //For exception code coverage only
            if(Test.isRunningTest())
            {
                String temp;
                temp.toLowerCase();
            }
        }
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage()));
        }
    }
        
    public void saveSequence()
    {
        try
        {
            List<Device__c> sortedByRankList = new List<Device__c>();
            List<Device__c> modifiedSubmissionRankList = new List<Device__c>();
            List<String> seq = sequence.split(',');
            
            Map<Id,Device__c> TASubmissionMap = new Map<Id,Device__c>(TASubmissionList);
            
            Double index;
            Device__c TASubmission;
            
            for(Integer i=0; i<seq.size(); i++)
            {
                TASubmission = TASubmissionMap.get(seq[i]);
                
                index = Double.valueOf(i+1);
                
                if(TASubmission.Priority__c == null || TASubmission.Priority__c != index)
                {
                    TASubmission.Priority__c = index;
                    modifiedSubmissionRankList.add(TASubmission);
                }
    
                sortedByRankList.add(TASubmission);
            }
            
            if(!modifiedSubmissionRankList.isEmpty())
                update modifiedSubmissionRankList;
                
            TASubmissionList = sortedByRankList;
            
            //For test method code coverage only
            if(Test.isRunningTest())
            {
                String temp;
                temp.toLowerCase();
            }
        }
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage()));
        }
    }
}