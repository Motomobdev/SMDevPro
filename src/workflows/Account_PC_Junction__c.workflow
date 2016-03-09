<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_PC_in_Account_Record</fullName>
        <field>Assigned_PC_KW__c</field>
        <formula>Political_Consultants__r.Name</formula>
        <name>Update PC in Account Record</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Legislative_Offices__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Update PC in Account Record</fullName>
        <actions>
            <name>Update_PC_in_Account_Record</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>1=1</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
