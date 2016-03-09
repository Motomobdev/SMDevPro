<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Copy_Model_Number_to_Unique_Model_Number</fullName>
        <field>UNIQUE_MODEL_NUMBER__c</field>
        <formula>MODEL_NUMBER__c</formula>
        <name>Copy Model Number to Unique Model Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Ecommerce Models - Unique Model Number</fullName>
        <actions>
            <name>Copy_Model_Number_to_Unique_Model_Number</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>true</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
