/**
 * JIRA_Device Unit test.
 * 
 * @since:  3/17/2015
 * @author: Jimens Lima - jimens@motorola.com
 */
@isTest
public class JIRADeviceTest {

    public static testMethod void testJiraDevice(){
        
        Device__c dev = new Device__c(Device_ID__c='987654',Name='JiraDEV');
        SW_Kit__c kit = new SW_Kit__c(Name='SVNKIT_123');
        JIRA_Device__c jiraDev = new JIRA_Device__c(Device_ID__c='9988',SW_KIT_ID__c='SVNKIT_123');
        
        insert dev;
        insert kit;
        insert jiraDev;
    }
}