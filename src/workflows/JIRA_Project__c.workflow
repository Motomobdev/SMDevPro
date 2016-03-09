<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Privacy_PDD_Completion_Date</fullName>
        <description>Add PDD Completed Date when Status reaches 100%</description>
        <field>PDD_Completed_Date1__c</field>
        <formula>today()</formula>
        <name>Privacy - PDD Completion Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SW_Projects_Lead_Name_Update_2</fullName>
        <description>to update the hidden fields, for POR chart generation in Tableau</description>
        <field>sw_product_manager_text__c</field>
        <formula>SW_Product_Manager__r.DisplayLastName__c</formula>
        <name>SW Projects Lead Name Update 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SW_Projects_Lead_Name_Update_3</fullName>
        <description>to update the hidden fields, for POR chart generation in Tableau</description>
        <field>tech_team_lead_text__c</field>
        <formula>SW_Team_Tech_Lead__r.DisplayLastName__c</formula>
        <name>SW Projects Lead Name Update 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Privacy - PDD Completed Date</fullName>
        <actions>
            <name>Privacy_PDD_Completion_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>JIRA_Project__c.PDD_Status1__c</field>
            <operation>equals</operation>
            <value>100 %</value>
        </criteriaItems>
        <description>Add PDD Completed Date when PDD Status reaches 100%</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SW Projects Lead Name Update</fullName>
        <actions>
            <name>SW_Projects_Lead_Name_Update_2</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SW_Projects_Lead_Name_Update_3</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>to update the hidden fields, for POR chart generation in Tableau</description>
        <formula>1=1</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
