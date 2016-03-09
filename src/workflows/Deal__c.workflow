<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Deal_Rejection_Notification</fullName>
        <description>Deal Rejection Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Finance_Director__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Sales_GM__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Sales_VP__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Deal_Templates/Deal_Rejection_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>Deal_Approved</fullName>
        <description>Deal approval by all parties changes the status to &quot;Approved&quot;</description>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Deal Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Deal_New</fullName>
        <field>Status__c</field>
        <literalValue>New</literalValue>
        <name>Deal New</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Deal_Rejected</fullName>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Deal Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Deal_Rejection_Counter</fullName>
        <description>Increments deal rejection counter by 1</description>
        <field>Rejection_Counter__c</field>
        <formula>IF( 
ISNULL(  Rejection_Counter__c  ), 
1, 
Rejection_Counter__c + 1 
)</formula>
        <name>Deal Rejection Counter</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Deal_Submission</fullName>
        <description>Deal submission for approval changes deal status to &quot;Submitted for Approval&quot;</description>
        <field>Status__c</field>
        <literalValue>Submitted For Approval</literalValue>
        <name>Deal Submission</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Deal_Submit_Counter</fullName>
        <field>Submit_Counter__c</field>
        <formula>IF (ISNULL(Submit_Counter__c), 1, Submit_Counter__c + 1)</formula>
        <name>Deal Submit Counter</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
