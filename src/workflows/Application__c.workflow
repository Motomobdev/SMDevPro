<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notification_of_new_App</fullName>
        <description>Notification of new App</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/New_App_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>Autocheck_Top10ComptApp</fullName>
        <field>Top_10_Competitive_App__c</field>
        <literalValue>1</literalValue>
        <name>Autocheck Top10ComptApp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Royalty_Current_and_Royalty_High</fullName>
        <field>Royalty_Current__c</field>
        <formula>ABS(Royalty_High__c)</formula>
        <name>Royalty Current and Royalty High</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Royalty_Free_Reset_Royalty_Current</fullName>
        <description>&quot;Royalty Free&quot; Royalty Payment Attribute resets royalty current field to zero</description>
        <field>Royalty_Current__c</field>
        <formula>0</formula>
        <name>Royalty Free - Reset Royalty Current</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Royalty_Free_Reset_Royalty_High</fullName>
        <description>&quot;Royalty Free&quot; Royalty Payment Attribute resets royalty high field to zero</description>
        <field>Royalty_High__c</field>
        <formula>0</formula>
        <name>Royalty Free - Reset Royalty High</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Royalty_Free_Reset_Royalty_Low</fullName>
        <description>&quot;Royalty Free&quot; Royalty Payment Attribute resets royalty low field to zero</description>
        <field>Royalty_Low__c</field>
        <formula>0</formula>
        <name>Royalty Free - Reset Royalty Low</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>AutoCheck Top10 Competitive App Box</fullName>
        <actions>
            <name>Autocheck_Top10ComptApp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Application__c.Count_of_ComptApps__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>New App Notification to Acct Owner</fullName>
        <actions>
            <name>Notification_of_new_App</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Notification to Account Owner whenever a new app is created</description>
        <formula>$User.Id &lt;&gt; Account__r.OwnerId</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Payment Type Royalty Free - Resets Royalty Fields</fullName>
        <actions>
            <name>Royalty_Free_Reset_Royalty_Current</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Royalty_Free_Reset_Royalty_High</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Royalty_Free_Reset_Royalty_Low</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Application__c.Royalty_Payment_Attribute__c</field>
            <operation>equals</operation>
            <value>Royalty Free</value>
        </criteriaItems>
        <description>Royal payment type of &quot;Royalty Free&quot; resets royalty current, royalty high and royalty low fields to zero.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Royalty Current and Royalty High</fullName>
        <actions>
            <name>Royalty_Current_and_Royalty_High</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Application__c.Royalty_Current__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>If the Royalty current field is blank then the value is taken from the royalty high field.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
