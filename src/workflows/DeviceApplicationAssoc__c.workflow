<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Approval_Rejection_E_Mail</fullName>
        <description>Approval Rejection E-Mail</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Approval_Rejection_E_Mail</template>
    </alerts>
    <alerts>
        <fullName>Approval_Status_Change_Alert</fullName>
        <description>Approval Status Change Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>dkjq86@motorola.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>elias@motorola.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Approval_Status_Change</template>
    </alerts>
    <fieldUpdates>
        <fullName>AIF_Approval_Status_Approved</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>AIF Approval Status Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIF_Approval_Status_In_Progress</fullName>
        <field>Approval_Status__c</field>
        <literalValue>In Progress</literalValue>
        <name>AIF Approval Status In Progress</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIF_Approval_Status_Not_Submitted</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Not Submitted</literalValue>
        <name>AIF Approval Status Not Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AIF_Approval_Status_Rejected</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>AIF Approval Status Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>App_Manager_Status_Approved</fullName>
        <field>Application_Mgr_Selection_Approval__c</field>
        <literalValue>Approved</literalValue>
        <name>App Manager Status Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>App_Mgr_Phase_Approved</fullName>
        <field>Application_Mgr_Selection_Approval__c</field>
        <literalValue>Approved</literalValue>
        <name>App Mgr Phase - Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>App_Mgr_Phase_In_Progress</fullName>
        <field>Application_Mgr_Selection_Approval__c</field>
        <literalValue>In Progress</literalValue>
        <name>App Mgr Phase - In Progress</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>App_Mgr_Phase_NA</fullName>
        <field>Application_Mgr_Selection_Approval__c</field>
        <literalValue>N/A</literalValue>
        <name>App Mgr Phase - N/A</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>App_Mgr_Phase_Rejected</fullName>
        <field>Application_Mgr_Selection_Approval__c</field>
        <literalValue>Rejected</literalValue>
        <name>App Mgr Phase - Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Budget_Royalties_Status_Approved</fullName>
        <field>Confirmation_of_Budget_Royalties__c</field>
        <literalValue>Approved</literalValue>
        <name>Budget Royalties Status Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Budget_for_Royalties_Phase_N_A</fullName>
        <field>Confirmation_of_Budget_Royalties__c</field>
        <literalValue>N/A</literalValue>
        <name>Budget for Royalties Phase N/A</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Budget_for_Royalty_Phase_Approved</fullName>
        <field>Confirmation_of_Budget_Royalties__c</field>
        <literalValue>Approved</literalValue>
        <name>Budget for Royalty Phase - Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Budget_for_Royalty_Phase_In_progress</fullName>
        <field>Confirmation_of_Budget_Royalties__c</field>
        <literalValue>In Progress</literalValue>
        <name>Budget for Royalty Phase - In progress</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Budget_for_Royalty_Phase_Rejected</fullName>
        <field>Confirmation_of_Budget_Royalties__c</field>
        <literalValue>Rejected</literalValue>
        <name>Budget for Royalty Phase Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Conditional_Approval_on_Approval_Status</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Conditional</literalValue>
        <name>Conditional Approval on Approval Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DTS_Phase_Approved</fullName>
        <field>DTS_Approval__c</field>
        <literalValue>Approved</literalValue>
        <name>DTS Phase - Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DTS_Phase_In_Progress</fullName>
        <field>DTS_Approval__c</field>
        <literalValue>In Progress</literalValue>
        <name>DTS Phase - In Progress</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DTS_Phase_N_A</fullName>
        <field>DTS_Approval__c</field>
        <literalValue>N/A</literalValue>
        <name>DTS Phase - N/A</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DTS_Phase_Rejected</fullName>
        <field>DTS_Approval__c</field>
        <literalValue>Rejected</literalValue>
        <name>DTS Phase - Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DevApp_Item_Effective_Date</fullName>
        <field>DevApp_Item_Effective_Date__c</field>
        <formula>Device__r.SW_Kit_Effective_Date__c</formula>
        <name>DevApp Item Effective Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DevApp_Refresh</fullName>
        <description>to trigger ItemState refresh</description>
        <field>Temp__c</field>
        <formula>&quot;temp&quot;</formula>
        <name>DevApp Refresh</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DevApp_Shippable_12</fullName>
        <field>App_Item_State__c</field>
        <literalValue>12 - Prelim</literalValue>
        <name>DevApp_Shippable_12</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DevApp_Shippable_12_2</fullName>
        <field>App_Item_State__c</field>
        <literalValue>12 - Prelim</literalValue>
        <name>DevApp_Shippable_12_2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DevApp_Shippable_32</fullName>
        <field>App_Item_State__c</field>
        <literalValue>32 - Controlled</literalValue>
        <name>DevApp_Shippable_32</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Devapp_Shippable_35</fullName>
        <field>App_Item_State__c</field>
        <literalValue>35 - Full Release</literalValue>
        <name>Devapp_Shippable_35</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FMD_Phase_Approved</fullName>
        <field>FMD_Status_Approval__c</field>
        <literalValue>Approved</literalValue>
        <name>FMD Phase - Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FMD_Phase_In_Progress</fullName>
        <field>FMD_Status_Approval__c</field>
        <literalValue>In Progress</literalValue>
        <name>FMD Phase - In Progress</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FMD_Phase_N_A</fullName>
        <field>FMD_Status_Approval__c</field>
        <literalValue>N/A</literalValue>
        <name>FMD Phase - N/A</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FMD_Phase_Rejected</fullName>
        <field>FMD_Status_Approval__c</field>
        <literalValue>Rejected</literalValue>
        <name>FMD Phase - Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FMD_Status_N_A</fullName>
        <field>FMD_State__c</field>
        <literalValue>N/A</literalValue>
        <name>FMD Status - N/A</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Finance_Approval_N_A</fullName>
        <field>Finance_Approval__c</field>
        <literalValue>N/A</literalValue>
        <name>Finance Approval - N/A</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Finance_In_Progress</fullName>
        <field>Finance_Approval__c</field>
        <name>Finance - In Progress</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Finance_Phase_Approved</fullName>
        <field>Finance_Approval__c</field>
        <literalValue>Approved</literalValue>
        <name>Finance Phase - Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Finance_Phase_In_Progress</fullName>
        <field>Finance_Approval__c</field>
        <literalValue>In Progress</literalValue>
        <name>Finance Phase - In Progress</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Finance_Phase_N_A</fullName>
        <field>Finance_Approval__c</field>
        <literalValue>N/A</literalValue>
        <name>Finance Phase - N/A</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Finance_Phase_Rejected</fullName>
        <field>Finance_Approval__c</field>
        <literalValue>Rejected</literalValue>
        <name>Finance Phase - Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LRB_Phase_Approved</fullName>
        <field>LRB_Approval__c</field>
        <literalValue>Approved</literalValue>
        <name>LRB Phase - Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LRB_Phase_In_Progress</fullName>
        <field>LRB_Approval__c</field>
        <literalValue>In Progress</literalValue>
        <name>LRB Phase - In Progress</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LRB_Phase_N_A</fullName>
        <field>LRB_Approval__c</field>
        <literalValue>N/A</literalValue>
        <name>LRB Phase - N/A</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LRB_Phase_Rejected</fullName>
        <field>LRB_Approval__c</field>
        <literalValue>Rejected</literalValue>
        <name>LRB Phase - Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LRB_Status_Approved</fullName>
        <field>LRB_Approval__c</field>
        <literalValue>Approved</literalValue>
        <name>LRB Status Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Mark_Status_as_Rejected</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Mark Status as Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Partner_Manager_In_Progress</fullName>
        <field>Partner_Manager_Checklist_Approval__c</field>
        <literalValue>In Progress</literalValue>
        <name>Partner Manager - In Progress</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Partner_Manager_Phase_Approved</fullName>
        <field>Partner_Manager_Checklist_Approval__c</field>
        <literalValue>Approved</literalValue>
        <name>Partner Manager Phase - Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Partner_Manager_Rejected</fullName>
        <field>Partner_Manager_Checklist_Approval__c</field>
        <literalValue>Rejected</literalValue>
        <name>Partner Manager - Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Partner_Mgr_N_A</fullName>
        <field>Partner_Manager_Checklist_Approval__c</field>
        <literalValue>N/A</literalValue>
        <name>Partner Mgr - N/A</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Past_App_Manager_True</fullName>
        <field>Past_App_Mgr_Approval__c</field>
        <literalValue>1</literalValue>
        <name>Past App Manager True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Past_App_Mgr_Approval</fullName>
        <field>Past_App_Mgr_Approval__c</field>
        <literalValue>1</literalValue>
        <name>Past App Mgr Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Past_Budget_Approval</fullName>
        <field>Past_Budget_Approval__c</field>
        <literalValue>1</literalValue>
        <name>Past Budget Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Past_Budget_Approval_True</fullName>
        <field>Past_Budget_Approval__c</field>
        <literalValue>1</literalValue>
        <name>Past Budget Approval True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Past_LRB_Approval</fullName>
        <field>Past_LRB_Approval__c</field>
        <literalValue>1</literalValue>
        <name>Past LRB Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Past_LRB_True</fullName>
        <field>Past_LRB_Approval__c</field>
        <literalValue>1</literalValue>
        <name>Past LRB True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Past_Partner_Approval</fullName>
        <field>Past_Partner_Manager_Approval__c</field>
        <literalValue>1</literalValue>
        <name>Past Partner Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Past_SDS_Approval</fullName>
        <field>Past_SDS_Approval__c</field>
        <literalValue>1</literalValue>
        <name>Past SDS Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Past_SDS_True</fullName>
        <field>Past_SDS_Approval__c</field>
        <literalValue>1</literalValue>
        <name>Past SDS True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Requester_Approval</fullName>
        <field>Requester_Approval__c</field>
        <literalValue>Approved</literalValue>
        <name>Requester Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Requester_In_Progress</fullName>
        <field>Requester_Approval__c</field>
        <literalValue>In Progress</literalValue>
        <name>Requester - In Progress</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Requester_Reject</fullName>
        <field>Requester_Approval__c</field>
        <literalValue>Rejected</literalValue>
        <name>Requester Reject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SDS_Status_Approved</fullName>
        <field>DTS_Approval__c</field>
        <literalValue>Approved</literalValue>
        <name>SDS Status Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_IOB</fullName>
        <field>Include_in_BOM__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck IOB</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_IOB_Upon_DevApp_Rejection</fullName>
        <field>Include_in_BOM__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck IOB Upon DevApp Rejection</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>X3rd_Party_Approved</fullName>
        <field>X3rd_Party_Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>3rd Party Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>X3rd_Party_Rejected</fullName>
        <field>X3rd_Party_Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>3rd Party Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>App Prg Manager Approval - N%2FA</fullName>
        <actions>
            <name>App_Mgr_Phase_NA</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>DeviceApplicationAssoc__c.Requester_Approval__c</field>
            <operation>equals</operation>
            <value>Conditional,N/A,Rejected,Dropped,Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>DeviceApplicationAssoc__c.Application_Mgr_Selection_Approval__c</field>
            <operation>equals</operation>
            <value>In Progress</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Approval Status Change - Email Alert</fullName>
        <actions>
            <name>Approval_Status_Change_Alert</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>ISCHANGED(Approval_Status__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Conf of Budget for Royalties Approval - N%2FA</fullName>
        <actions>
            <name>Budget_for_Royalties_Phase_N_A</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>DeviceApplicationAssoc__c.Partner_Manager_Checklist_Approval__c</field>
            <operation>notEqual</operation>
            <value>In Progress</value>
        </criteriaItems>
        <criteriaItems>
            <field>DeviceApplicationAssoc__c.Confirmation_of_Budget_Royalties__c</field>
            <operation>equals</operation>
            <value>In Progress</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>DTS Approval - N%2FA</fullName>
        <actions>
            <name>DTS_Phase_N_A</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>DeviceApplicationAssoc__c.Partner_Manager_Checklist_Approval__c</field>
            <operation>notEqual</operation>
            <value>In Progress</value>
        </criteriaItems>
        <criteriaItems>
            <field>DeviceApplicationAssoc__c.DTS_Approval__c</field>
            <operation>equals</operation>
            <value>In Progress</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>DTS Leveraging API</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Application__c.Leveraging_Motorola_Proprietary_APIs__c</field>
            <operation>notEqual</operation>
            <value>Yes</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>DevApp Refresh</fullName>
        <actions>
            <name>DevApp_Refresh</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 and 6 and 7 and 8 and 9 and 10</booleanFilter>
        <criteriaItems>
            <field>DeviceApplicationAssoc__c.Device_SA_Status__c</field>
            <operation>notContain</operation>
            <value>cancel,delete</value>
        </criteriaItems>
        <criteriaItems>
            <field>DeviceApplicationAssoc__c.Application_Contract_Phase__c</field>
            <operation>contains</operation>
            <value>execution</value>
        </criteriaItems>
        <criteriaItems>
            <field>DeviceApplicationAssoc__c.Approval_Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>DeviceApplicationAssoc__c.Include_in_BOM__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>DeviceApplicationAssoc__c.App_Item_State__c</field>
            <operation>notEqual</operation>
            <value>35 - Full Release,32 - Controlled</value>
        </criteriaItems>
        <criteriaItems>
            <field>DeviceApplicationAssoc__c.Application_Contract_Status__c</field>
            <operation>contains</operation>
            <value>executed</value>
        </criteriaItems>
        <criteriaItems>
            <field>DeviceApplicationAssoc__c.Temp__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>DeviceApplicationAssoc__c.SA_Date__c</field>
            <operation>greaterOrEqual</operation>
            <value>10/1/2014</value>
        </criteriaItems>
        <criteriaItems>
            <field>DeviceApplicationAssoc__c.SA_Date__c</field>
            <operation>lessOrEqual</operation>
            <value>1/1/2017</value>
        </criteriaItems>
        <criteriaItems>
            <field>DeviceApplicationAssoc__c.CreatedDate</field>
            <operation>greaterOrEqual</operation>
            <value>10/1/2014 2:00 AM</value>
        </criteriaItems>
        <description>to trigger ItemState refresh</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>DevAppContractCheck1</fullName>
        <active>false</active>
        <criteriaItems>
            <field>DeviceApplicationAssoc__c.Application_Contract_Status__c</field>
            <operation>contains</operation>
            <value>Fully</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>DevApp_Shippable_12</fullName>
        <actions>
            <name>DevApp_Shippable_12</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>(
ISPICKVAL(Approval_Status__c, &apos;Approved&apos;) &amp;&amp; 

( NOT(CONTAINS(Application_Contract_Status__c , &apos;Fully Executed&apos;)) ||

(
NOT(ISPICKVAL(X3rd_Party_Approval_Status__c, &apos;N/A&apos;)) &amp;&amp;

NOT(ISPICKVAL(X3rd_Party_Approval_Status__c, &apos;Approved&apos;))
)
 ||
NOT(Application_Governing_EndDate__c &gt; SA_Date__c + 14 ) ||

ISPICKVAL(Application__r.ECCN_subECCN_Value__c, &apos;&apos;) ||
ISPICKVAL(Application__r.ENC_License_Category__c, &apos;&apos;) )
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>DevApp_Shippable_12_2</fullName>
        <actions>
            <name>DevApp_Shippable_12_2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>DeviceApplicationAssoc__c.Approval_Status__c</field>
            <operation>notEqual</operation>
            <value>Approved</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>DevApp_Shippable_32</fullName>
        <actions>
            <name>DevApp_Shippable_32</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>May not be necessary with some more tweaking of code at the end of DevApp_beforeUpdate.</description>
        <formula>ISPICKVAL(Approval_Status__c, &apos;Approved&apos;) &amp;&amp; CONTAINS(Application_Contract_Status__c , &apos;Fully Executed&apos;) &amp;&amp;
(ISPICKVAL(X3rd_Party_Approval_Status__c, &apos;N/A&apos;) || ISPICKVAL(X3rd_Party_Approval_Status__c, &apos;Approved&apos;)) &amp;&amp;
(Application_Governing_EndDate__c &gt; SA_Date__c + 14 ) &amp;&amp;
NOT(ISPICKVAL(Application__r.ECCN_subECCN_Value__c, &apos;&apos;)) &amp;&amp;
NOT(ISPICKVAL(Application__r.ENC_License_Category__c, &apos;&apos;)) &amp;&amp;
ISBLANK(Application__r.Royalty_Current__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>DevApp_Shippable_35</fullName>
        <actions>
            <name>Devapp_Shippable_35</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>May not be necessary with some more tweaking of code at the end of DevApp_beforeUpdate.</description>
        <formula>ISPICKVAL(Approval_Status__c, &apos;Approved&apos;) &amp;&amp; CONTAINS(Application_Contract_Status__c , &apos;Fully Executed&apos;) &amp;&amp;
(ISPICKVAL(X3rd_Party_Approval_Status__c, &apos;N/A&apos;) || ISPICKVAL(X3rd_Party_Approval_Status__c, &apos;Approved&apos;)) &amp;&amp;
(Application_Governing_EndDate__c &gt; SA_Date__c + 14 ) &amp;&amp;
NOT(ISPICKVAL(Application__r.ECCN_subECCN_Value__c, &apos;&apos;)) &amp;&amp;
NOT(ISPICKVAL(Application__r.ENC_License_Category__c, &apos;&apos;)) &amp;&amp;
NOT(ISNULL(Application__r.Royalty_Current__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Effective Date</fullName>
        <actions>
            <name>DevApp_Item_Effective_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Device__c.SW_Kit_Effective_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>FMD Approval - N%2FA</fullName>
        <actions>
            <name>FMD_Phase_N_A</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>FMD_Status_N_A</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>DeviceApplicationAssoc__c.Partner_Manager_Checklist_Approval__c</field>
            <operation>notEqual</operation>
            <value>In Progress</value>
        </criteriaItems>
        <criteriaItems>
            <field>DeviceApplicationAssoc__c.FMD_Status_Approval__c</field>
            <operation>equals</operation>
            <value>In Progress</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LRB Approval - N%2FA</fullName>
        <actions>
            <name>LRB_Phase_N_A</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>DeviceApplicationAssoc__c.Partner_Manager_Checklist_Approval__c</field>
            <operation>notEqual</operation>
            <value>In Progress</value>
        </criteriaItems>
        <criteriaItems>
            <field>DeviceApplicationAssoc__c.LRB_Approval__c</field>
            <operation>equals</operation>
            <value>In Progress</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Partner Mgr - N%2FA</fullName>
        <actions>
            <name>Partner_Mgr_N_A</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>DeviceApplicationAssoc__c.Partner_Manager_Checklist_Approval__c</field>
            <operation>equals</operation>
            <value>In Progress</value>
        </criteriaItems>
        <criteriaItems>
            <field>DeviceApplicationAssoc__c.Requester_Approval__c</field>
            <operation>notEqual</operation>
            <value>In Progress</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
