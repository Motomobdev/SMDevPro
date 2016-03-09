<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Business_Unit</fullName>
        <description>Copies opportunity product&apos;s business unit to business unit field</description>
        <field>Business_Unit__c</field>
        <formula>TEXT(Product2.Business_Unit__c)</formula>
        <name>Update Business Unit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Opportunity_Product_Service_Date</fullName>
        <description>Update the Service Date of the Opportunity Product to match the last day of the Opportunity Product Forecast Month otherwise the Opportunity Quarter.</description>
        <field>ServiceDate</field>
        <formula>DATE( VALUE( TEXT( Opportunity.Year__c )),
CASE( 
 TEXT( Forecast_Month__c ), 
 &quot;January&quot;, 1,
 &quot;February&quot;, 2, 
 &quot;March&quot;, 3,
 &quot;April&quot;, 4,
 &quot;May&quot;, 5,
 &quot;June&quot;, 6,
 &quot;July&quot;, 7,
 &quot;August&quot;, 8,
 &quot;September&quot;, 9,
 &quot;October&quot;, 10,
 &quot;November&quot;, 11,
 &quot;December&quot;, 12,
 CASE( TEXT( Opportunity.Quarter__c ),
  &quot;Q1&quot;, 3,
  &quot;Q2&quot;, 6,
  &quot;Q3&quot;, 9,
  &quot;Q4&quot;, 12,
  0)
) + 1,
1) - 1</formula>
        <name>Update Opportunity Product Service Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Opportunity Product Date and Fiscal Period Sync</fullName>
        <actions>
            <name>Update_Opportunity_Product_Service_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Sync the Opportunity Product line item Date and Fiscal Periods (month)</description>
        <formula>TEXT(Forecast_Month__c) != CASE( MONTH( ServiceDate ),  1, &quot;January&quot;,  2, &quot;February&quot;,  3, &quot;March&quot;,  4, &quot;April&quot;,  5, &quot;May&quot;,  6, &quot;June&quot;,  7, &quot;July&quot;,  8, &quot;August&quot;,  9, &quot;September&quot;,  10, &quot;October&quot;,  11, &quot;November&quot;,  12, &quot;December&quot;,  &quot;None&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Business Unit</fullName>
        <actions>
            <name>Update_Business_Unit</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Copies Business Unit from the related product. The business unit field is used in the roll-up summary field.</description>
        <formula>true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
