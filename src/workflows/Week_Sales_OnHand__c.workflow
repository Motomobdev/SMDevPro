<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Unique_WSOH_Segment_ID_Field</fullName>
        <description>Updates the unique WSOH Portfolio Segment field with latest value.</description>
        <field>WSOH_already_exists_for_this_Segment__c</field>
        <formula>CASESAFEID(Account__c) &amp; &quot;.&quot; &amp; TEXT( Week_Sales_OnHand_Segment__c ) &amp; &quot;.&quot; &amp; TEXT( Device_Type__c )</formula>
        <name>Update Unique WSOH Segment ID Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update Unique WSOH Segment ID</fullName>
        <actions>
            <name>Update_Unique_WSOH_Segment_ID_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update the unique field for WSOH Portfolio Segment</description>
        <formula>WSOH_already_exists_for_this_Segment__c &lt;&gt;  CASESAFEID(Account__c) &amp; &quot;.&quot; &amp;  TEXT( Week_Sales_OnHand_Segment__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
