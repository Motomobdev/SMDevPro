<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>notification_to_contract_owner_on_new_contract_creation</fullName>
        <description>Send notification email to the Contract Owner on new Contract creation</description>
        <protected>false</protected>
        <recipients>
            <field>Contract_Owner_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Contract_Templates/contract_request_new_contract_creation_notification_to_contract_owner</template>
    </alerts>
    <alerts>
        <fullName>notification_to_requester_on_acceptance</fullName>
        <description>Send notification email to the Requester on new Contract creation</description>
        <protected>false</protected>
        <recipients>
            <field>Requester_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Contract_Templates/contract_request_acceptance_notification_to_requester</template>
    </alerts>
    <alerts>
        <fullName>notification_to_requester_on_rejection</fullName>
        <description>Send notification email to the Requester on Contract Request rejection</description>
        <protected>false</protected>
        <recipients>
            <field>Requester_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Contract_Templates/contract_request_rejection_notification_to_requester</template>
    </alerts>
    <alerts>
        <fullName>send_notification_email_to_admins</fullName>
        <description>Send notification email to the Admins on Contract Request submission</description>
        <protected>false</protected>
        <recipients>
            <recipient>Contract_Submission_Tool_Notification</recipient>
            <type>group</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Contract_Templates/contract_request_submission_notification_to_admins</template>
    </alerts>
    <alerts>
        <fullName>send_notification_email_to_requester</fullName>
        <description>Send notification email to the Requester on Contract Request submission</description>
        <protected>false</protected>
        <recipients>
            <field>Requester_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Contract_Templates/contract_request_submission_notification_to_requester</template>
    </alerts>
    <fieldUpdates>
        <fullName>contract_request_update_owner_email</fullName>
        <field>Contract_Owner_Email__c</field>
        <formula>Contract_Owner__r.Email</formula>
        <name>Contract Request - Update Owner Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Contract Request - Contract Owner Change</fullName>
        <actions>
            <name>contract_request_update_owner_email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update email address of the Contract Owner</description>
        <formula>Contract_Owner__c &lt;&gt; PRIORVALUE(Contract_Owner__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Contract Request Processed</fullName>
        <actions>
            <name>notification_to_contract_owner_on_new_contract_creation</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>notification_to_requester_on_acceptance</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contract_Request__c.Request_Status__c</field>
            <operation>equals</operation>
            <value>Processed</value>
        </criteriaItems>
        <description>Notify Requester when their request has been accepted and contract is created for it. Notify Contract Owner with request details.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Contract Request Rejected</fullName>
        <actions>
            <name>notification_to_requester_on_rejection</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contract_Request__c.Request_Status__c</field>
            <operation>equals</operation>
            <value>Rejected</value>
        </criteriaItems>
        <description>Notification to Requester on rejection of his/her request.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Contract Request Submitted</fullName>
        <actions>
            <name>send_notification_email_to_admins</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>send_notification_email_to_requester</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contract_Request__c.Request_Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <description>When Requester submits new request using Contract Request Form</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
