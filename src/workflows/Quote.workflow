<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Deal_Approved_Notice</fullName>
        <ccEmails>cpratt@motorola.com</ccEmails>
        <ccEmails>mikel@motorola.com</ccEmails>
        <description>Deal Approved Notice</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Deal_Templates/Deal_Approved_Notice</template>
    </alerts>
    <alerts>
        <fullName>Deal_Rejection_Notice</fullName>
        <ccEmails>cpratt@motorola.com</ccEmails>
        <ccEmails>mikel@motorola.com</ccEmails>
        <description>Deal Rejection Notice</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Deal_Templates/Deal_Rejection_Notification</template>
    </alerts>
    <alerts>
        <fullName>Deal_Review_Date</fullName>
        <description>Deal Review Date</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Deal_Templates/Deal_New_Notification</template>
    </alerts>
    <alerts>
        <fullName>Deal_Review_Date_is_changed_notify_Owner</fullName>
        <description>Deal Review Date is changed notify Owner</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Deal_Templates/Deal_Creator_Changed_Notification</template>
    </alerts>
    <alerts>
        <fullName>New_Deal_Created</fullName>
        <description>New Deal Created</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Deal_Templates/Deal_creation_Notification</template>
    </alerts>
    <alerts>
        <fullName>Notify_Creator_when_Rejected</fullName>
        <description>Notify Creator when Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>eis@motorola.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Deal_Templates/Deal_Approved_Rejected_Notification</template>
    </alerts>
    <alerts>
        <fullName>Notify_Owner_when_approved</fullName>
        <description>Notify Owner when approved</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>eis@motorola.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Deal_Templates/Deal_Approved_Rejected_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>Deal_Approved</fullName>
        <description>Deal approval by all parties changes the status to &quot;Approved&quot;</description>
        <field>Status</field>
        <literalValue>Approved</literalValue>
        <name>Deal Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Deal_Approved_2</fullName>
        <field>Status</field>
        <literalValue>Approved</literalValue>
        <name>Deal Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Deal_Awaiting_Approval</fullName>
        <description>When a deal is &apos;Submit for Approval&apos; then update the Status to the same.</description>
        <field>Status</field>
        <literalValue>Submitted for Approval</literalValue>
        <name>Deal Awaiting Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Deal_New</fullName>
        <field>Status</field>
        <literalValue>New</literalValue>
        <name>Deal New</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Deal_Pending_Approval</fullName>
        <field>Status</field>
        <literalValue>Submitted for Approval</literalValue>
        <name>Deal Pending Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Deal_Recalled</fullName>
        <field>Status</field>
        <literalValue>New</literalValue>
        <name>Deal Recalled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Deal_Rejected</fullName>
        <field>Status</field>
        <literalValue>Rejected</literalValue>
        <name>Deal Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Deal_Rejected_2</fullName>
        <field>Status</field>
        <literalValue>Rejected</literalValue>
        <name>Deal Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Deal_Rejection_Counter</fullName>
        <field>Rejection_Counter__c</field>
        <formula>IF( 
ISNULL( Rejection_Counter__c ), 
1, 
Rejection_Counter__c + 1 
)</formula>
        <name>Deal Rejection Counter</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Deal_Submission</fullName>
        <description>Deal submission for approval changes deal status to &quot;Submitted for Approval&quot;</description>
        <field>Status</field>
        <literalValue>Submitted for Approval</literalValue>
        <name>Deal Submission</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Deal_Submission_Counter</fullName>
        <field>Submit_Counter__c</field>
        <formula>IF (ISNULL(Submit_Counter__c), 1, Submit_Counter__c + 1)</formula>
        <name>Deal Submission Counter</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Deal_Submit_Counter</fullName>
        <field>Submit_Counter__c</field>
        <formula>IF (ISNULL(Submit_Counter__c), 1, Submit_Counter__c + 1)</formula>
        <name>Deal Submit Counter</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Quote_Approved</fullName>
        <field>Status</field>
        <literalValue>Approved</literalValue>
        <name>Deal Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Quote_Rejected</fullName>
        <field>Status</field>
        <literalValue>Rejected</literalValue>
        <name>Deal Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_Executive_Summary</fullName>
        <field>HasExecutiveSummary__c</field>
        <literalValue>0</literalValue>
        <name>Reset Executive Summary</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_MDF_SDF_Discount_Criteria</fullName>
        <field>HasMDFSDFDiscount__c</field>
        <literalValue>No</literalValue>
        <name>Reset MDF/SDF Discount Criteria</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_MDF_SDF_Total_Criteria</fullName>
        <field>IsMDFSDFDiscount500k__c</field>
        <literalValue>No</literalValue>
        <name>Reset MDF/SDF Total Criteria</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_NSBD_Criteria</fullName>
        <field>IsNSBD25M__c</field>
        <literalValue>No</literalValue>
        <name>Reset NSBD Criteria</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_Stoplight</fullName>
        <field>HasStoplight__c</field>
        <literalValue>0</literalValue>
        <name>Reset Stoplight</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_Total_A_P_Criteria</fullName>
        <field>Is_A_P_Requested__c</field>
        <literalValue>No</literalValue>
        <name>Reset Total A&amp;P Criteria</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_Total_Discount_Criteria</fullName>
        <field>IsTotalDiscount100k__c</field>
        <literalValue>No</literalValue>
        <name>Reset Total Discount Criteria</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_A_P_Fund_Criteria</fullName>
        <field>Is_A_P_Requested__c</field>
        <literalValue>Yes</literalValue>
        <name>Set A&amp;P Fund Criteria</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Executive_Summary</fullName>
        <field>HasExecutiveSummary__c</field>
        <literalValue>1</literalValue>
        <name>Set Executive Summary</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_MDF_SDF_Discount_Criteria</fullName>
        <description>Key criteria by which a deal is evaluated</description>
        <field>HasMDFSDFDiscount__c</field>
        <literalValue>Yes</literalValue>
        <name>Set MDF/SDF Discount Criteria</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_MDF_SDF_Total_Criteria</fullName>
        <field>IsMDFSDFDiscount500k__c</field>
        <literalValue>Yes</literalValue>
        <name>Set MDF/SDF Total Criteria</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_NSBD_Criteria</fullName>
        <field>IsNSBD25M__c</field>
        <literalValue>Yes</literalValue>
        <name>Set NSBD Criteria</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Stoplight</fullName>
        <field>HasStoplight__c</field>
        <literalValue>1</literalValue>
        <name>Set Stoplight</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Total_Discount_Criteria</fullName>
        <field>IsTotalDiscount100k__c</field>
        <literalValue>Yes</literalValue>
        <name>Set Total Discount Criteria</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>setDealName</fullName>
        <field>Name</field>
        <formula>&quot;Deal&quot; + &quot;-&quot; + Opportunity.Name + &quot;-&quot; + QuoteNumber</formula>
        <name>setDealName</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>setExecutiveSummaryFalse</fullName>
        <field>HasExecutiveSummary__c</field>
        <literalValue>0</literalValue>
        <name>setExecutiveSummaryFalse</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>setExecutiveSummaryTrue</fullName>
        <field>HasExecutiveSummary__c</field>
        <literalValue>1</literalValue>
        <name>setExecutiveSummaryTrue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>setStoplightFalse</fullName>
        <field>HasStoplight__c</field>
        <literalValue>0</literalValue>
        <name>setStoplightFalse</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>setStoplightTrue</fullName>
        <field>HasStoplight__c</field>
        <literalValue>1</literalValue>
        <name>setStoplightTrue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>setSummaryFalse</fullName>
        <field>HasSummary__c</field>
        <literalValue>0</literalValue>
        <name>setSummaryFalse</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>setSummaryTrue</fullName>
        <field>HasSummary__c</field>
        <literalValue>1</literalValue>
        <name>setSummaryTrue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Deal Evaluation Criteria - A%26P Requested</fullName>
        <actions>
            <name>Set_A_P_Fund_Criteria</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Key criteria by which a deal is evaluated</description>
        <formula>Total_A_P__c &gt; 0</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Deal Evaluation Criteria - Default A%26P Requested</fullName>
        <actions>
            <name>Reset_Total_A_P_Criteria</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Key criteria by which a deal is evaluated</description>
        <formula>Total_A_P__c = 0</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Deal Evaluation Criteria - Default MDF%2FSDF Discount</fullName>
        <actions>
            <name>Reset_MDF_SDF_Discount_Criteria</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Key criteria by which a deal is evaluated</description>
        <formula>Total_MDF__c + Total_SDF__c = 0</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Deal Evaluation Criteria - Default MDF%2FSDF Total</fullName>
        <actions>
            <name>Reset_MDF_SDF_Total_Criteria</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Key criteria by which a deal is evaluated</description>
        <formula>Total_MDF__c + Total_SDF__c  &lt;= 500000</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Deal Evaluation Criteria - Default NSBD</fullName>
        <actions>
            <name>Reset_NSBD_Criteria</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Key criteria by which a deal is evaluated</description>
        <formula>Total_NSBD__c &lt;= 25000000</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Deal Evaluation Criteria - Default Total Discount</fullName>
        <actions>
            <name>Reset_Total_Discount_Criteria</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Key criteria by which a deal is evaluated</description>
        <formula>Total_Discount__c &lt;= 100000</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Deal Evaluation Criteria - Executive Summary</fullName>
        <actions>
            <name>Set_Executive_Summary</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Key criteria by which a deal is evaluated</description>
        <formula>NOT(ISBLANK(ExecutiveSummary__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Deal Evaluation Criteria - MDF%2FSDF Discount</fullName>
        <actions>
            <name>Set_MDF_SDF_Discount_Criteria</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Key criteria by which a deal is evaluated</description>
        <formula>Total_MDF__c + Total_SDF__c &gt; 0</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Deal Evaluation Criteria - MDF%2FSDF Total</fullName>
        <actions>
            <name>Set_MDF_SDF_Total_Criteria</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Key criteria by which a deal is evaluated</description>
        <formula>Total_MDF__c + Total_SDF__c  &gt; 500000</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Deal Evaluation Criteria - NSBD</fullName>
        <actions>
            <name>Set_NSBD_Criteria</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Key criteria by which a deal is evaluated</description>
        <formula>Total_NSBD__c &gt; 25000000</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Deal Evaluation Criteria - Stoplight</fullName>
        <actions>
            <name>Set_Stoplight</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Key criteria by which a deal is evaluated</description>
        <formula>StoplightRecords__c &gt; 0</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Deal Evaluation Criteria - Total Discount</fullName>
        <actions>
            <name>Set_Total_Discount_Criteria</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Key criteria by which a deal is evaluated</description>
        <formula>Total_Discount__c &gt; 100000</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Deal Review Date</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Quote.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Deal_Review_Date</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Quote.Deal_Review_Date__c</offsetFromField>
            <timeLength>-24</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Deal Review Date is changed on owned record</fullName>
        <actions>
            <name>Deal_Review_Date_is_changed_notify_Owner</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Deal_Review_Date__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>New Deal Notification</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Quote.RecordTypeId</field>
            <operation>equals</operation>
            <value>Deal,Bundle Deal</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>New_Deal_Created</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Quote.CreatedDate</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>setDealName</fullName>
        <actions>
            <name>setDealName</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>User.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>setExecutiveSummaryFalse</fullName>
        <actions>
            <name>setExecutiveSummaryFalse</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Quote.ExecutiveSummary__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>setExecutiveSummaryTrue</fullName>
        <actions>
            <name>setExecutiveSummaryTrue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Quote.ExecutiveSummary__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>setStoplightFalse</fullName>
        <actions>
            <name>setStoplightFalse</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Quote.StoplightRecords__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>setStoplightTrue</fullName>
        <actions>
            <name>setStoplightTrue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Quote.StoplightRecords__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>setSummaryFalse</fullName>
        <actions>
            <name>setSummaryFalse</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Quote.NumberUnits__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>setSummaryTrue</fullName>
        <actions>
            <name>setSummaryTrue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Quote.NumberUnits__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
