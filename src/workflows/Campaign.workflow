<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Campaign_Email_Alert_To_Analyzed_user</fullName>
        <description>Campaign Email Alert To Analyzed user</description>
        <protected>false</protected>
        <recipients>
            <field>Analyzed_By__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Campaign_Promotion_user_Assigned</template>
    </alerts>
    <alerts>
        <fullName>Campaign_Email_Alert_after_user_change</fullName>
        <description>Campaign Email Alert after user change</description>
        <protected>false</protected>
        <recipients>
            <field>Previous_Analyzed_by__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Campaign_Promotion_user_change</template>
    </alerts>
    <alerts>
        <fullName>Campaign_Promotion_without_Product_Reminder_Notification</fullName>
        <description>Campaign Promotion without Product Reminder Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Campaign_Promotion_without_Product</template>
    </alerts>
    <fieldUpdates>
        <fullName>Active_Promotion</fullName>
        <description>Promotion is Active based on the current Status of the promotion Campaign.</description>
        <field>IsActive</field>
        <literalValue>1</literalValue>
        <name>Active Promotion</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Campaign_Promotion_Status_Completed123</fullName>
        <description>Sets the Status to Completed when current date is past the Campaign End Date.</description>
        <field>Status</field>
        <literalValue>Completed</literalValue>
        <name>Campaign Promotion Status Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Campaign_Promotion_Status_Planned</fullName>
        <description>Sets the Status to Planned when current date is before campaign Start Date.</description>
        <field>Status</field>
        <literalValue>Planned</literalValue>
        <name>Campaign  Promotion Status Planned</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Campaign_Promotion_Status_Planned1</fullName>
        <description>Sets the Status to Planned when current date is before campaign Start Date.</description>
        <field>Status</field>
        <literalValue>Planned</literalValue>
        <name>Campaign Promotion Status Planned</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Immediate_Promotion_Status_Completed</fullName>
        <description>Promotion Status is set to Completed when current date is after the Campaign End Date.</description>
        <field>Status</field>
        <literalValue>Completed</literalValue>
        <name>Immediate Promotion Status Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Immediate_Promotion_Status_In_Progress</fullName>
        <field>Status</field>
        <literalValue>In Progress</literalValue>
        <name>Immediate Promotion Status In Progress</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Immediate_Promotion_Status_Planned</fullName>
        <description>Sets the Status to Planned when current date is before campaign Start Date.</description>
        <field>Status</field>
        <literalValue>Planned</literalValue>
        <name>Immediate Promotion Status Planned</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inactive_Promotion</fullName>
        <description>Promotion is Inactive based on the current Status of the promotion Campaign.</description>
        <field>IsActive</field>
        <literalValue>0</literalValue>
        <name>Inactive Promotion</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Prior_Email</fullName>
        <field>Previous_Analyzed_by__c</field>
        <formula>PRIORVALUE(Prior_Email__c)</formula>
        <name>Prior Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Promotion_Campaign_Status_In_Progress123</fullName>
        <description>Promotion Status is set to In Progress when current date is between the Campaign Start and End Dates.</description>
        <field>Status</field>
        <literalValue>In Progress</literalValue>
        <name>Promotion Campaign Status In Progress</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Promotion_Campaign_Status_Planned</fullName>
        <description>Promotion Status is set to Planned when current date is before the Campaign Start Date.</description>
        <field>Status</field>
        <literalValue>Planned</literalValue>
        <name>Promotion Campaign Status Planned</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Missing_Product_Last_Notified_Date</fullName>
        <description>Sets the Missing Product Last Notified Date to the current date.</description>
        <field>Missing_Product_Last_Notified_Date__c</field>
        <formula>BLANKVALUE( Missing_Product_Last_Notified_Date__c, Today())</formula>
        <name>Set Missing Product Last Notified Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TimeBased_Promotion_Status_Completed</fullName>
        <description>Promotion Status is set to Completed when current date is after the Campaign End Date.</description>
        <field>Status</field>
        <literalValue>Completed</literalValue>
        <name>TimeBased Promotion Status Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TimeBased_Promotion_Status_Completed123</fullName>
        <description>Promotion Status is set to In Progress when current date is between the Campaign Start and End Dates.</description>
        <field>Status</field>
        <literalValue>Completed</literalValue>
        <name>TimeBased Promotion Status Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TimeBased_Promotion_Status_In_Progress</fullName>
        <description>Change the Status from Planned to In Progress when current date is between the Campaign Start and End Dates.</description>
        <field>Status</field>
        <literalValue>In Progress</literalValue>
        <name>TimeBased Promotion Status In Progress</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Missing_Product_Last_Notify_Date</fullName>
        <description>Update the Missing Product Last Notified Date to current date since new notification was sent.</description>
        <field>Missing_Product_Last_Notified_Date__c</field>
        <formula>Today()</formula>
        <name>Update Missing Product Last Notify Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>test123456</fullName>
        <field>Status</field>
        <literalValue>Aborted</literalValue>
        <name>test123456</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Campaign Email Alert</fullName>
        <actions>
            <name>Campaign_Email_Alert_To_Analyzed_user</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Campaign_Email_Alert_after_user_change</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Prior_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Analyzed_By__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Campaign Promotion Active</fullName>
        <actions>
            <name>Active_Promotion</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Campaign.RecordTypeId</field>
            <operation>equals</operation>
            <value>Promotion</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.Status</field>
            <operation>equals</operation>
            <value>In Progress,Completed,Planned</value>
        </criteriaItems>
        <description>For Promotion Campaigns, sets the Active flag based on Status of the Campaign.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Campaign Promotion Inactive</fullName>
        <actions>
            <name>Inactive_Promotion</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Campaign.RecordTypeId</field>
            <operation>equals</operation>
            <value>Promotion</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.Status</field>
            <operation>equals</operation>
            <value>Aborted</value>
        </criteriaItems>
        <description>For Promotion Campaigns, clears the Active flag based on Status of the Campaign.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Campaign Promotion Status Completed</fullName>
        <actions>
            <name>Immediate_Promotion_Status_Completed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Change the Promotion Campaign Status to Completed when the current date is after the End Date</description>
        <formula>AND( RecordType.Name=&apos;Promotion&apos;, Today() &gt; EndDate, NOT(ISPICKVAL( Status, &apos;Aborted&apos;)) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Campaign Promotion Status In Progress</fullName>
        <actions>
            <name>Immediate_Promotion_Status_In_Progress</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update the Promotion Campaign Status based on the current date compared to the Start &amp; End Date</description>
        <formula>AND( RecordType.Name=&apos;Promotion&apos;, NOT(ISPICKVAL(Status, &quot;In Progress&quot;)), NOT(ISPICKVAL( Status, &apos;Aborted&apos;)), AND( Today() &gt;= StartDate, Today() &lt;= EndDate) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Campaign Promotion Status In Progress 2</fullName>
        <active>true</active>
        <description>Update the Promotion Campaign Status from In Progress to Completed after the End Date.</description>
        <formula>AND( RecordType.Name=&apos;Promotion&apos;, ISPICKVAL(Status, &quot;In Progress&quot;), NOT(ISPICKVAL( Status, &apos;Aborted&apos;)), AND( Today() &gt;= StartDate, Today() &lt;= EndDate) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>TimeBased_Promotion_Status_Completed</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Campaign.EndDate</offsetFromField>
            <timeLength>24</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Campaign Promotion Status Planned</fullName>
        <actions>
            <name>Immediate_Promotion_Status_Planned</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update the Promotion Campaign Status to Planned if the current date is prior to the Start Date.</description>
        <formula>AND( RecordType.Name=&apos;Promotion&apos;, Today() &lt; StartDate, NOT(ISPICKVAL( Status, &apos;Aborted&apos;)) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>TimeBased_Promotion_Status_In_Progress</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Campaign.StartDate</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Campaign Promotion without Product</fullName>
        <actions>
            <name>Set_Missing_Product_Last_Notified_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Identify Promotion Campaign that is intended to have associated products but does not have any products identified.</description>
        <formula>AND( MOD( TODAY() - DATE(1900, 1, 6), 7) &gt; 1,
 ISPICKVAL(Is_Product_Campaign__c, &apos;Yes&apos;),
 Product_Count__c = 0)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Campaign_Promotion_without_Product_Reminder_Notification</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Update_Missing_Product_Last_Notify_Date</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Campaign.Missing_Product_Last_Notified_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
