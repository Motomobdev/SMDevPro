<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>CD_Avoid_Duplicate_Records_on_Item_Cost</fullName>
        <description>Field Update to Update unique field with External Key</description>
        <field>Avoid_Duplicate_Records__c</field>
        <formula>ExternalKey__c</formula>
        <name>CD Avoid Duplicate Records on Item Cost</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CD Avoid Duplicate Records on Item Cost Details</fullName>
        <actions>
            <name>CD_Avoid_Duplicate_Records_on_Item_Cost</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR(ISCHANGED(ExternalKey__c),ISNEW() )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
