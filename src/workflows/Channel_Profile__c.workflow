<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Type_and_Segment_Combo_ID</fullName>
        <description>Update the Type and Segment Combo ID field with latest picklist combinations.</description>
        <field>Type_Segment_Combo_ID__c</field>
        <formula>Account__r.Id &amp; &quot;.&quot; &amp; TEXT( Type__c ) &amp; &quot;.&quot; &amp; TEXT( Portfolio_Segment__c )</formula>
        <name>Update Type and Segment Combo ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Channel Profile Text and Segment Combo</fullName>
        <actions>
            <name>Update_Type_and_Segment_Combo_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Populate the Text and Portfolio Segment Combo field.</description>
        <formula>Type_Segment_Combo_ID__c &lt;&gt; Account__r.Id &amp; &quot;.&quot; &amp; TEXT( Type__c ) &amp; &quot;.&quot; &amp; TEXT( Portfolio_Segment__c )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
