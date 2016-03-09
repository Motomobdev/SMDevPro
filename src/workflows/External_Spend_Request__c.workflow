<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>New_ESR_Engineering_Notification</fullName>
        <description>New ESR - Engineering Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>External_Spend_Request_Engineering_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>External_Spend_Requests/New_ESR_Notification</template>
    </alerts>
    <alerts>
        <fullName>New_ESR_Finance_Notification</fullName>
        <description>New ESR - Finance Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>External_Spend_Request_Finance_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>External_Spend_Requests/New_ESR_Notification</template>
    </alerts>
    <alerts>
        <fullName>New_ESR_IT_Notification</fullName>
        <description>New ESR - IT Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Requestors_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Submitters_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>External_Spend_Request_IT_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>External_Spend_Requests/New_ESR_Notification</template>
    </alerts>
    <alerts>
        <fullName>New_ESR_Legal_Notification</fullName>
        <description>New ESR - Legal Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>External_Spend_Request_Legal_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>External_Spend_Requests/New_ESR_Notification</template>
    </alerts>
    <alerts>
        <fullName>New_ESR_Marketing_Notification</fullName>
        <description>New ESR - Marketing Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>External_Spend_Request_Marketing_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>External_Spend_Requests/New_ESR_Notification</template>
    </alerts>
    <alerts>
        <fullName>New_ESR_Notify_HR</fullName>
        <description>New ESR - Notify HR</description>
        <protected>false</protected>
        <recipients>
            <recipient>External_Spend_Request_HR_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>External_Spend_Requests/New_ESR_Notification</template>
    </alerts>
    <alerts>
        <fullName>Notification_for_Pre_Approved_Negotiation_in_Progress</fullName>
        <description>Notification for Pre-Approved: Negotiation in Progress</description>
        <protected>false</protected>
        <recipients>
            <field>Requestors_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Submitters_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>bob.svoboda@motorola.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>g.hansen@motorola.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>haley@motorola.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>wdd010.md@motorola.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>xtwm64.md@motorola.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>External_Spend_Requests/Notification_For_Negotiation_in_Progress</template>
    </alerts>
    <alerts>
        <fullName>Notify_Corbus_Team</fullName>
        <description>Notify Corbus Team</description>
        <protected>false</protected>
        <recipients>
            <recipient>pellegrino@motorola.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>xtwm64.md@motorola.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>External_Spend_Requests/Ready_For_PO_Creation</template>
    </alerts>
    <alerts>
        <fullName>Notify_Corbus_Team_For_Extensions</fullName>
        <description>Notify Corbus Team For Extensions</description>
        <protected>false</protected>
        <recipients>
            <recipient>pellegrino@motorola.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>xtwm64.md@motorola.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>External_Spend_Requests/Ready_For_PO_Creation_For_Extensions</template>
    </alerts>
    <alerts>
        <fullName>Pre_Approved_Negotiation_in_Progress_For_Extensions</fullName>
        <description>Pre-Approved Negotiation in Progress For Extensions</description>
        <protected>false</protected>
        <recipients>
            <field>Requestors_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Submitters_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>bob.svoboda@motorola.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>g.hansen@motorola.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>haley@motorola.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>wdd010.md@motorola.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>xtwm64.md@motorola.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>External_Spend_Requests/Notify_For_Pre_Approved_Extensions</template>
    </alerts>
    <fieldUpdates>
        <fullName>ESR_Contract_Status_Cancelled</fullName>
        <description>Updates &quot;date cancelled&quot; field with today&apos;s date when the contract status changes to Cancelled</description>
        <field>Date_Cancelled__c</field>
        <formula>TODAY()</formula>
        <name>ESR Contract Status - Cancelled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ESR_Contract_Status_Executive_Summary</fullName>
        <field>Date_Executive_Summary__c</field>
        <formula>TODAY()</formula>
        <name>ESR Contract Status - Executive Summary</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ESR_Contract_Status_Pending_Final_Sign</fullName>
        <description>Updates &quot;Date Contract Pending Final Signature&quot; field with today&apos;s date when the contract status changes to &quot;Contract Pending Final Signature&quot;</description>
        <field>Date_Contract_Pending_Final_Signature__c</field>
        <formula>TODAY()</formula>
        <name>ESR Contract Status - Pending Final Sign</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ESR_Contract_Status_Pre_Approved</fullName>
        <description>Updates &quot;Date Pre Approved&quot; field with today&apos;s date when the contract status changes to &quot;Pre-Approved: Procurement Negotiation in Progress&quot;</description>
        <field>Date_Pre_Approved__c</field>
        <formula>TODAY()</formula>
        <name>ESR Contract Status - Pre-Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ESR_Contract_Status_Submitted_For_PR</fullName>
        <description>Updates &quot;Date Submitted for PR Creation&quot; field with today&apos;s date when the contract status changes to &quot;Submitted for PR Creation&quot;</description>
        <field>Date_Submitted_for_PR_Creation__c</field>
        <formula>TODAY()</formula>
        <name>ESR Contract Status - Submitted for PR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ESR_Date_On_Hold_Update</fullName>
        <description>Updates &quot;Date on hold&quot; with today&apos;s date when the contract status changes to &quot;On Hold&quot;</description>
        <field>Date_On_Hold__c</field>
        <formula>TODAY()</formula>
        <name>ESR Date On Hold Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ESR_RFX_Date_Update</fullName>
        <description>Updates RFX Date field</description>
        <field>RFX_Date__c</field>
        <formula>TODAY()</formula>
        <name>ESR RFX Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_Generate_ESR_Email_field_value</fullName>
        <description>Reset field value to False</description>
        <field>Generate_ESR_Email__c</field>
        <literalValue>0</literalValue>
        <name>Reset Generate ESR Email field value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Generate_ESR_Email_field_value</fullName>
        <description>Set Generate ESR Email field value to True</description>
        <field>Generate_ESR_Email__c</field>
        <literalValue>1</literalValue>
        <name>Set Generate ESR Email field value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>ESR Contract Status - Cancelled</fullName>
        <actions>
            <name>ESR_Contract_Status_Cancelled</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates &quot;date cancelled&quot; field with today&apos;s date when the contract status changes to Cancelled</description>
        <formula>ISPICKVAL(Contract_Status__c, &apos;Cancelled&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ESR Contract Status - Contract Pending Final Signature</fullName>
        <actions>
            <name>ESR_Contract_Status_Pending_Final_Sign</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates &quot;Date Executive Summary&quot; field with today&apos;s date when the contract status changes to &quot;Contract Pending Final Signature&quot;</description>
        <formula>ISPICKVAL(Contract_Status__c, &apos;Contract Pending Final Signature&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ESR Contract Status - Executive Summary</fullName>
        <actions>
            <name>ESR_Contract_Status_Executive_Summary</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates &quot;Date Executive Summary&quot; field with today&apos;s date when the contract status changes to &quot;Executive Summary Approvals In Progress&quot;</description>
        <formula>ISPICKVAL(Contract_Status__c, &apos;Executive Summary Approvals In Progress&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ESR Contract Status - On Hold</fullName>
        <actions>
            <name>ESR_Date_On_Hold_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates &quot;Date On Hold&quot; field with today&apos;s date when the contract status changes to &quot;On Hold&quot;</description>
        <formula>ISPICKVAL(Contract_Status__c, &apos;On Hold&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ESR Contract Status - Pre-Approved</fullName>
        <actions>
            <name>ESR_Contract_Status_Pre_Approved</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates &quot;Date Pre Approved&quot; field with today&apos;s date when the contract status changes to &quot;Pre-Approved: Procurement Negotiation in Progress&quot;</description>
        <formula>ISPICKVAL(Contract_Status__c, &apos;Pre-Approved: Procurement Negotiation in Progress&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ESR Contract Status - RFX</fullName>
        <actions>
            <name>ESR_RFX_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates RFX date field with today&apos;s date when the contract status changes to RFX</description>
        <formula>ISPICKVAL(Contract_Status__c, &apos;RFX&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ESR Contract Status - Submitted for PR Creation</fullName>
        <actions>
            <name>ESR_Contract_Status_Submitted_For_PR</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates &quot;Date Submitted for PR Creation&quot; field with today&apos;s date when the contract status changes to &quot;Submitted for PR Creation&quot;</description>
        <formula>ISPICKVAL(Contract_Status__c, &apos;Submitted for PR Creation&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>New ESR - Notify Engineering</fullName>
        <actions>
            <name>New_ESR_Engineering_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Notifies ESR Engineering Group upon the creation of ESR with a business function of Engineering</description>
        <formula>AND( ISPICKVAL(Business_Function__c,  &apos;Engineering&apos;),  Number_Of_Cost_Records_From_Portal__c =  Number_Of_Cost_Records_From_SFDC__c )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>New ESR - Notify Finance</fullName>
        <actions>
            <name>New_ESR_Finance_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Notifies ESR Finance Group upon the creation of ESR with a business function of Finance</description>
        <formula>AND( ISPICKVAL(Business_Function__c,  &apos;Finance&apos;),  Number_Of_Cost_Records_From_Portal__c =  Number_Of_Cost_Records_From_SFDC__c )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>New ESR - Notify HR</fullName>
        <actions>
            <name>New_ESR_Notify_HR</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Notifies ESR HR Group upon the creation of ESR with a business function of HR</description>
        <formula>AND( ISPICKVAL(Business_Function__c,  &apos;HR&apos;),  Number_Of_Cost_Records_From_Portal__c =  Number_Of_Cost_Records_From_SFDC__c )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>New ESR - Notify IT</fullName>
        <actions>
            <name>New_ESR_IT_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Notifies ESR IT Group upon the creation of ESR with a business function of IT</description>
        <formula>AND( ISPICKVAL(Business_Function__c,  &apos;IT&apos;),  Number_Of_Cost_Records_From_Portal__c =  Number_Of_Cost_Records_From_SFDC__c )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>New ESR - Notify Legal</fullName>
        <actions>
            <name>New_ESR_Legal_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Notifies ESR Legal Group upon the creation of ESR with a business function of Legal</description>
        <formula>AND( ISPICKVAL(Business_Function__c,  &apos;Legal&apos;),  Number_Of_Cost_Records_From_Portal__c =  Number_Of_Cost_Records_From_SFDC__c )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>New ESR - Notify Marketing</fullName>
        <actions>
            <name>New_ESR_Marketing_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Notifies ESR Marketing Group upon the creation of ESR with a business function of Marketing</description>
        <formula>AND( ISPICKVAL(Business_Function__c,  &apos;Marketing&apos;),  Number_Of_Cost_Records_From_Portal__c =  Number_Of_Cost_Records_From_SFDC__c )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notification for Pre-Approved%3A Negotiation in Progress</fullName>
        <actions>
            <name>Notification_for_Pre_Approved_Negotiation_in_Progress</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Reset_Generate_ESR_Email_field_value</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>External_Spend_Request__c.Contract_Status__c</field>
            <operation>equals</operation>
            <value>Pre-Approved: Negotiation in Progress</value>
        </criteriaItems>
        <criteriaItems>
            <field>External_Spend_Request__c.Extension_or_change_order_to_a_contract__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>External_Spend_Request__c.Generate_ESR_Email__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>See WF &apos;Set Generate ESR Email field value&apos;.
Notifies users when non-extended ESR status changes to &quot;Pre-Approved: Negotiation in Progress&quot;. Meant for ESR that don&apos;t require Mot. Signature and have to be directly created in the SMART app</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notification for Pre-Approved%3A Negotiation in Progress For Extensions</fullName>
        <actions>
            <name>Pre_Approved_Negotiation_in_Progress_For_Extensions</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Reset_Generate_ESR_Email_field_value</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>External_Spend_Request__c.Contract_Status__c</field>
            <operation>equals</operation>
            <value>Pre-Approved: Negotiation in Progress</value>
        </criteriaItems>
        <criteriaItems>
            <field>External_Spend_Request__c.Extension_or_change_order_to_a_contract__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>External_Spend_Request__c.Generate_ESR_Email__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>See WF &apos;Set Generate ESR Email field value for Extensions&apos;.
Notifies users when the extended ESR status changes to &quot;Pre-Approved: Negotiation in Progress&quot;. Meant for ESR that don&apos;t require Mot. Signature and have to be directly created in the SMART app</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notify Corbus Team</fullName>
        <actions>
            <name>Notify_Corbus_Team</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>External_Spend_Request__c.Contract_Status__c</field>
            <operation>equals</operation>
            <value>Submitted for PR Creation</value>
        </criteriaItems>
        <criteriaItems>
            <field>External_Spend_Request__c.Extension_or_change_order_to_a_contract__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>The &quot;Submitted for PR Creation&quot; contract statusfor non-extended ESRs trigger an email to the CORBUS team to create a PR in Ariba application</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notify Corbus Team For Extensions</fullName>
        <actions>
            <name>Notify_Corbus_Team_For_Extensions</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>External_Spend_Request__c.Contract_Status__c</field>
            <operation>equals</operation>
            <value>Submitted for PR Creation</value>
        </criteriaItems>
        <criteriaItems>
            <field>External_Spend_Request__c.Extension_or_change_order_to_a_contract__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>The &quot;Submitted for PR Creation&quot; contract statusfor non-extended ESRs trigger an email to the CORBUS team to create a PR in Ariba application</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Generate ESR Email field value</fullName>
        <actions>
            <name>Set_Generate_ESR_Email_field_value</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>External_Spend_Request__c.Contract_Status__c</field>
            <operation>equals</operation>
            <value>Pre-Approved: Negotiation in Progress</value>
        </criteriaItems>
        <criteriaItems>
            <field>External_Spend_Request__c.Extension_or_change_order_to_a_contract__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Set &apos;Generate ESR Email&apos; field value to True.
This will trigger workflow &apos;Notification for Pre-Approved: Negotiation in Progress&apos;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Generate ESR Email field value for Extensions</fullName>
        <actions>
            <name>Set_Generate_ESR_Email_field_value</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>External_Spend_Request__c.Contract_Status__c</field>
            <operation>equals</operation>
            <value>Pre-Approved: Negotiation in Progress</value>
        </criteriaItems>
        <criteriaItems>
            <field>External_Spend_Request__c.Extension_or_change_order_to_a_contract__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Set &apos;Generate ESR Email&apos; field value to True.
This will trigger workflow &apos;Notification for Pre-Approved: Negotiation in Progress For Extensions&apos;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
