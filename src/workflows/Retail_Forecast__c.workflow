<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Lock_Retail_Forecast</fullName>
        <field>Locked__c</field>
        <literalValue>1</literalValue>
        <name>Lock Retail Forecast</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Unique_Id</fullName>
        <field>Unique_ID__c</field>
        <formula>Account__c &amp; &quot;-&quot; &amp; TEXT(Forecast_Year__c) &amp; &quot;-&quot; &amp; TEXT(Forecast_Quarter__c)</formula>
        <name>Set Unique Id</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Retail_Forecast_Name</fullName>
        <description>Overwrite value enter by user.</description>
        <field>Name</field>
        <formula>Account__r.Name &amp; &quot;-&quot;&amp; TEXT(Forecast_Year__c) &amp; &quot;-&quot; &amp; TEXT(Forecast_Quarter__c)</formula>
        <name>Update Retail Forecast Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Lock Retail Forecast</fullName>
        <active>true</active>
        <description>Lock Retail Forecast after 10 days from 1st day of the quarter</description>
        <formula>Locked__c = false</formula>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Lock_Retail_Forecast</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Retail_Forecast__c.Quarter_First_Day__c</offsetFromField>
            <timeLength>10</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Update Retail Forecast Name</fullName>
        <actions>
            <name>Set_Unique_Id</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Retail_Forecast_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set value to the Forecast name as Account+Year+ Quarter. Overwrite value enter by user.</description>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
