<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Auto_Email_on_Feature_Record_Update</fullName>
        <description>Auto Email on Feature Record Update</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>MotoDev/Feature_UPDATED_EMAIL_TEMPLATE</template>
    </alerts>
    <alerts>
        <fullName>Auto_Generated_Email_to_Requestor_for_New_Feature</fullName>
        <description>Auto Generated Email to Requestor for New Feature</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>MotoDev/Feature_Created_Auto_Email_Requestor</template>
    </alerts>
    <alerts>
        <fullName>Bug_Submitted</fullName>
        <description>Bug Submitted</description>
        <protected>false</protected>
        <recipients>
            <recipient>gmv736@motorola.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>MotoDev/Bug_Submitted</template>
    </alerts>
    <alerts>
        <fullName>Email_Sent_to_Developer_when_Phase_changes_to_Implementation</fullName>
        <description>Email Sent to Developer when Phase changes to &quot;Implementation&quot;</description>
        <protected>false</protected>
        <recipients>
            <field>Assigned_To_Person_Email_Format__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Developer_Email_When_Phase_Changes_to_Implementation</template>
    </alerts>
    <alerts>
        <fullName>Feature_Phase_Change_Email_Alert</fullName>
        <description>Feature Phase Change Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Features/Feature_Phase_Change_Notification</template>
    </alerts>
    <alerts>
        <fullName>Feature_Phase_Change_to_Deployed_Email_Alert</fullName>
        <description>Feature Phase Change to &quot;Deployed&quot; Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Features/Feature_Phase_Change_Notification</template>
    </alerts>
    <alerts>
        <fullName>Feature_Phase_Change_to_Ready_for_Deployment_Email_Alert</fullName>
        <description>Feature Phase Change to &quot;Ready for Deployment&quot; Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Features/Feature_Phase_Change_to_Ready_for_Deployment_Notification</template>
    </alerts>
    <alerts>
        <fullName>Feature_Phase_Change_to_Ready_for_Deployment_Email_Alert2</fullName>
        <description>Feature Phase Change to &quot;Ready for Deployment&quot; Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Features/Feature_Phase_Change_to_Ready_for_Deployment_Notification</template>
    </alerts>
    <alerts>
        <fullName>Feature_Ready_for_Re_Test</fullName>
        <description>Feature Ready for Re-Test</description>
        <protected>false</protected>
        <recipients>
            <recipient>nhv783@motorola.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Features/Feature_Ready_for_Re_Test</template>
    </alerts>
    <alerts>
        <fullName>Feature_UAT_Accepted</fullName>
        <description>Feature UAT Accepted</description>
        <protected>false</protected>
        <recipients>
            <recipient>MotoDev_BigKite</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Features/Feature_Test_Accepted</template>
    </alerts>
    <alerts>
        <fullName>Feature_UAT_Rejected</fullName>
        <description>Feature - UAT Rejected</description>
        <protected>false</protected>
        <recipients>
            <recipient>MotoDev_BigKite</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Features/Feature_Test_Rejected</template>
    </alerts>
    <alerts>
        <fullName>New_Feature_Request_Email_Alert</fullName>
        <description>New Feature Request Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Requested_Group_Owner_Email_Format__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Features/New_Feature_Request_Automated_Email</template>
    </alerts>
    <alerts>
        <fullName>Notify_Developer_of_Feature_Reject</fullName>
        <description>Notify Developer that the feature approval has been rejected.</description>
        <protected>false</protected>
        <recipients>
            <field>Assigned_To_Person_Email_Format__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Features/Approval_Testing_Rejected</template>
    </alerts>
    <fieldUpdates>
        <fullName>Assigned_To_Email_Field_Update</fullName>
        <field>Assigned_To_Person_Email_Format__c</field>
        <formula>Assigned_To__r.Email</formula>
        <name>Assigned To Email Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Feature_Owner_Approves_Request</fullName>
        <field>Implementation_Status__c</field>
        <literalValue>End User Approved</literalValue>
        <name>Feature Owner Approves Request</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Feature_Ready_for_Deploy</fullName>
        <description>Update implementation status to Ready for Deployment</description>
        <field>Implementation_Status__c</field>
        <literalValue>Approved - Ready for Deployment</literalValue>
        <name>Feature Ready for Deploy</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Implementation_Status_Field_Update</fullName>
        <field>Implementation_Status__c</field>
        <literalValue>Open - Assigned</literalValue>
        <name>Implementation Status Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Jason_Approves_Request</fullName>
        <field>Implementation_Status__c</field>
        <literalValue>Ready for User Testing</literalValue>
        <name>Jason Approves Request</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Old_Phase_field_update</fullName>
        <description>This field is updated with the old Phase every time there is a change to the Phase field</description>
        <field>Old_Phase__c</field>
        <formula>TEXT ( PRIORVALUE( Phase__c ) )</formula>
        <name>Old Phase field update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Phase_Change_on_Final_Approval</fullName>
        <field>Phase__c</field>
        <literalValue>Ready for Deployment</literalValue>
        <name>Phase Change on Final Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Phase_Change_to_Deployed</fullName>
        <field>Phase__c</field>
        <literalValue>Deployed</literalValue>
        <name>Phase Change to Deployed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Phase_Completed</fullName>
        <field>Phase__c</field>
        <literalValue>5) Completed</literalValue>
        <name>Phase Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Recall_Implementation_Status_Field_Updat</fullName>
        <field>Implementation_Status__c</field>
        <literalValue>Fix In Progress</literalValue>
        <name>Recall Implementation Status Field Updat</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Request_Rejected</fullName>
        <field>Implementation_Status__c</field>
        <literalValue>Changes Required</literalValue>
        <name>Request Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Submission_Implementation_Status_Update</fullName>
        <field>Implementation_Status__c</field>
        <literalValue>Ready for Internal Testing</literalValue>
        <name>Submission: Implementation Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approval_Checkbox</fullName>
        <field>Approved__c</field>
        <literalValue>1</literalValue>
        <name>Update Approval Checkbox</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Group_Owner_Email_field</fullName>
        <field>Requested_Group_Owner_Email_Format__c</field>
        <formula>Requested_Group_Owner_Email__c</formula>
        <name>Update Group Owner Email field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Assigned To Email Field Update</fullName>
        <actions>
            <name>Assigned_To_Email_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Feature__c.Assigned_To__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Auto Create Task Feature</fullName>
        <actions>
            <name>Auto_Generated_Email_to_Requestor_for_New_Feature</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Feature__c.Phase__c</field>
            <operation>equals</operation>
            <value>Requested,Ready for Deployment,Closed - Rejected,Submitted to Review Board,Closed - Verified,Implementation,Request Approved,Deployed</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Auto Notifications on Feature Updates</fullName>
        <actions>
            <name>Auto_Email_on_Feature_Record_Update</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Feature__c.Phase__c</field>
            <operation>notEqual</operation>
            <value>Requested</value>
        </criteriaItems>
        <description>Automatic email is send every time the feature record is updated.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Auto Phase Change to %22Deployed%22</fullName>
        <actions>
            <name>Feature_Phase_Change_to_Deployed_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Phase_Change_to_Deployed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Feature__c.Implementation_Status__c</field>
            <operation>equals</operation>
            <value>Deployed to Production</value>
        </criteriaItems>
        <description>When the developer changes the Implementation Status to &quot;Deployed to Production&quot; then the Phase is automatically changed to &quot;Deployed&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Bug Submitted</fullName>
        <actions>
            <name>Bug_Submitted</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Feature__c.Type__c</field>
            <operation>equals</operation>
            <value>Bug</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Deployed</fullName>
        <actions>
            <name>Phase_Completed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Feature__c.Implementation_Status__c</field>
            <operation>equals</operation>
            <value>Closed - Deployed</value>
        </criteriaItems>
        <description>Update Phase to 5) Completed.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Feature Phase Change to %22Closed - Rejected%22 Automatic Email Notification</fullName>
        <actions>
            <name>Feature_Phase_Change_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>An email is sent out to the Submitter if the Phase is changed to: Closed Rejected</description>
        <formula>ISPICKVAL( Phase__c , &quot;Closed - Rejected&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Feature Phase Change to %22Deployed%22 Automatic Email Notification</fullName>
        <actions>
            <name>Feature_Phase_Change_to_Deployed_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>An email is sent out to the Submitter/Feature Owner and the Feature manager when the Phase changes to &quot;Deployed&quot;</description>
        <formula>ISPICKVAL( Phase__c , &quot;Deployed&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Feature Phase Change to %22Implementation%22 Automatic Email Notification</fullName>
        <actions>
            <name>Email_Sent_to_Developer_when_Phase_changes_to_Implementation</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Feature_Phase_Change_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>An email is sent out to the Submitter if the Phase is changed to: Implementation</description>
        <formula>ISPICKVAL( Phase__c , &quot;Implementation&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Feature Phase Change to %22Ready for Deployment%22 Automatic Email Notification</fullName>
        <actions>
            <name>Feature_Phase_Change_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>An email is sent out to the Submitter if the Phase is changed to: Ready for Deployment</description>
        <formula>ISPICKVAL( Phase__c , &quot;Ready for Deployment&quot;) &amp;&amp;  ISPICKVAL( Implementation_Status__c , &quot;End User Approved&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Feature Phase Change to %22Request Approved%22 Automatic Email Notification</fullName>
        <actions>
            <name>Feature_Phase_Change_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>An email is sent out to the Submitter if the Phase is changed to: Request Approved.</description>
        <formula>ISPICKVAL( Phase__c , &quot;Request Approved&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Feature Phase Change to %22Submitted to Review Board%22 Automatic Email Notification</fullName>
        <actions>
            <name>Feature_Phase_Change_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>An email is sent out to the Submitter if the Phase is changed to: Submitted to Review Board</description>
        <formula>ISPICKVAL( Phase__c , &quot;Submitted to Review Board&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Feature Ready for Re-Test</fullName>
        <actions>
            <name>Feature_Ready_for_Re_Test</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Feature__c.Implementation_Status__c</field>
            <operation>equals</operation>
            <value>Ready for Testing</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Feature UAT Accepted</fullName>
        <actions>
            <name>Feature_UAT_Accepted</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Feature_Ready_for_Deploy</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Feature__c.End_User_Testing_Status__c</field>
            <operation>equals</operation>
            <value>Tested - Approved</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Group Owner Email Field Update</fullName>
        <actions>
            <name>Update_Group_Owner_Email_field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Feature__c.Requested_Group_Owner_Email__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Implementation Status Automatically Changes When Assigned to Populated</fullName>
        <actions>
            <name>Implementation_Status_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Feature__c.Assigned_To__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>New Feature Creation Automated Email</fullName>
        <actions>
            <name>New_Feature_Request_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>An email is sent out to the Submitter/Feature Owner, The Group Owner and the Feature manager when a new Feature Request is submitted. The Phase is &quot;Requested&quot; by default.</description>
        <formula>ISPICKVAL( Phase__c , &quot;Requested&quot;) &amp;&amp; NOT ( ISNULL( Requested_Group_Owner_Email_Format__c ) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Old Phase field update</fullName>
        <actions>
            <name>Old_Phase_field_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( Phase__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UAT - Rejected</fullName>
        <actions>
            <name>Feature_UAT_Rejected</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Feature__c.End_User_Testing_Status__c</field>
            <operation>equals</operation>
            <value>Tested - Rejected</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Auto_Created_Feature_Task</fullName>
        <assignedTo>MotoDevAdmin</assignedTo>
        <assignedToType>role</assignedToType>
        <dueDateOffset>45</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <offsetFromField>Feature__c.CreatedDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Auto Created Feature Task</subject>
    </tasks>
</Workflow>
