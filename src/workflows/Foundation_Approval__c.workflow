<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Foundation_Request_Tier_1_Approved</fullName>
        <description>Foundation Request Tier 1 Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Foundation_Approvals/Foundation_Tier1_Approval</template>
    </alerts>
    <alerts>
        <fullName>Foundation_Request_Tier_1_Rejected</fullName>
        <description>Foundation Request Tier 1 Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Foundation_Approvals/Foundation_Tier1_Rejection</template>
    </alerts>
    <alerts>
        <fullName>Foundation_Request_Tier_2_Approved</fullName>
        <description>Foundation Request Tier 2 Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Foundation_Approvals/Foundation_Tier2_Approval</template>
    </alerts>
    <alerts>
        <fullName>Foundation_Request_Tier_2_Rejected</fullName>
        <description>Foundation Request Tier 2 Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Foundation_Approvals/Foundation_Tier2_Rejection</template>
    </alerts>
</Workflow>
