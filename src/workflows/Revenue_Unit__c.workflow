<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Revenue_Unit_Update_Invoice_number</fullName>
        <field>Invoice_Number__c</field>
        <formula>CASESAFEID(Id)</formula>
        <name>Revenue Unit Update Invoice number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Rev Unit Populate Invoice Number</fullName>
        <actions>
            <name>Revenue_Unit_Update_Invoice_number</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Revenue_Unit__c.Invoice_Number__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
