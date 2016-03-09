<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Contract_Expiration_Notice_to_0</fullName>
        <field>OwnerExpirationNotice</field>
        <name>Contract Expiration Notice to 0</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contract_Phase_Last_Change_Date</fullName>
        <field>Last_Phase_Change_Date__c</field>
        <formula>Today()</formula>
        <name>Contract Phase Last Change Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MG_Field_Update</fullName>
        <field>Minimum_Guarantee__c</field>
        <literalValue>1</literalValue>
        <name>MG Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SOP_E_1_Approved</fullName>
        <field>SOP_E_1_Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>SOP E-1 Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SOP_E_1_In_Progress</fullName>
        <field>SOP_E_1_Approval_Status__c</field>
        <literalValue>In Progress</literalValue>
        <name>SOP E-1 In Progress</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SOP_E_1_Not_Started</fullName>
        <field>SOP_E_1_Approval_Status__c</field>
        <literalValue>Not Started</literalValue>
        <name>SOP E-1 Not Started</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SOP_E_1_Rejected</fullName>
        <field>SOP_E_1_Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>SOP E-1 Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_SOP_Submission_Date</fullName>
        <field>SOP_Approval_Submission_Date__c</field>
        <formula>Today()</formula>
        <name>Set SOP Submission Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Contract_Status_Field</fullName>
        <description>Updates Contract Status field to Activated</description>
        <field>Status</field>
        <literalValue>Activated</literalValue>
        <name>Update Contract Status Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>SOP_E_1_EXECUTIVE_SUMMARY</fullName>
        <apiVersion>24.0</apiVersion>
        <description>SOP E-1 Executive Summary email template</description>
        <endpointUrl>https://apps.drawloop.com/package/111</endpointUrl>
        <fields>Drawloop_Next__c</fields>
        <fields>Id</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>cgvr84@motorola.com</integrationUser>
        <name>SOP E-1 EXECUTIVE SUMMARY</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Auto Activate Contracts</fullName>
        <actions>
            <name>Update_Contract_Status_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contract.Status</field>
            <operation>equals</operation>
            <value>Draft</value>
        </criteriaItems>
        <description>This rule auto activates contracts when</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Auto Create Task for Contract</fullName>
        <actions>
            <name>Auto_Created_Task</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Contract.Contract_Type__c</field>
            <operation>notEqual</operation>
            <value>PUM - Prototype Unit Agreement,MNDA - Multiparty NDA,TLA - Tools Licensing Agreement,NDA - Non-Disclosure Agreement</value>
        </criteriaItems>
        <description>Rule automatically creates a task for a new contract record</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Contract%3A Set Expiration Notice to 0 when terminated</fullName>
        <actions>
            <name>Contract_Expiration_Notice_to_0</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contract.Contract_Status__c</field>
            <operation>equals</operation>
            <value>Terminated</value>
        </criteriaItems>
        <description>Clear the expiration notice field for terminated contracts so reminder emails are not sent.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Days in Current Phase Calc</fullName>
        <actions>
            <name>Contract_Phase_Last_Change_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ischanged( Contract_Phase__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>MG Amount-MG</fullName>
        <actions>
            <name>MG_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contract.MG_Amount_Formula__c</field>
            <operation>greaterThan</operation>
            <value>USD 0</value>
        </criteriaItems>
        <description>Minimuim Gurantee field is automatically updated when MG Amount is greater than zero.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>Auto_Created_Task</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>45</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <offsetFromField>Contract.CreatedDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>In Progress</status>
        <subject>Auto Created Task</subject>
    </tasks>
</Workflow>
