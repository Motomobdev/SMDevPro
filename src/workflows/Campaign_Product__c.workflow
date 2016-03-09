<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Campaign_Product_Update_Program_field</fullName>
        <field>Program__c</field>
        <formula>Project_PMD__r.Program_ID__r.Name</formula>
        <name>Campaign Product Update Program field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Campaign_Project_Field_Update</fullName>
        <field>Campaign_Project__c</field>
        <formula>IF( 
ISBLANK(TRIM(Campaign__r.Campaign_Project__c)), 
Project_PMD__r.Program_ID__r.Name, 
IF( CONTAINS( Campaign__r.Campaign_Project__c, Project_PMD__r.Program_ID__r.Name), 
Campaign__r.Campaign_Project__c, 
Campaign__r.Campaign_Project__c &amp; &quot;+&quot; &amp; Project_PMD__r.Program_ID__r.Name) 
)</formula>
        <name>Campaign Project Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Campaign__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Campaign Update Project Field</fullName>
        <actions>
            <name>Campaign_Product_Update_Program_field</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Campaign_Project_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Campaign.Product_Count__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
