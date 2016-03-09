<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Amendment_Request_for_requester</fullName>
        <description>Amendment Request for requester</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>NDA_Email_Templates/NDA_Amendment_Requested_for_Requester</template>
    </alerts>
    <alerts>
        <fullName>NDA_Approval_Request_Submitted_notification_for_requester</fullName>
        <description>NDA Approval Request Submitted notification for requester</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>NDA_Email_Templates/NDA_DPL_Approval_Requested_Requester_VF</template>
    </alerts>
    <alerts>
        <fullName>NDA_Connected_Party_Notification_to_Legal</fullName>
        <description>NDA Connected Party Notification to Legal</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>mwcp74@motorola.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>xkd001.md@motorola.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>NDA_Email_Templates/NDA_Connected_Party_Approval_Request_to_Legal</template>
    </alerts>
    <alerts>
        <fullName>NDA_Connected_Party_Response_to_User</fullName>
        <description>NDA Connected Party Response to User</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>mwcp74@motorola.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>xkd001.md@motorola.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>NDA_Email_Templates/NDA_Connected_Party_Response_to_Requester</template>
    </alerts>
    <alerts>
        <fullName>NDA_DPL_Approval_Accepted</fullName>
        <description>NDA DPL Approval Accepted</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>NDA_Email_Templates/NDA_DPL_Approved_for_Requester_VF</template>
    </alerts>
    <alerts>
        <fullName>NDA_DPL_Approval_Rejected</fullName>
        <description>NDA DPL Approval Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>NDA_Email_Templates/NDA_DPL_Rejected_for_Requester_VF</template>
    </alerts>
    <alerts>
        <fullName>NDA_DPL_Approved</fullName>
        <description>NDA_DPL Approved</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>NDA_Email_Templates/NDA_DPL_Approved_for_Requester</template>
    </alerts>
    <alerts>
        <fullName>NDA_DPL_Approved_for_Requester</fullName>
        <description>NDA_DPL Approved for Requester</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>NDA_Email_Templates/NDA_DPL_Approved_for_Requester</template>
    </alerts>
    <alerts>
        <fullName>NDA_Expiration_Reminder_2_for_Requester</fullName>
        <description>NDA Expiration Reminder for Requester</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>NDA_Email_Templates/NDA_Expiration_Reminder_for_Requester</template>
    </alerts>
    <alerts>
        <fullName>NDA_Expiration_Reminder_for_Requester</fullName>
        <description>NDA Expiration Reminder for Requester</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>NDA_Email_Templates/NDA_Expiration_Reminder_for_Requester</template>
    </alerts>
    <alerts>
        <fullName>NDA_Expiration_Update_Requested_for_Requester</fullName>
        <description>NDA Expiration Update Requested for Requester</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>NDA_Email_Templates/NDA_Expiration_Update_for_Requester</template>
    </alerts>
    <alerts>
        <fullName>NDA_ModificationRequestedforRequester</fullName>
        <description>NDA_Modification Requested for Requester</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>NDA_Email_Templates/NDA_Modification_Requested_for_Requester</template>
    </alerts>
    <alerts>
        <fullName>NDA_New_NDA_Submitted_notification_for_requester</fullName>
        <description>NDA New NDA Submitted notification for requester</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>NDA_Email_Templates/NDA_New_NDA_Submitted_Requester</template>
    </alerts>
    <alerts>
        <fullName>NDA_Status_Change_Email_to_Requester</fullName>
        <description>NDA Status Change Email to Requester</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>NDA_Email_Templates/NDA_Status_Change_for_Requester</template>
    </alerts>
    <alerts>
        <fullName>test_nda</fullName>
        <description>test nda</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>NDA_Email_Templates/NDA_DPL_Approved_for_Requester</template>
    </alerts>
    <fieldUpdates>
        <fullName>NDA_Staus_Expiry</fullName>
        <field>NDAStatus__c</field>
        <literalValue>Expired</literalValue>
        <name>NDA Staus Expiry</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NDA_Update_DPL_Approval_Status</fullName>
        <description>This action will update the DPL  approval Status as Approved.</description>
        <field>DPLStatus__c</field>
        <literalValue>Approved</literalValue>
        <name>NDA Update DPL Approval Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NDA_Update_DPL_Approval_StatusRejected</fullName>
        <description>This action will update the DPL approval status to Rejected</description>
        <field>DPLStatus__c</field>
        <literalValue>Rejected</literalValue>
        <name>NDA Update DPL Approval Status Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NDA_Update_DPL_Status</fullName>
        <field>DPLStatus__c</field>
        <literalValue>Approved</literalValue>
        <name>NDA Update DPL Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NDA_Update_Expiry_Date</fullName>
        <field>Expires_On__c</field>
        <formula>DATE(YEAR(Start_Date__c) + 3, Month(Start_Date__c), Day(Start_Date__c))</formula>
        <name>NDA Update Expiry Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NDA_Update_NDA_file_ID</fullName>
        <field>NDAFileID__c</field>
        <formula>IF(IsProductNDA__c, &apos;P&apos;, &apos;N&apos;) +   RIGHT(TEXT(YEAR(TODAY())), 2)  +  &apos;-&apos; +  TEXT(MONTH(TODAY())) + &apos;-&apos; +   RIGHT(Name, 5)</formula>
        <name>NDA_Update NDA file ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NDA_Update_NDA_status_as_Canelled</fullName>
        <field>NDAStatus__c</field>
        <literalValue>Cancelled</literalValue>
        <name>NDA Update NDA status as Canelled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>NDA Approval request submitted to DPL notification for requester</fullName>
        <actions>
            <name>NDA_Approval_Request_Submitted_notification_for_requester</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This is a notification email to Requester at DPL approval submission.</description>
        <formula>AND( IsProductNDA__c,  ISPICKVAL( NDAStatus__c , &apos;Pending&apos;),  ISNEW())</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>NDA Connected Party Notification to Legal</fullName>
        <actions>
            <name>NDA_Connected_Party_Notification_to_Legal</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Email Notification of NDA submitted for Requester</description>
        <formula>AND(ISPICKVAL(NDAStatus__c , &apos;Pending&apos;),    DATEVALUE(CreatedDate)  ==  TODAY(), ISNEW(), ISPICKVAL(Is_Outside_Party_on_Connected_Person__c,&apos;Yes&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>NDA Connected Party Response to User</fullName>
        <actions>
            <name>NDA_Connected_Party_Response_to_User</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Email Notification of NDA submitted for Requester</description>
        <formula>AND(ISPICKVAL(NDAStatus__c , &apos;Pending&apos;),ISPICKVAL(Is_Outside_Party_on_Connected_Person__c,&apos;Yes&apos;), OR(ISPICKVAL(Connected_Party_Approval_Status__c,&apos;Approved&apos;),ISPICKVAL(Connected_Party_Approval_Status__c,&apos;Rejected&apos;)  ))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>NDA Expiry Status Update</fullName>
        <actions>
            <name>NDA_Expiration_Update_Requested_for_Requester</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>NDA_Staus_Expiry</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( OR(ISPICKVAL( NDAStatus__c , &apos;Executed&apos;), ISPICKVAL( NDAStatus__c , &apos;Executed-Mod&apos;)) ,  Expires_On__c &lt;=  TODAY())</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>NDA New NDA submitted for Requester</fullName>
        <actions>
            <name>NDA_New_NDA_Submitted_notification_for_requester</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Email Notification of NDA submitted for Requester</description>
        <formula>AND(ISPICKVAL(NDAStatus__c , &apos;Pending&apos;),    DATEVALUE(CreatedDate)  ==  TODAY(), ISNEW())</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>NDA Status Change email to requester</fullName>
        <actions>
            <name>NDA_Status_Change_Email_to_Requester</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>NDA status change notification to requester</description>
        <formula>ISCHANGED( NDAStatus__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>NDA Staus Expiry Reminder</fullName>
        <active>true</active>
        <formula>OR(ISPICKVAL( NDAStatus__c , &apos;Executed&apos;), ISPICKVAL( NDAStatus__c , &apos;Executed-Mod&apos;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>NDA_Expiration_Reminder_for_Requester</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>NDA__c.Expires_On__c</offsetFromField>
            <timeLength>-30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>NDA_Expiration_Reminder_2_for_Requester</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>NDA__c.Expires_On__c</offsetFromField>
            <timeLength>-15</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>NDA Update Expiry Date</fullName>
        <actions>
            <name>NDA_Update_Expiry_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISCHANGED( NDAStatus__c), IF( OR(ISPICKVAL( NDAStatus__c , &apos;Executed&apos;), ISPICKVAL( NDAStatus__c , &apos;Executed-Mod&apos;)) , true, false) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>NDA_Amendment Requested for Requester</fullName>
        <actions>
            <name>Amendment_Request_for_requester</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>NDA__c.NDAStatus__c</field>
            <operation>equals</operation>
            <value>Executed,Executed-Mod</value>
        </criteriaItems>
        <criteriaItems>
            <field>NDA__c.AmendmentSent__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>NDA_Modification Requested for Requester</fullName>
        <actions>
            <name>NDA_ModificationRequestedforRequester</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(OR (ISPICKVAL(NDAStatus__c , &apos;Pending&apos;),ISPICKVAL(NDAStatus__c , &apos;Executed&apos;), ISPICKVAL(NDAStatus__c , &apos;Executed-Mod&apos;)), ISCHANGED( Modification_Text__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>NDA_Update NDA file ID</fullName>
        <actions>
            <name>NDA_Update_NDA_file_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>NDA__c.CreatedDate</field>
            <operation>equals</operation>
            <value>TODAY</value>
        </criteriaItems>
        <description>This rule will generate the File ID of NDA</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
