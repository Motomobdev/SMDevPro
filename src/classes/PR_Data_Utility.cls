/**
 * @author           Gangadhar Rachakonda
 * @version          1.0 
 * @date             7/30/2014
 * @Status           Developed
 * @description      The main purpose of this class is for performing DML operations in objects 
 */
global with sharing class PR_Data_Utility
{

  /// <OBJECTIVE>
 /// Fetch the particular records from the "Project Ranging" custom object when Next Milestone Date is Past Due 
 /// </OBJECTIVE>
 // <RETURNS>
 //   List<Project_Ranging__c>
 // </RETURNS>
  public static  List<Project_Ranging__c> getAllRangingRecords(List<string> notInStatus)
    {
        return
            [
                SELECT
                    Id
                    ,Owner__c
                    ,Account__c
                    ,Next_Milestone_Date__c
                    ,Status__c
                    ,Owner__r.name
                    ,Account__r.Name
                    ,Project__r.Name 
                    ,Owner__r.ManagerId
                    ,Owner__r.email
                    ,Owner__r.Manager.email                   
                FROM 
                    Project_Ranging__c 
                WHERE 
                    (Next_Milestone_Date__c < Today 
                    OR Next_Milestone_Date__c = null)
                    AND Owner__c != null
                    AND Status__c NOT IN: notInStatus
                ORDER BY 
                    Owner__c ASC NULLS FIRST                                    
            ];
    }    
   
}