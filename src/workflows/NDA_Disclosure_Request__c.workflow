<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>NDA_DPL_Approval_Requested_for_Requester_VF</fullName>
        <description>Disclosure Request submitted for approval email notification to Requester</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>NDA_Email_Templates/NDA_DPL_Approval_Requested_Requester_VF</template>
    </alerts>
    <alerts>
        <fullName>NDA_Disclosure_Approval_Accepted</fullName>
        <description>NDA Disclosure Approval Accepted</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>NDA_Email_Templates/NDA_Disclosure_Approved_Requester_VF</template>
    </alerts>
    <alerts>
        <fullName>NDA_Disclosure_Approval_Rejected</fullName>
        <description>NDA Disclosure Approval Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>NDA_Email_Templates/NDA_Disclosure_Rejected_Requester_VF</template>
    </alerts>
    <alerts>
        <fullName>NDA_Disclosure_Approval_Submitted</fullName>
        <description>NDA Disclosure Approval Submitted</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>NDA_Email_Templates/NDA_Disclosure_Requester_VF</template>
    </alerts>
    <fieldUpdates>
        <fullName>Update_Approval_Status_to_Approved</fullName>
        <field>DPL_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Update Approval Status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approval_Status_to_Rejected</fullName>
        <field>DPL_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Update Approval Status to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>NDA Disclosure Request Submitted for Category Lead%27s Approval</fullName>
        <actions>
            <name>NDA_Disclosure_Approval_Submitted</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>NDA_Disclosure_Request__c.DPL_Status__c</field>
            <operation>equals</operation>
            <value>Pending</value>
        </criteriaItems>
        <criteriaItems>
            <field>NDA_Disclosure_Request__c.NDAFileID__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
