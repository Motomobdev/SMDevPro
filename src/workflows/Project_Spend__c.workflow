<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Project_Spend_Approval_Notice</fullName>
        <description>Email Alert when Project Spend has been approved</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SOW_Templates/Project_Spend_Approval_Notice</template>
    </alerts>
    <alerts>
        <fullName>Project_Spend_Rejection_Notice</fullName>
        <description>Project Spend Rejection Notice</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SOW_Templates/Project_Spend_Rejection_Notice</template>
    </alerts>
    <alerts>
        <fullName>Send_Needs_Information_email</fullName>
        <description>Send &quot;Needs Information&quot; email</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>fdq748@motorola.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SOW_Templates/Needs_Information</template>
    </alerts>
    <alerts>
        <fullName>Send_out_SOW_thank_you</fullName>
        <description>Send out SOW thank you</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SOW_Templates/Project_Spend_Thank_You</template>
    </alerts>
    <fieldUpdates>
        <fullName>Click_Being_Approved</fullName>
        <description>clicks the being approved checkbox</description>
        <field>Being_Approved__c</field>
        <literalValue>1</literalValue>
        <name>Click Being Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Correct_email</fullName>
        <field>Email__c</field>
        <formula>MMID_Email__c</formula>
        <name>Project Spend Correct email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SSR_Status_to_Approval_Queue</fullName>
        <description>Upon Initial submission, change the SSR Status to Approval Queue</description>
        <field>SSR_Status__c</field>
        <literalValue>Approval Queue</literalValue>
        <name>SSR Status to Approval Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_SW_Fully_Approved</fullName>
        <field>SSR_Status__c</field>
        <literalValue>Fully Approved</literalValue>
        <name>Update Status to SW Fully Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_SW_SLT_Approved</fullName>
        <field>SSR_Status__c</field>
        <literalValue>SW SLT Approved</literalValue>
        <name>Update Status to SW SLT Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_SW_SLT_Not_Approved</fullName>
        <field>SSR_Status__c</field>
        <literalValue>SW SLT Not Approved</literalValue>
        <name>Update Status to SW SLT Not Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Project Spend Update Email</fullName>
        <actions>
            <name>Correct_email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>Email__c !=  MMID_Email__c &amp;&amp; MMID_Email__c != &apos;@motorola.com&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send out email for %22Needs Information%22</fullName>
        <actions>
            <name>Send_Needs_Information_email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL( SSR_Status__c ,&quot;Needs Information&quot;) &amp;&amp; LEN( Needs_Information_Details__c ) != 0</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send out thank you email when Project Spend created</fullName>
        <actions>
            <name>Send_out_SOW_thank_you</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Project_Spend__c.MMID_Email__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Project_Spend__c.MMID_Email__c</field>
            <operation>notEqual</operation>
            <value>@motorola.com</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
