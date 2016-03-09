<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Engineer_Email_Notification_of_Pending_New_Part_Actvitiy</fullName>
        <description>Engineer Email Notification of Pending New Part Actvitiy</description>
        <protected>false</protected>
        <recipients>
            <field>Specification_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HW_Change_Management/HW_CR_New_Part_Engineer_Notice</template>
    </alerts>
    <alerts>
        <fullName>SDE_Email_Notification_of_Pending_New_Part_Actvitiy</fullName>
        <description>SDE Email Notification of Pending New Part Actvitiy</description>
        <protected>false</protected>
        <recipients>
            <field>SDE_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HW_Change_Management/HW_CR_New_Part_SDE_Notice</template>
    </alerts>
    <rules>
        <fullName>HW CR New Part Admin Task</fullName>
        <actions>
            <name>Verify_New_Part_Request</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>HW_CR_New_Part_Request__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Notification to change admin to review the new part request and ensure proper SDE + Engineer assignment.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>New Part SDE Owner Alert1</fullName>
        <actions>
            <name>SDE_Email_Notification_of_Pending_New_Part_Actvitiy</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>HW_CR_New_Part_Request__c.Spec_Released__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>HW_CR_New_Part_Request__c.SDE_Owner__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>HW_CR_New_Part_Request__c.ePAF_Complete__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>HW_CR_New_Part_Request__c.W18_Compliance__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Notification to the assigned SDE to confirm basic qualification data is available; w18, signed PAF, and qual-pack.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>SDE_Email_Notification_of_Pending_New_Part_Actvitiy</name>
                <type>Alert</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>SDE_Email_Notification_of_Pending_New_Part_Actvitiy</name>
                <type>Alert</type>
            </actions>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>New Part Spec Owner Alert</fullName>
        <actions>
            <name>Engineer_Email_Notification_of_Pending_New_Part_Actvitiy</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>HW_CR_New_Part_Request__c.Specification_Owner__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>HW_CR_New_Part_Request__c.New_Part_Series_Number__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>HW_CR_New_Part_Request__c.Spec_Released__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Notification to the assigned engineer to confirm part number availability and specification release.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Engineer_Email_Notification_of_Pending_New_Part_Actvitiy</name>
                <type>Alert</type>
            </actions>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Engineer_Email_Notification_of_Pending_New_Part_Actvitiy</name>
                <type>Alert</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <tasks>
        <fullName>Verify_New_Part_Request</fullName>
        <assignedTo>wlbg02.md@motorola.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>Review request to ensure engineer and SDE assignment.</description>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <offsetFromField>HW_CR_New_Part_Request__c.CreatedDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Verify New Part Request</subject>
    </tasks>
</Workflow>
