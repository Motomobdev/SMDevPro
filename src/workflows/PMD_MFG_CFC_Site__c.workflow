<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Zone_Code</fullName>
        <field>Zone_Code__c</field>
        <formula>CASE( Zone_Name__c ,
&quot;Australia &amp; NZ&quot;, &quot;AUS &amp; NZ&quot;,
&quot;India&quot;, &quot;India&quot;,
&quot;Japan&quot;, &quot;JPN&quot;,
&quot;Korea&quot;, &quot;KR&quot;,
&quot;Other SWA&quot;, &quot;Other&quot;,
&quot;South East Asia&quot;, &quot;SEA&quot;,
&quot;C Europe&quot;, &quot;CE&quot;,
&quot;E Europe&quot;,&quot;EE&quot;,
&quot;Israel&quot;,&quot;IL&quot;,
&quot;MEA&quot;,&quot;MEA&quot;,
&quot;N Europe&quot;,&quot;NE&quot;,
&quot;Pakistan&quot;,&quot;PK&quot;,
&quot;Russia&quot;,&quot;RU&quot;,
&quot;S Europe&quot;,&quot;SE&quot;,
&quot;Turkey&quot;,&quot;TR&quot;,
&quot;China&quot;,&quot;PRC&quot;,
&quot;Hong Kong&quot;,&quot;HK&quot;,
&quot;Taiwan&quot;,&quot;TWN&quot;,
&quot;Brazil&quot;,&quot;BZ&quot;,
&quot;LA1&quot;,&quot;LA1&quot;,
&quot;LA2&quot;,&quot;LA2&quot;,
&quot;Mexico&quot;,&quot;MX&quot;,
&quot;Canada&quot;,&quot;CAN&quot;,
&quot;USA&quot;,&quot;USA&quot;,
&quot;&quot;)</formula>
        <name>Update Zone Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Zone_Friendly_Name</fullName>
        <field>Zone_Friendly_Name__c</field>
        <formula>CASE( Zone_Name__c ,
&quot;C Europe&quot;,	&quot;Central Europe&quot;,
&quot;Mexico&quot;, &quot;Mexico&quot;,
&quot;USA&quot;, &quot;United States&quot;,
&quot;N Europe&quot;, &quot;Northern Europe&quot;,
&quot;Russia&quot;, &quot;Russia Federation&quot;,
&quot;Other SWA&quot;, &quot;Other SWA&quot;,
&quot;India&quot;, &quot;India&quot;,
&quot;Japan&quot;, &quot;Japan&quot;,
&quot;E Europe&quot;, &quot;Eastern Europe&quot;,
&quot;LA1&quot;, &quot;LA1 (Open/Free Trade)&quot;,
&quot;Taiwan&quot;, &quot;Taiwan&quot;,
&quot;Hong Kong&quot;, &quot;Hong Kong&quot;,
&quot;Korea&quot;, &quot;Korea&quot;,
&quot;Australia &amp; NZ&quot;, &quot;Australia &amp; New Zealand&quot;,
&quot;Canada&quot;, &quot;Canada&quot;,
&quot;Pakistan&quot;, &quot;Pakistan&quot;,
&quot;China&quot;, &quot;China (People&apos;s Republic)&quot;,
&quot;Israel&quot;, &quot;Israel&quot;,
&quot;Brazil&quot;, &quot;Brazil&quot;,
&quot;MEA&quot;, &quot;Middle East &amp; Africa&quot;,
&quot;LA2&quot;, &quot;LA2 (Restricted Trade)&quot;,
&quot;S Europe&quot;, &quot;Southern Europe&quot;,
&quot;Turkey&quot;, &quot;Turkey&quot;,
&quot;South East Asia&quot;, &quot;South East Asia&quot;,
&quot;&quot;)</formula>
        <name>Update Zone Friendly Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CFC Segment Code Trigger</fullName>
        <actions>
            <name>Update_Zone_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Zone_Friendly_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
