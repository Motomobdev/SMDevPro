<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CM_Supplier_Inquiry_Email_Alert</fullName>
        <description>CM Supplier Inquiry Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Requester_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Category_Manager_Reviewer__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HW_Change_Management/CM_Data_Inquiry</template>
    </alerts>
    <alerts>
        <fullName>HW_CR_CM_Reviewer_2nd_email</fullName>
        <description>HW CR CM Reviewer 2nd email</description>
        <protected>false</protected>
        <recipients>
            <field>Category_Manager_Reviewer__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HW_Change_Management/HW_CR_CM_Reviewer_Email2</template>
    </alerts>
    <alerts>
        <fullName>HW_CR_CM_Reviewer_Final_Email</fullName>
        <description>HW CR CM Reviewer Final Email</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Category_Manager_Reviewer__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HW_Change_Management/HW_CR_CM_Reviewer_Email3</template>
    </alerts>
    <alerts>
        <fullName>HW_CR_CM_Reviewer_Initial_Email</fullName>
        <description>HW CR CM Reviewer Initial Email</description>
        <protected>false</protected>
        <recipients>
            <field>Category_Manager_Reviewer__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HW_Change_Management/HW_CR_Reviewer_Email_1</template>
    </alerts>
    <alerts>
        <fullName>HW_CR_Initial_SDE_Owner_Requested</fullName>
        <description>HW CR Initial SDE Owner Requested</description>
        <protected>false</protected>
        <recipients>
            <recipient>HWCRSDEManager</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>wlmt09.md@motorola.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HW_Change_Management/HW_CR_Assign_SDE_Notice</template>
    </alerts>
    <alerts>
        <fullName>HW_CR_Initial_SDE_Owner_Requested_2</fullName>
        <description>HW CR Initial SDE Owner Requested</description>
        <protected>false</protected>
        <recipients>
            <recipient>HWCRSDEManager</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HW_Change_Management/HW_CR_Assign_SDE_Notice</template>
    </alerts>
    <alerts>
        <fullName>HW_CR_Review_Admin_Email</fullName>
        <description>HW CR Review Admin Email</description>
        <protected>false</protected>
        <recipients>
            <recipient>HWCRWorkflowAdmin</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>mduncan1.md@motorola.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>wlbg02.md@motorola.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HW_Change_Management/HW_CR_Review_Approval</template>
    </alerts>
    <alerts>
        <fullName>HW_CR_Review_Admin_Rejection_Email</fullName>
        <description>HW CR Review Admin Rejection Email</description>
        <protected>false</protected>
        <recipients>
            <recipient>mduncan1.md@motorola.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>wlbg02.md@motorola.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HW_Change_Management/HW_CR_Review_Rejection</template>
    </alerts>
    <alerts>
        <fullName>HW_CR_Reviewer_Approval_Confirmation</fullName>
        <description>HW CR Reviewer Approval Confirmation</description>
        <protected>false</protected>
        <recipients>
            <recipient>HWCRWorkflowAdmin</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HW_Change_Management/HW_CR_Initial_Review_Completion</template>
    </alerts>
    <alerts>
        <fullName>HW_CR_Reviewer_Rejection_Confirmation</fullName>
        <description>HW CR Reviewer Rejection Confirmation</description>
        <protected>false</protected>
        <recipients>
            <recipient>HWCRWorkflowAdmin</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HW_Change_Management/HW_CR_Initial_Review_Rejection</template>
    </alerts>
    <alerts>
        <fullName>HW_CR_SDE_Reviewer_2nd_Email</fullName>
        <description>HW CR SDE Reviewer 2nd Email</description>
        <protected>false</protected>
        <recipients>
            <field>SDE_Reviewer__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HW_Change_Management/HW_CR_SDE_Reviewer_Email2</template>
    </alerts>
    <alerts>
        <fullName>HW_CR_SDE_Reviewer_Final_Email</fullName>
        <description>HW CR SDE Reviewer Final Email</description>
        <protected>false</protected>
        <recipients>
            <field>SDE_Reviewer__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HW_Change_Management/HW_CR_SDE_Reviewer_Email3</template>
    </alerts>
    <alerts>
        <fullName>HW_CR_SDE_Reviewer_Initial_Email</fullName>
        <description>HW CR SDE Reviewer Initial Email</description>
        <protected>false</protected>
        <recipients>
            <field>SDE_Reviewer__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HW_Change_Management/HW_CR_Reviewer_Email_1</template>
    </alerts>
    <alerts>
        <fullName>HW_CR_SME_Reviewer_2nd_Email</fullName>
        <description>HW CR SME Reviewer 2nd Email</description>
        <protected>false</protected>
        <recipients>
            <field>SME_Reviewer__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HW_Change_Management/HW_CR_SME_Reviewer_Email2</template>
    </alerts>
    <alerts>
        <fullName>HW_CR_SME_Reviewer_Alert</fullName>
        <description>HW CR SME Reviewer Alert</description>
        <protected>false</protected>
        <recipients>
            <field>SME_Reviewer__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HW_Change_Management/HW_CR_Reviewer_Email_1</template>
    </alerts>
    <alerts>
        <fullName>HW_CR_SME_Reviewer_Final_Email</fullName>
        <description>HW CR SME Reviewer Final Email</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>SME_Reviewer__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HW_Change_Management/HW_CR_SME_Reviewer_Email3</template>
    </alerts>
    <alerts>
        <fullName>HW_CR_SME_Reviewer_Initial_Email</fullName>
        <description>HW CR SME Reviewer Initial Email</description>
        <protected>false</protected>
        <recipients>
            <field>SME_Reviewer__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HW_Change_Management/HW_CR_Reviewer_Email_1</template>
    </alerts>
    <alerts>
        <fullName>SME_Supplier_Inquiry_Email_Alert</fullName>
        <description>SME Supplier Inquiry Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Requester_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SME_Reviewer__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HW_Change_Management/SME_Data_Inquiry</template>
    </alerts>
    <alerts>
        <fullName>Supplier_Inquiry_Email_Alert</fullName>
        <description>SDE Supplier Inquiry Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Requester_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SDE_Reviewer__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HW_Change_Management/SDE_Data_Inquiry</template>
    </alerts>
    <fieldUpdates>
        <fullName>Initial_Review_Status_Approve</fullName>
        <description>Update action when record is approved or Rejected</description>
        <field>Initial_Review_Status__c</field>
        <formula>&quot;Approved&quot;</formula>
        <name>Initial Review Status Approve</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Initial_Review_Status_In_Process</fullName>
        <description>Reflecting record has been submitted</description>
        <field>Initial_Review_Status__c</field>
        <formula>&quot;In-Process&quot;</formula>
        <name>Initial Review Status In Process</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Initial_Review_Status_Reject</fullName>
        <description>Update to reject if rejection is noted</description>
        <field>Initial_Review_Status__c</field>
        <formula>&quot;Rejected&quot;</formula>
        <name>Initial Review Status Reject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_CM_Complete_Date</fullName>
        <description>Complete data of CM initial review</description>
        <field>CM_Close_Date__c</field>
        <formula>NOW()</formula>
        <name>Set CM Complete Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_SDE_Complete_Date</fullName>
        <description>Field update recording date-time of SDE approval rejection</description>
        <field>SDE_Close_Date__c</field>
        <formula>NOW()</formula>
        <name>Set SDE Complete Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_SME_Complete_Date</fullName>
        <description>Complete date of SME initial review.</description>
        <field>SME_Close_Date__c</field>
        <formula>NOW()</formula>
        <name>Set SME Complete Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CM Complete Date Stamp</fullName>
        <actions>
            <name>Set_CM_Complete_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>HW_CR_Initial_Review__c.HW_CR_CM_Response_Count__c</field>
            <operation>notEqual</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>HW_CR_Initial_Review__c.Category_Manager_Reviewer__c</field>
            <operation>notEqual</operation>
            <value>null</value>
        </criteriaItems>
        <description>Rule recording CM approval/rejection date to CM Complete Date field</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>HW CR Assign SDE Notification Email</fullName>
        <actions>
            <name>HW_CR_Initial_SDE_Owner_Requested</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>HW_CR_Initial_Review__c.SDE_Reviewer__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>If field SDE name is not known or the assigned SDE field is &apos;blank&apos; this rule will send email notification to SDE managers to help assign the proper person for review.</description>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>HW_CR_Initial_SDE_Owner_Requested_2</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>X5_Day_Delay_Require_SDE_Assignment</name>
                <type>Task</type>
            </actions>
            <timeLength>5</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>HW CR CM Reviewer Email</fullName>
        <actions>
            <name>HW_CR_CM_Reviewer_Initial_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>HW_CR_Initial_Review__c.CM_Assigned__c</field>
            <operation>equals</operation>
            <value>1</value>
        </criteriaItems>
        <criteriaItems>
            <field>HW_CR_Initial_Review__c.CM_Reviewer_Status__c</field>
            <operation>equals</operation>
            <value>Please Select</value>
        </criteriaItems>
        <description>Email reminding initial change request CM reviewer to complete activity within approval process.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>HW_CR_CM_Reviewer_2nd_email</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>HW_CR_Initial_Review__c.CreatedDate</offsetFromField>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>HW_CR_CM_Reviewer_Final_Email</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Reject_HCR_Resulting_from_CR_Delay</name>
                <type>Task</type>
            </actions>
            <offsetFromField>HW_CR_Initial_Review__c.CreatedDate</offsetFromField>
            <timeLength>4</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>HW CR CM Supplier Inquiry</fullName>
        <actions>
            <name>CM_Supplier_Inquiry_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>HW_CR_Initial_Review__c.CM_Reviewer_Status__c</field>
            <operation>equals</operation>
            <value>Require Further Info</value>
        </criteriaItems>
        <description>Supplier email notification is routed when any of the initial reviewers select a reviewer status of &apos;Require Further Info&apos; then save the record.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>HW CR Review Adm Approve Email</fullName>
        <actions>
            <name>HW_CR_Review_Admin_Email</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Create_Engineering_PE_Records</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>HW_CR_Initial_Review__c.HW_CR_Top_Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <description>Email to HW Change Management Admin alerting to initial review approval.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>HW CR Review Adm Reject Email</fullName>
        <actions>
            <name>HW_CR_Review_Admin_Rejection_Email</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Initial_Change_Review_Rejection_Notice</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>HW_CR_Initial_Review__c.HW_CR_Top_Status__c</field>
            <operation>equals</operation>
            <value>Rejected</value>
        </criteriaItems>
        <description>Email to HW Change Management Admin alerting to initial review rejection.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>HW CR SDE Reviewer Email</fullName>
        <actions>
            <name>HW_CR_SDE_Reviewer_Initial_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>HW_CR_Initial_Review__c.SDE_Assigned__c</field>
            <operation>equals</operation>
            <value>1</value>
        </criteriaItems>
        <criteriaItems>
            <field>HW_CR_Initial_Review__c.SDE_Reviewer_Status__c</field>
            <operation>equals</operation>
            <value>Please Select</value>
        </criteriaItems>
        <description>Email reminding initial change request SDE reviewer to complete activity within approval process.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>HW_CR_SDE_Reviewer_2nd_Email</name>
                <type>Alert</type>
            </actions>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>HW_CR_SDE_Reviewer_Final_Email</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Reject_HCR_Resulting_from_CR_Delay</name>
                <type>Task</type>
            </actions>
            <timeLength>4</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>HW CR SME Reviewer Email</fullName>
        <actions>
            <name>HW_CR_SME_Reviewer_Initial_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>HW_CR_Initial_Review__c.SME_Assigned__c</field>
            <operation>equals</operation>
            <value>1</value>
        </criteriaItems>
        <criteriaItems>
            <field>HW_CR_Initial_Review__c.SME_Reviewer_Status__c</field>
            <operation>equals</operation>
            <value>Please Select</value>
        </criteriaItems>
        <criteriaItems>
            <field>HW_CR_Initial_Review__c.SME_Reviewer__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>HW_CR_Initial_Review__c.HW_CR_Top_Status__c</field>
            <operation>notEqual</operation>
            <value>Approved</value>
        </criteriaItems>
        <description>Email reminding initial change request SME reviewer to complete activity within approval process.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>HW_CR_SME_Reviewer_2nd_Email</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>HW_CR_Initial_Review__c.CreatedDate</offsetFromField>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>HW_CR_SME_Reviewer_Final_Email</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Reject_HCR_Resulting_from_CR_Delay</name>
                <type>Task</type>
            </actions>
            <offsetFromField>HW_CR_Initial_Review__c.CreatedDate</offsetFromField>
            <timeLength>4</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>HW CR SME Supplier Inquiry</fullName>
        <actions>
            <name>SME_Supplier_Inquiry_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>HW_CR_Initial_Review__c.SME_Reviewer_Status__c</field>
            <operation>equals</operation>
            <value>Require Further Info</value>
        </criteriaItems>
        <description>Supplier email notification is routed when any of the initial reviewers select a reviewer status of &apos;Require Further Info&apos; then save the record.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>HW CR Send Task to ODM Reviewer - Hua</fullName>
        <actions>
            <name>ODM_Reviewer_Comments_needed2</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <formula>ODM_Reviewer__c = &quot;00540000001qEy8&quot;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>HW CR Send Task to ODM Reviewer - Yen</fullName>
        <actions>
            <name>ODM_Reviewer_Comments_needed</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <formula>ODM_Reviewer__c = &quot;00540000001qExy&quot;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>HW CR Supplier Inquiry</fullName>
        <actions>
            <name>Supplier_Inquiry_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>HW_CR_Initial_Review__c.SDE_Reviewer_Status__c</field>
            <operation>equals</operation>
            <value>Require Further Info</value>
        </criteriaItems>
        <description>Supplier email notification is routed when any of the initial reviewers select a reviewer status of &apos;Require Further Info&apos; then save the record.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SDE Complete Date Stamp</fullName>
        <actions>
            <name>Set_SDE_Complete_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>HW_CR_Initial_Review__c.HW_CR_SDE_Response_Count__c</field>
            <operation>notEqual</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>HW_CR_Initial_Review__c.SDE_Reviewer__c</field>
            <operation>notEqual</operation>
            <value>null</value>
        </criteriaItems>
        <description>Rule recording SDE approval/rejection date to SDE Complete Date field</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SME Complete Date Stamp</fullName>
        <actions>
            <name>Set_SME_Complete_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>HW_CR_Initial_Review__c.HW_CR_SME_Response_Count__c</field>
            <operation>notEqual</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>HW_CR_Initial_Review__c.SME_Reviewer__c</field>
            <operation>notEqual</operation>
            <value>null</value>
        </criteriaItems>
        <description>Rule recording SME approval/rejection date to SMEComplete Date field</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Create_Engineering_PE_Records</fullName>
        <assignedTo>HWCRWorkflowAdmin</assignedTo>
        <assignedToType>role</assignedToType>
        <description>Task assignment to HW CR Administration to create new engineering review and planning records. (PE Record Ids)</description>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>HW_CR_Initial_Review__c.CreatedDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Create Engineering PE Records</subject>
    </tasks>
    <tasks>
        <fullName>Initial_Change_Review_Rejection_Notice</fullName>
        <assignedTo>HWCRWorkflowAdmin</assignedTo>
        <assignedToType>role</assignedToType>
        <description>Initial review record is rejected.  Review rejection comments.  If change will not be pursued, update the HCR record to a top-status of &apos;rejected.&apos;  If change requires a new part number or additional action, follow comments then resubmit a new &apos;CR&apos; record</description>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Initial Change Review Rejection Notice</subject>
    </tasks>
    <tasks>
        <fullName>ODM_Reviewer_Comments_needed</fullName>
        <assignedTo>wlbg02.md@motorola.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>Brad,
