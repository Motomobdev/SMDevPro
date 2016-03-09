<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Change_Phase_back_to_0</fullName>
        <field>Payment_Phase__c</field>
        <literalValue>0 - Cancelled</literalValue>
        <name>Change Phase back to &quot;0&quot;</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Revert phase back to %220%22%2C if status is cancelled</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Payment__c.Payment_Phase__c</field>
            <operation>equals</operation>
            <value>0 - Cancelled</value>
        </criteriaItems>
        <description>Revert phase back to &quot;0&quot;, if status is &quot;Cancelled&quot;</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Revert phase back to %220%22%2C if status is cancelled1</fullName>
        <actions>
            <name>Change_Phase_back_to_0</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Payment__c.Payment_Status__c</field>
            <operation>equals</operation>
            <value>CANCELLED</value>
        </criteriaItems>
        <description>Revert phase back to &quot;0&quot;, if status is &quot;Cancelled&quot;</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
