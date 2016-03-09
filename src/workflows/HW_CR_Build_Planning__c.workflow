<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_reminder_to_Engineering_and_HW_Admin_of_Testing_Update</fullName>
        <description>Email reminder to Engineering and HW Admin of Testing Update</description>
        <protected>false</protected>
        <recipients>
            <field>Central_Engineer_Contact__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HW_Change_Management/HW_CR_Build_Completed</template>
    </alerts>
    <alerts>
        <fullName>FBR_Scheduled_Alter_to_Engineering_and_HW_CR_Admin</fullName>
        <description>FBR Scheduled Alter to Engineering and HW CR Admin</description>
        <protected>false</protected>
        <recipients>
            <field>Central_Engineer_Contact__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>TOP_Contact__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HW_Change_Management/HW_CR_Build_Scheduled</template>
    </alerts>
    <rules>
        <fullName>HW CR Engineering Build Scheduled</fullName>
        <actions>
            <name>FBR_Scheduled_Alter_to_Engineering_and_HW_CR_Admin</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>HW_CR_Build_Planning__c.Requested_Ship_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>HW_CR_Build_Planning__c.FBR_Ready_for_Build__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>HW_CR_Build_Planning__c.Central_Engineer_Contact__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>HW_CR_Build_Planning__c.TOP_Contact__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Alert to key engineering contact and HW CR Admin of pilot scheduled.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Email_reminder_to_Engineering_and_HW_Admin_of_Testing_Update</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>HW_CR_Build_Planning__c.Build_Completion_Date__c</offsetFromField>
            <timeLength>10</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>HW CR FBR Initial Schedule</fullName>
        <actions>
            <name>HW_FBR_Released_for_Schedule_Confirmation</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>HW_CR_Build_Planning__c.FBR_Ready_for_Build__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>HW_CR_Build_Planning__c.Requested_Ship_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Creates an activity or event for pending FBR(s) with confirmed readiness set to &apos;true&apos;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>HW CR FBR Pending PO</fullName>
        <actions>
            <name>FBR_Awaiting_PO_Creation</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>HW_CR_Build_Planning__c.FBR_Ready_for_Build__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>HW_CR_Build_Planning__c.Build_Transceiver__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>HW_CR_Build_Planning__c.Transceiver_Cost__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>HW_CR_Build_Planning__c.Confirmed_Build_Qty__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <description>Creates a new task for active FBR(s) with confirmed readiness set to &apos;true&apos; and a confirmed build transceiver, transceiver cost, and confirmed build qty.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>FBR_Awaiting_PO_Creation</fullName>
        <assignedTo>HWCRWorkflowAdmin</assignedTo>
        <assignedToType>role</assignedToType>
        <description>A scheduled build request is awaiting purchase order creation.  PO(s) to be used for distribution of pilot transceivers.</description>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>FBR Awaiting PO Creation</subject>
    </tasks>
    <tasks>
        <fullName>HW_FBR_Released_for_Schedule_Confirmation</fullName>
        <assignedTo>wlbg02.md@motorola.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>Please note the requested ship date within this task.   Then complete/confirm the following &apos;Factory Execution&apos; fields before task completion:
Build Transceiver
Transceiver Cost
Confirmed Build Qty
Scheduled Build Date
Build Completion Date</description>
        <dueDateOffset>-4</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <offsetFromField>HW_CR_Build_Planning__c.Requested_Ship_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>HW FBR Released for Schedule Confirmation</subject>
    </tasks>
</Workflow>
