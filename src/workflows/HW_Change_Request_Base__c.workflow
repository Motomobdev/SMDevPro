<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CM_Alert</fullName>
        <ccEmails>sdobrow@salesforce.com</ccEmails>
        <description>CM Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Category_Manager_Reviewer__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HW_Change_Management/SDE_Risk_Notification</template>
    </alerts>
    <alerts>
        <fullName>HCR_Change_Type</fullName>
        <description>HCR Change Type - Corporation Responsibility Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>aeb095.md@motorola.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>ecpd20.md@motorola.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HW_Change_Management/Corporation_Resp_Notification</template>
    </alerts>
    <alerts>
        <fullName>HW_CR_Approved_Notification</fullName>
        <description>HW CR Approved Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>e00009@motorola.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HW_Change_Management/HW_CR_Approved_Notification</template>
    </alerts>
    <alerts>
        <fullName>HW_CR_Completed_Awaiting_MotoPDM_ECR</fullName>
        <description>HW CR Completed Awaiting MotoPDM ECR</description>
        <protected>false</protected>
        <recipients>
            <recipient>HWCRMotoPDMAdmin</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HW_Change_Management/HW_CR_Change_Approval</template>
    </alerts>
    <alerts>
        <fullName>HW_CR_EOL_SC_Operation_Notice</fullName>
        <description>HW CR EOL SC Operation Notice</description>
        <protected>false</protected>
        <recipients>
            <recipient>HWCRSCOperations</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HW_Change_Management/HW_CR_EOL_Reviewer_Email_1</template>
    </alerts>
    <alerts>
        <fullName>New_HW_Change_Request_Awaiting_Submission_to_Initial_Reviewers</fullName>
        <description>New HW Change Request Awaiting Submission to Initial Reviewers</description>
        <protected>false</protected>
        <recipients>
            <recipient>mduncan1.md@motorola.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>wlbg02.md@motorola.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>HW_Change_Management/HW_Request_Created</template>
    </alerts>
    <alerts>
        <fullName>SDE_Alert</fullName>
        <ccEmails>sdobrow@salesforce.com</ccEmails>
        <description>SDE Alert</description>
        <protected>false</protected>
        <recipients>
            <field>SDE_Reviewer__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HW_Change_Management/SDE_Risk_Notification</template>
    </alerts>
    <alerts>
        <fullName>SDE_Required_Review</fullName>
        <description>SDE Required Review</description>
        <protected>false</protected>
        <recipients>
            <field>SDE_Reviewer__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HW_Change_Management/SDE_Risk_Notification</template>
    </alerts>
    <alerts>
        <fullName>SDE_Required_Review_1</fullName>
        <description>SDE Required Review 1</description>
        <protected>false</protected>
        <recipients>
            <field>Category_Manager_Reviewer__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>SDE_Reviewer__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>SME_Reviewer__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HW_Change_Management/SDE_Risk_Notification</template>
    </alerts>
    <alerts>
        <fullName>SME_Notification_eMail</fullName>
        <description>SME Alert</description>
        <protected>false</protected>
        <recipients>
            <field>SME_Reviewer__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HW_Change_Management/SDE_Risk_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>CR_Initial_Review_Completion</fullName>
        <description>Update to change the Change-Request-Stage of the related HCR (hardware change request) record to &apos;Eng Review&apos;</description>
        <field>Change_Request_Stage__c</field>
        <literalValue>Eng Review</literalValue>
        <name>HW CR Initial Review Completion</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_HCR_Complete_Date</fullName>
        <description>Recording today&apos;s date to the HCR Complete Date field</description>
        <field>HCR_Complete_Date__c</field>
        <formula>NOW()</formula>
        <name>Set HCR Complete Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>HCR Change Type</fullName>
        <actions>
            <name>HCR_Change_Type</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>HW_Change_Request_Base__c.Change_Type__c</field>
            <operation>equals</operation>
            <value>Fab,Location,2nd Source</value>
        </criteriaItems>
        <description>Rule triggering Corporation Responsibility Notification</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>HCR Complete Date Stamp</fullName>
        <actions>
            <name>Set_HCR_Complete_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>HW_Change_Request_Base__c.Change_Request_Stage__c</field>
            <operation>equals</operation>
            <value>Complete</value>
        </criteriaItems>
        <description>Rule triggering update of the HCR Complete Date field</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>HW CR Approved Notification</fullName>
        <actions>
            <name>HW_CR_Approved_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>HW_Change_Request_Base__c.Final_HCR_Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <description>Notifies Lorenzo Gomez when Final HCR status changes to Approved</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>HW CR EOL Notice SC Ops</fullName>
        <actions>
            <name>HW_CR_EOL_SC_Operation_Notice</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>HW_Change_Request_Base__c.Last_PO_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>HW_Change_Request_Base__c.Change_Type__c</field>
            <operation>equals</operation>
            <value>EOL</value>
        </criteriaItems>
        <description>Notification to SC Operation of component EOL.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>HW CR MotoPDM ECR Notification</fullName>
        <actions>
            <name>HW_CR_Completed_Awaiting_MotoPDM_ECR</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Approved_Change_Pending_Release_of_ECR</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>HW_Change_Request_Base__c.Final_HCR_Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>HW_Change_Request_Base__c.MotoPDM_Owner__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>HW_Change_Request_Base__c.ECR_Approval_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Notification to MotoPDM PCM team to release ECR recording the final approval status of the change request.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>HW CR New Request</fullName>
        <actions>
            <name>New_HW_Change_Request_Awaiting_Submission_to_Initial_Reviewers</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Create_Initial_Review_PR_Record</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>HW_Change_Request_Base__c.Change_Request_Stage__c</field>
            <operation>equals</operation>
            <value>New Record</value>
        </criteriaItems>
        <description>Rule triggering email alert to change administrators.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <tasks>
        <fullName>Approved_Change_Pending_Release_of_ECR</fullName>
        <assignedTo>HWCRMotoPDMAdmin</assignedTo>
        <assignedToType>role</assignedToType>
        <description>A change request has completed the approval process.  Please review the impacted part numbers and release MotoPDM ECR accordingly.</description>
        <dueDateOffset>3</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>HW_Change_Request_Base__c.CreatedDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Approved Change Pending Release of ECR</subject>
    </tasks>
    <tasks>
        <fullName>Create_Initial_Review_PR_Record</fullName>
        <assignedTo>HWCRWorkflowAdmin</assignedTo>
        <assignedToType>role</assignedToType>
        <description>Enter a new corresponding HW CR Initial Review record.  Also update HCR &apos;Change Request Stage&apos; to &apos;Initial Review&apos;</description>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>HW_Change_Request_Base__c.CreatedDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Create Initial Review &apos;PR&apos; Record</subject>
    </tasks>
</Workflow>
