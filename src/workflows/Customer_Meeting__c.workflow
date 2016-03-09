<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Customer_Meeting_Post_Meeting_Text_Lengt</fullName>
        <description>Computes the length of the post meeting minutes text length.</description>
        <field>Post_Meeting_Notes_Text_Length__c</field>
        <formula>IF( OR(ISNULL(Post_Meeting_Notes__c), ISBLANK(Post_Meeting_Notes__c)), 0, LEN( TRIM(Post_Meeting_Notes__c )) )</formula>
        <name>CustomerMeeting-Post Meeting Text Length</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>First_Post_Meeting_Notes_Entry_Date</fullName>
        <description>Populate the first post meeting notes if it is NOT empty</description>
        <field>First_Post_Meeting_Notes_Entry_Date__c</field>
        <formula>IF(ISNULL(First_Post_Meeting_Notes_Entry_Date__c), TODAY(), First_Post_Meeting_Notes_Entry_Date__c)</formula>
        <name>First Post Meeting Notes Entry Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CustomerMeeting-Post Meeting Text Length</fullName>
        <actions>
            <name>Customer_Meeting_Post_Meeting_Text_Lengt</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>First_Post_Meeting_Notes_Entry_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Computes post meeting minutes text length</description>
        <formula>ISCHANGED( Post_Meeting_Notes__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
