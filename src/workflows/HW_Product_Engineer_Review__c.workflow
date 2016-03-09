<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CR_New_PE_Record_Engineering_Notification</fullName>
        <description>CR - New PE Record Engineering Notification.</description>
        <protected>false</protected>
        <recipients>
            <field>ProductEngineers__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HW_Change_Management/HW_CR_Engineer_New_Review_Record</template>
    </alerts>
    <alerts>
        <fullName>Engineering_2nd_Reminder_Pending_PE_Review</fullName>
        <description>Engineering 2nd Reminder Pending PE Review</description>
        <protected>false</protected>
        <recipients>
            <field>ProductEngineers__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HW_Change_Management/HW_CR_Engineer_Review_Reminder</template>
    </alerts>
    <alerts>
        <fullName>Engineering_2nd_Reminder_Pending_PE_Reviews</fullName>
        <description>Engineering 2nd Reminder Pending PE Review</description>
        <protected>false</protected>
        <recipients>
            <field>ProductEngineers__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HW_Change_Management/HW_CR_Engineer_Review_Reminder</template>
    </alerts>
    <alerts>
        <fullName>Engineering_Final_Reminder_Pending_PE_Review</fullName>
        <description>Engineering Final Reminder Pending PE Review</description>
        <protected>false</protected>
        <recipients>
            <recipient>mduncan1.md@motorola.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>wlbg02.md@motorola.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>ProductEngineers__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HW_Change_Management/HW_CR_Engineer_Review_Final_Message</template>
    </alerts>
    <alerts>
        <fullName>Engineering_Reassignment_PE_Review_Record</fullName>
        <description>Engineering Reassignment PE Review Record</description>
        <protected>false</protected>
        <recipients>
            <field>ProductEngineers__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HW_Change_Management/HW_CR_Engineer_Reassign_Review_Record</template>
    </alerts>
    <alerts>
        <fullName>HW_CR_Administrator_Reject_Notice_Engineer_Review</fullName>
        <description>HW CR Administrator Reject Notice (Engineer Review)</description>
        <protected>false</protected>
        <recipients>
            <recipient>HWCRWorkflowAdmin</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HW_Change_Management/HW_CR_ADM_REJECT_NOTICE_PE_REVIEW</template>
    </alerts>
    <alerts>
        <fullName>HW_PE_Record_Reassignment</fullName>
        <description>HW PE Record Reassignment</description>
        <protected>false</protected>
        <recipients>
            <field>ProductEngineers__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HW_Change_Management/HW_CR_Engineer_Reassign_Review_Record</template>
    </alerts>
    <rules>
        <fullName>CR- PE Engineer Reassignment eMail</fullName>
        <actions>
            <name>HW_PE_Record_Reassignment</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send email notification to re-assigned engineering owner.</description>
        <formula>ISCHANGED(ProductEngineers__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>New Assignment Record Engineer eMail Alert</fullName>
        <actions>
            <name>CR_New_PE_Record_Engineering_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>HW_Product_Engineer_Review__c.Test_Required__c</field>
            <operation>equals</operation>
            <value>Please Select</value>
        </criteriaItems>
        <criteriaItems>
            <field>HW_Product_Engineer_Review__c.ProductEngineers__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Upon record creation new engineering review notice is sent.</description>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>HW_CR_Administrator_Reject_Notice_Engineer_Review</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Reject_Change_Record_Resulting_from_Engineering_Delay</name>
                <type>Task</type>
            </actions>
            <offsetFromField>HW_Product_Engineer_Review__c.CreatedDate</offsetFromField>
            <timeLength>6</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Engineering_Final_Reminder_Pending_PE_Review</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>HW_Product_Engineer_Review__c.CreatedDate</offsetFromField>
            <timeLength>5</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Engineering_2nd_Reminder_Pending_PE_Reviews</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>HW_Product_Engineer_Review__c.CreatedDate</offsetFromField>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>PE Review Completed</fullName>
        <actions>
            <name>Completed_PE_Record_Requiring_Build</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>HW_Product_Engineer_Review__c.Test_Required__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <description>Rule triggering task assignment to HW Change Build Admin.  Task is reminder to add the PE record to new or pending FBR (build request).</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Completed_PE_Record_Requiring_Build</fullName>
        <assignedTo>wlbg02.md@motorola.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>Task for creating an activity for tracking change records requiring individual product assessment.  Task assigned to HW CR Build Admin.</description>
        <dueDateOffset>4</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Completed PE Record Needing FBR</subject>
    </tasks>
    <tasks>
        <fullName>Reject_Change_Record_Resulting_from_Engineering_Delay</fullName>
        <assignedTo>HWCRWorkflowAdmin</assignedTo>
        <assignedToType>role</assignedToType>
        <description>Either contact the assigned engineer for the PE record, or reject the record along with all other open engineering review records.  Ultimately reject the top HCR record for delay citing the engineering owner as primary contact.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Reject_Change_Record_Resulting_from_Engineering_Delay</subject>
    </tasks>
</Workflow>
