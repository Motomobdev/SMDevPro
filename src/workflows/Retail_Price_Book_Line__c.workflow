<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Retail_Price_Book_Line_Ext_ID</fullName>
        <field>External_ID__c</field>
        <formula>Retail_Price_Book__r.External_ID__c &amp; &quot;-&quot; &amp; Product__c &amp;&quot;-&quot;&amp; Account__c &amp; &quot;-&quot; &amp; Text(Carrier__c)</formula>
        <name>Retail Price Book Line Ext ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Retail Price Book Line Ext ID</fullName>
        <actions>
            <name>Retail_Price_Book_Line_Ext_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Retail_Price_Book_Line__c.External_ID__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Generate value for external ID if value was not provided: Product-Account-Carrier</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
