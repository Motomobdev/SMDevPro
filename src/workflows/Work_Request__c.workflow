<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Work_Request_New_WR_Created</fullName>
        <description>Work Request: New WR Created</description>
        <protected>false</protected>
        <recipients>
            <recipient>wcp002@motorola.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Approval_Status_Change</template>
    </alerts>
    <fieldUpdates>
        <fullName>Update_Completed_Date</fullName>
        <description>Update Completed Date to current date/time</description>
        <field>Completed_Date__c</field>
        <formula>NOW()</formula>
        <name>Update Completed Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_IT_Status_to_Completed</fullName>
        <description>Update IT Status to Completed</description>
        <field>IT_Status__c</field>
        <literalValue>Completed</literalValue>
        <name>Update IT Status to Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_History</fullName>
        <description>Append the Latest Status entry to the Status History contents.</description>
        <field>Status_History__c</field>
        <formula>(Latest_Status__c &amp;
&quot;(&quot; &amp; TEXT(TODAY()) &amp; &quot; &quot; &amp;
LEFT(LastModifiedBy.FirstName,1) &amp; LastModifiedBy.LastName &amp; &quot;)&quot; &amp;
 Status_History__c)</formula>
        <name>Update Status History</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Work Request Latest Status History</fullName>
        <actions>
            <name>Update_Status_History</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Historical record of the Latest Status entries</description>
        <formula>NOT(BEGINS( Status_History__c , Latest_Status__c ))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Work Request Status Completed</fullName>
        <actions>
            <name>Update_Completed_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_IT_Status_to_Completed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Work_Request__c.Work_Request_Status__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <description>When the work request status is completed, the IT Status and Completed Date should also be updated</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Work Request%3A Chatter Follower</fullName>
        <active>false</active>
        <description>Add Owner, Requestor, and Assigned To persons as Followers</description>
        <formula>true</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Work Request%3A New Request</fullName>
        <actions>
            <name>Work_Request_New_WR_Created</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Work Request created</description>
        <formula>True</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