&quot;Yen TianLeong&quot; is inactive. I am assigning this task to you.
 
A new PCN has been submitted into Schedule Share. 
Please review the impacted parts and and list parts that need to be evaluated by the ODM team in the ODM Reviewer Comment section.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>ODM Reviewer Comments needed</subject>
    </tasks>
    <tasks>
        <fullName>ODM_Reviewer_Comments_needed2</fullName>
        <assignedTo>wlbg02.md@motorola.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>A new PCN has been submitted into Schedule Share. 
Please review the impacted parts and and list parts that need to be evaluated by the ODM team in the ODM Reviewer Comment section</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>ODM Reviewer Comments needed</subject>
    </tasks>
    <tasks>
        <fullName>Reject_HCR_Resulting_from_CR_Delay</fullName>
        <assignedTo>HWCRWorkflowAdmin</assignedTo>
        <assignedToType>role</assignedToType>
        <description>Reject the CR record and associated HCR record for lack of response from assigned reviewers.  Ensure the reviewer name is listed as the contact within the Schedule Sharing PCN rejection comment.</description>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Reject HCR Resulting from CR Delay</subject>
    </tasks>
    <tasks>
        <fullName>X5_Day_Delay_Require_SDE_Assignment</fullName>
        <assignedTo>HWCRWorkflowAdmin</assignedTo>
        <assignedToType>role</assignedToType>
        <description>Task assignment to HW CR Entry Admin to personally follow with SDE assignment.</description>
        <dueDateOffset>2</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>5 Day Delay, Require SDE Assignment</subject>
    </tasks>
</Workflow>
