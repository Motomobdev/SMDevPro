<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Lock_Outlook_Header</fullName>
        <description>Lock outlook at 12:00am on Sunday(start of week for outlook).</description>
        <field>Outlook_Locked__c</field>
        <literalValue>1</literalValue>
        <name>Lock Outlook Header</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lock_past_retail_outlook</fullName>
        <description>Sets locked flag to true</description>
        <field>Outlook_Locked__c</field>
        <literalValue>1</literalValue>
        <name>Lock past retail outlook</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Lock Retail Outlook Older Than 7 Days</fullName>
        <active>true</active>
        <description>Sets the locked? flag to true for the past retail outlooks (sysdate - created date &gt; 7)</description>
        <formula>AND(Outlook_Locked__c = false,  (NOW()  -  CreatedDate) &gt; 7)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Lock_past_retail_outlook</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Retail_Outlook__c.Week_Start_Date__c</offsetFromField>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Lock Retail Outlook at Start of Week</fullName>
        <active>false</active>
        <description>Sets the locked? flag to true for the retail outlooks (Week Start Date = today)</description>
        <formula>Outlook_Locked__c = false</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Lock_Outlook_Header</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Retail_Outlook__c.Week_Start_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
