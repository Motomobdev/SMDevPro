<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Approval_for_Games_Showcase_Bundle</fullName>
        <description>Auto Approval for Games Showcase Bundle</description>
        <field>Approved_for_inclusion_in_Games_Showcase__c</field>
        <literalValue>Yes</literalValue>
        <name>Approval for Games Showcase Bundle</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_no_for_Games_Showcase_Bundle</fullName>
        <field>Approved_for_inclusion_in_Games_Showcase__c</field>
        <literalValue>No</literalValue>
        <name>Approval (no) for Games Showcase Bundle</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Approval %28no%29 for Games Showcase Bundle</fullName>
        <actions>
            <name>Approval_no_for_Games_Showcase_Bundle</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 and 4) or (2 and 3) or (3 and 4)</booleanFilter>
        <criteriaItems>
            <field>SW_Bundle_Application__c.MMI_Approval_for_Games_Showcase__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>SW_Bundle_Application__c.Partner_Approval_for_Games_Showcase__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>SW_Bundle_Application__c.MMI_Approval_for_Games_Showcase__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>SW_Bundle_Application__c.Partner_Approval_for_Games_Showcase__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Approval for Games Showcase Bundle</fullName>
        <actions>
            <name>Approval_for_Games_Showcase_Bundle</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SW_Bundle_Application__c.MMI_Approval_for_Games_Showcase__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>SW_Bundle_Application__c.Partner_Approval_for_Games_Showcase__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
