<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Playbook_Name</fullName>
        <description>Update Name with Account, Year, Quarter and OKR</description>
        <field>Name</field>
        <formula>MID(IF 
(AND(ISBLANK(Description__c),ISPICKVAL(Type__c,&apos;OKR&apos;)), 
Account__r.Name &amp; &quot; &quot; &amp; TEXT(Period_Year__c ) &amp; &quot; - &quot; &amp; TEXT(Period_Quarter__c) &amp; &quot; - &quot; &amp; OKR__r.Name,
IF(ISBLANK(Description__c), Account__r.Name &amp; &quot; &quot; &amp; TEXT(Period_Year__c ) &amp; &quot; - &quot; &amp; TEXT(Period_Quarter__c), Account__r.Name &amp; &quot; &quot; &amp; TEXT(Period_Year__c ) &amp; &quot; - &quot; &amp; TEXT(Period_Quarter__c) &amp; &quot; - &quot; &amp; Description__c)), 1, 80)</formula>
        <name>Update Playbook Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update Playbook Name</fullName>
        <actions>
            <name>Update_Playbook_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update Playbook Name filed with Account+Year+Quarter</description>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
