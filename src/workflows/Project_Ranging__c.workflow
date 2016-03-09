<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>New_ranging_record_created</fullName>
        <description>New ranging record created</description>
        <protected>false</protected>
        <recipients>
            <field>Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/New_Ranging_Record_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>Ranging_Clear_Ranged_Date</fullName>
        <field>Ranged_Date__c</field>
        <name>Ranging - Clear Ranged Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ranging_Combine_account_and_project_ID</fullName>
        <field>Account_Project_Combo__c</field>
        <formula>CASESAFEID(Account__c) + CASESAFEID(Project__c)</formula>
        <name>Ranging - Combine account and project ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Ranged_Date</fullName>
        <field>Ranged_Date__c</field>
        <formula>TODAY()</formula>
        <name>Update Ranged Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Email owner when new ranging record is created</fullName>
        <actions>
            <name>New_ranging_record_created</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Project_Ranging__c.CreatedDate</field>
            <operation>equals</operation>
            <value>TODAY</value>
        </criteriaItems>
        <description>Email owner when new ranging record is created</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Ranging - Clear Ranged Date</fullName>
        <actions>
            <name>Ranging_Clear_Ranged_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Clears ranged date when the status is NOT Ranged</description>
        <formula>AND(NOT(ISNULL(Ranged_Date__c)), NOT(ISPICKVAL(Status__c, &apos;Ranged&apos;)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Ranging - Combine account and project IDs</fullName>
        <actions>
            <name>Ranging_Combine_account_and_project_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Prevents the user from creating duplicate ranging records. Account and Project ID combo makes a record unique</description>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Ranged Date</fullName>
        <actions>
            <name>Update_Ranged_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates the ranged date field with today&apos;s date when the status changes to &quot;Ranged&quot;</description>
        <formula>AND( ISCHANGED(Status__c), ISPICKVAL(Status__c, &apos;Ranged&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
