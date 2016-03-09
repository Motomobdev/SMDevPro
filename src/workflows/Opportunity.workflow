<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Close_Date_Past_Due_Alert</fullName>
        <description>Close Date Past Due Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>eis@motorola.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Opportunity_Templates/Close_Date_Past_Due_Alert</template>
    </alerts>
    <alerts>
        <fullName>Milestone_Date_Past_Due_Alert</fullName>
        <description>Milestone Date Past Due Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>eis@motorola.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Opportunity_Templates/Milestone_Date_Past_Due_Alert</template>
    </alerts>
    <alerts>
        <fullName>No_Products_Alert</fullName>
        <description>No Products Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>eis@motorola.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Opportunity_Templates/No_Products_Alert</template>
    </alerts>
    <fieldUpdates>
        <fullName>Deal_Opportunity_Renaming</fullName>
        <field>Name</field>
        <formula>&quot;DEAL: &quot; &amp; Name</formula>
        <name>Deal Opportunity Renaming</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Increment_Push_Counter_Field</fullName>
        <description>Increment the Push Counter by 1</description>
        <field>Push_Counter__c</field>
        <formula>IF( 
ISNULL( Push_Counter__c ), 
1, 
Push_Counter__c + 1 
)</formula>
        <name>Increment Push Counter Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Close Date Past Due Alert</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.CloseDate</field>
            <operation>greaterOrEqual</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>MML Sales</value>
        </criteriaItems>
        <description>Notifies the opportunity owner when the opportunity is open and is past the close date</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <offsetFromField>Opportunity.CloseDate</offsetFromField>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Close_Date_Past_Due_Alert</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.CloseDate</offsetFromField>
            <timeLength>24</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Deals Opportunity Renaming</fullName>
        <actions>
            <name>Deal_Opportunity_Renaming</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Deal</value>
        </criteriaItems>
        <description>Rename the Opportunity that is created by a Deal so can more easily distinguish from actual Sales opportunities in related list view</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Milestone Date Past Due Alert</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Next_Milestone_Date__c</field>
            <operation>greaterOrEqual</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>MML Sales</value>
        </criteriaItems>
        <description>otifies the opportunity owner when the opportunity is open and is past the milestone date</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Milestone_Date_Past_Due_Alert</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.Next_Milestone_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Open Opportunity With No Products</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.HasOpportunityLineItem</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>MML Sales</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.CloseDate</field>
            <operation>greaterOrEqual</operation>
            <value>TODAY</value>
        </criteriaItems>
        <description>Open opportunity created 3 days ago and has no products - Notify the owner</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>No_Products_Alert</name>
                <type>Alert</type>
            </actions>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Push Counter</fullName>
        <actions>
            <name>Increment_Push_Counter_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Increment the Push Counter field by 1</description>
        <formula>IF( CloseDate &gt; PRIORVALUE( CloseDate ), TRUE, FALSE )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
