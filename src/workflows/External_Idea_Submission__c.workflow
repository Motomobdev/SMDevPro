<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>EIS_Pursued</fullName>
        <description>EIS - Pursued</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eis@motorola.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EIS/EIS_Pursued</template>
    </alerts>
    <alerts>
        <fullName>EIS_Rejected</fullName>
        <description>EIS - Rejected</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eis@motorola.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EIS/EIS_Rejected</template>
    </alerts>
    <alerts>
        <fullName>EIS_Submitted</fullName>
        <description>EIS - Submitted</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eis@motorola.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EIS/Submission_Reply</template>
    </alerts>
    <rules>
        <fullName>EIS - Pursued</fullName>
        <actions>
            <name>EIS_Pursued</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>External_Idea_Submission__c.Idea_Status__c</field>
            <operation>equals</operation>
            <value>Pursued</value>
        </criteriaItems>
        <criteriaItems>
            <field>External_Idea_Submission__c.CreatedById</field>
            <operation>equals</operation>
            <value>EIS Site Guest User</value>
        </criteriaItems>
        <description>A EIS is pursued.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EIS - Rejected</fullName>
        <actions>
            <name>EIS_Rejected</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>External_Idea_Submission__c.Idea_Status__c</field>
            <operation>equals</operation>
            <value>Rejected</value>
        </criteriaItems>
        <criteriaItems>
            <field>External_Idea_Submission__c.CreatedById</field>
            <operation>equals</operation>
            <value>EIS Site Guest User</value>
        </criteriaItems>
        <description>A EIS is rejected.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EIS - Submitted</fullName>
        <actions>
            <name>EIS_Submitted</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>External_Idea_Submission__c.Idea_Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <criteriaItems>
            <field>External_Idea_Submission__c.CreatedById</field>
            <operation>equals</operation>
            <value>EIS Site Guest User</value>
        </criteriaItems>
        <description>A EIS is first submitted.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>New EIS</fullName>
        <active>true</active>
        <criteriaItems>
            <field>External_Idea_Submission__c.CreatedById</field>
            <operation>equals</operation>
            <value>EIS Site Guest User</value>
        </criteriaItems>
        <description>When a new EIS is created by site user send notification email.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
