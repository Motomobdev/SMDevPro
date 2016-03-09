<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>New_Account_Notification</fullName>
        <description>New Account Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>GTM_Sales_Operations</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>wcp002@motorola.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Retail_Sales_Templates/New_Account_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>Copy_Top_Level_Category</fullName>
        <field>Top_Level_Category_Text__c</field>
        <formula>IF(INCLUDES(Top_Level_Category__c,&quot;Agency&quot;),&quot;Agency &quot;, &quot; &quot;) +
IF(INCLUDES(Top_Level_Category__c,&quot;Audio&quot;),&quot;Audio &quot;, &quot; &quot;) +
IF(INCLUDES(Top_Level_Category__c,&quot;Backup&quot;),&quot;Backup &quot;, &quot; &quot;) +
IF(INCLUDES(Top_Level_Category__c,&quot;Content / Studio&quot;),&quot;Content / Studio &quot;, &quot; &quot;) +
IF(INCLUDES(Top_Level_Category__c,&quot;Content - Editorial&quot;),&quot;Content - Editorial &quot;, &quot; &quot;) +
IF(INCLUDES(Top_Level_Category__c,&quot;Content - Education&quot;),&quot;Content - Education &quot;, &quot; &quot;) +
IF(INCLUDES(Top_Level_Category__c,&quot;Content - Entertainment&quot;),&quot;Content - Entertainment &quot;, &quot; &quot;) +
IF(INCLUDES(Top_Level_Category__c,&quot;Developer&quot;),&quot;Developer &quot;, &quot; &quot;) +
IF(INCLUDES(Top_Level_Category__c,&quot;e-Book&quot;),&quot;e-Book &quot;, &quot; &quot;) +
IF(INCLUDES(Top_Level_Category__c,&quot;Education&quot;),&quot;Education &quot;, &quot; &quot;) +
IF(INCLUDES(Top_Level_Category__c,&quot;Enterprise&quot;),&quot;Enterprise &quot;, &quot; &quot;) +
IF(INCLUDES(Top_Level_Category__c,&quot;Entertainment&quot;),&quot;Entertainment &quot;, &quot; &quot;) +
IF(INCLUDES(Top_Level_Category__c,&quot;Fashion&quot;),&quot;Fashion &quot;, &quot; &quot;) +
IF(INCLUDES(Top_Level_Category__c,&quot;File Sharing&quot;),&quot;File Sharing &quot;, &quot; &quot;) +
IF(INCLUDES(Top_Level_Category__c,&quot;Future Technologies&quot;),&quot;Future Technologies &quot;, &quot; &quot;) +
IF(INCLUDES(Top_Level_Category__c,&quot;Games&quot;),&quot;Games &quot;, &quot; &quot;) +
IF(INCLUDES(Top_Level_Category__c,&quot;Green&quot;),&quot;Green &quot;, &quot; &quot;) +
IF(INCLUDES(Top_Level_Category__c,&quot;Hardware&quot;),&quot;Hardware &quot;, &quot; &quot;) +
IF(INCLUDES(Top_Level_Category__c,&quot;Health Care&quot;),&quot;Health Care &quot;, &quot; &quot;) +
IF(INCLUDES(Top_Level_Category__c,&quot;Imaging&quot;),&quot;Imaging &quot;, &quot; &quot;) +
IF(INCLUDES(Top_Level_Category__c,&quot;LBS&quot;),&quot;LBS &quot;, &quot; &quot;) +
IF(INCLUDES(Top_Level_Category__c,&quot;Lifestyle&quot;),&quot;Lifestyle &quot;, &quot; &quot;) +
IF(INCLUDES(Top_Level_Category__c,&quot;Messaging&quot;),&quot;Messaging &quot;, &quot; &quot;) +
IF(INCLUDES(Top_Level_Category__c,&quot;Mobile Commerce&quot;),&quot;Mobile Commerce &quot;, &quot; &quot;) +
IF(INCLUDES(Top_Level_Category__c,&quot;Mobile Office&quot;),&quot;Mobile Office &quot;, &quot; &quot;) +
IF(INCLUDES(Top_Level_Category__c,&quot;Music&quot;),&quot;Music &quot;, &quot; &quot;) +
IF(INCLUDES(Top_Level_Category__c,&quot;Platform&quot;),&quot;Platform &quot;, &quot; &quot;) +
IF(INCLUDES(Top_Level_Category__c,&quot;Productivity&quot;),&quot;Productivity &quot;, &quot; &quot;) +
IF(INCLUDES(Top_Level_Category__c,&quot;Real Estate&quot;),&quot;Real Estate &quot;, &quot; &quot;) +
IF(INCLUDES(Top_Level_Category__c,&quot;Services&quot;),&quot;Services &quot;, &quot; &quot;) +
IF(INCLUDES(Top_Level_Category__c,&quot;Social Media&quot;),&quot;Social Media &quot;, &quot; &quot;) +
IF(INCLUDES(Top_Level_Category__c,&quot;Sports&quot;),&quot;Sports &quot;, &quot; &quot;) +
IF(INCLUDES(Top_Level_Category__c,&quot;Tools&quot;),&quot;Tools &quot;, &quot; &quot;) +
IF(INCLUDES(Top_Level_Category__c,&quot;Travel&quot;),&quot;Travel &quot;, &quot; &quot;) +
IF(INCLUDES(Top_Level_Category__c,&quot;TV&quot;),&quot;TV &quot;, &quot; &quot;) +
IF(INCLUDES(Top_Level_Category__c,&quot;Ventures&quot;),&quot;Ventures &quot;, &quot; &quot;) +
IF(INCLUDES(Top_Level_Category__c,&quot;Video&quot;),&quot;Video &quot;, &quot; &quot;) +
IF(INCLUDES(Top_Level_Category__c,&quot;vOIP&quot;),&quot;VOIP &quot;, &quot; &quot;) +
IF(INCLUDES(Top_Level_Category__c,&quot;Widgets&quot;),&quot;Widgets &quot;, &quot; &quot;) +
IF(INCLUDES(Top_Level_Category__c,&quot;WiFi&quot;),&quot;WiFi &quot;, &quot; &quot;) +
IF(INCLUDES(Top_Level_Category__c,&quot;N/A&quot;),&quot;N/A&quot;, &quot;&quot;)</formula>
        <name>Copy Top Level Category</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>kw__Set_KW_Caucus_Former_RType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>kw__KW_Caucus_Former</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set KW Caucus Former RType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>kw__Set_KW_Caucus_RType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>kw__KW_Caucus</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set KW Caucus RType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>kw__Set_KW_Committee_Former_RType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>kw__KW_Committee_Former</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set KW Committee Former RType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>kw__Set_KW_Committee_RType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>kw__KW_Account_Committee</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set KW Committee RType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>kw__Set_KW_Former_RType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>kw__KW_Former</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set KW Former RType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>kw__Set_KW_Member_Former_RType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>kw__KW_Legislative_Member_Former</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set KW Member Former RType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>kw__Set_KW_Member_RType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>kw__KW_Account_Member</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set KW Member RType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>kw__Set_KW_Office_Former_RType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>kw__KW_Account_Officer_Former</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set KW Office Former RType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>kw__Set_KW_Office_RType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>kw__KW_Account_Officer</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set KW Office RType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>kw_cuwfe__Set_KW_Account_Exec_Former_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>kw_cuwfe__KW_Executive_Former</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set KW Account Exec Former Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>kw_cuwfe__Set_KW_Account_Executive_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>kw_cuwfe__KW_Executive</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set KW Account Executive Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>kw_lfu_swfwc__Set_KW_Account_County_Former_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>kw_lfu_swfwc__KW_Local_County_Former</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set KW Account County Former Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>kw_lfu_swfwc__Set_KW_Account_County_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>kw_lfu_swfwc__KW_Local_County</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set KW Account County Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>kw_lfu_swfwc__Set_KW_Account_Municipal_Former_RT</fullName>
        <field>RecordTypeId</field>
        <lookupValue>kw_lfu_swfwc__KW_Local_Municipal_Former</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set KW Account Municipal Former RT</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>kw_lfu_swfwc__Set_KW_Account_Municipal_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>kw_lfu_swfwc__KW_Local_Municipal</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set KW Account Municipal Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>kw_sfutokwu__Set_KW_SF_Account_Exec_Former_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>kw_sfutokwu__KW_State_Executive_Former</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set KW Account Exec Former Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>kw_sfutokwu__Set_KW_SF_Account_Executive_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>kw_sfutokwu__KW_State_Executive</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set KW Account Executive Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>kw_sfutokwu__Set_KW_SF_Caucus_Former_RType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>kw_sfutokwu__KW_State_Caucus_Former</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set KW Caucus Former RType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>kw_sfutokwu__Set_KW_SF_Caucus_RType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>kw_sfutokwu__KW_State_Caucus</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set KW Caucus RType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>kw_sfutokwu__Set_KW_SF_Committee_Former_RType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>kw_sfutokwu__KW_State_Committee_Former</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set KW Committee Former RType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>kw_sfutokwu__Set_KW_SF_Committee_RType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>kw_sfutokwu__KW_State_Committee</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set KW Committee RType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>kw_sfutokwu__Set_KW_SF_Member_Former_RType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>kw_sfutokwu__KW_State_Member_Former</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set KW Member Former RType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>kw_sfutokwu__Set_KW_SF_Member_RType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>kw_sfutokwu__KW_State_Member</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set KW Member RType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>kw_sfutokwu__Set_KW_SF_Office_Former_RType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>kw_sfutokwu__KW_State_Officer_Former</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set KW Office Former RType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>kw_sfutokwu__Set_KW_SF_Office_RType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>kw_sfutokwu__KW_State_Officer</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set KW Office RType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>kwzd__Reset_Last_Processed_Date</fullName>
        <field>kwzd__KWD_Last_Processed_DT__c</field>
        <name>Reset Last Processed Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Copy Top Level Category</fullName>
        <actions>
            <name>Copy_Top_Level_Category</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Top_Level_Category__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Built for support case 06489583</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>New Account Notification</fullName>
        <actions>
            <name>New_Account_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>MD</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Type</field>
            <operation>equals</operation>
            <value>Customer</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.CreatedById</field>
            <operation>notEqual</operation>
            <value>Customer Interface</value>
        </criteriaItems>
        <description>Notifies Sales Ops team when a new account is created.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>kw__Set KW Caucus Former RType</fullName>
        <actions>
            <name>kw__Set_KW_Caucus_Former_RType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.kw__KW_Template__c</field>
            <operation>equals</operation>
            <value>AccountCaucusFormer</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>kw__Set KW Caucus RType</fullName>
        <actions>
            <name>kw__Set_KW_Caucus_RType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.kw__KW_Template__c</field>
            <operation>equals</operation>
            <value>AccountCaucus</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>kw__Set KW Committee Former RType</fullName>
        <actions>
            <name>kw__Set_KW_Committee_Former_RType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.kw__KW_Template__c</field>
            <operation>equals</operation>
            <value>AccountCommitteeFormer</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>kw__Set KW Committee RType</fullName>
        <actions>
            <name>kw__Set_KW_Committee_RType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.kw__KW_Template__c</field>
            <operation>equals</operation>
            <value>AccountCommittee</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>kw__Set KW Former RType</fullName>
        <actions>
            <name>kw__Set_KW_Former_RType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.kw__KW_Template__c</field>
            <operation>equals</operation>
            <value>AccountFormer</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>kw__Set KW Member Former RType</fullName>
        <actions>
            <name>kw__Set_KW_Member_Former_RType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.kw__KW_Template__c</field>
            <operation>equals</operation>
            <value>AccountMemberFormer</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>kw__Set KW Member RType</fullName>
        <actions>
            <name>kw__Set_KW_Member_RType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.kw__KW_Template__c</field>
            <operation>equals</operation>
            <value>AccountMember</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>kw__Set KW Office Former RType</fullName>
        <actions>
            <name>kw__Set_KW_Office_Former_RType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.kw__KW_Template__c</field>
            <operation>equals</operation>
            <value>AccountOfficerFormer</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>kw__Set KW Office RType</fullName>
        <actions>
            <name>kw__Set_KW_Office_RType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.kw__KW_Template__c</field>
            <operation>equals</operation>
            <value>AccountOfficer</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>kw_cuwfe__Set KW Account Executive Former Record Type</fullName>
        <actions>
            <name>kw_cuwfe__Set_KW_Account_Exec_Former_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.kw__KW_Template__c</field>
            <operation>equals</operation>
            <value>AccountExecutiveFormer</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>kw_cuwfe__Set KW Account Executive Record Type</fullName>
        <actions>
            <name>kw_cuwfe__Set_KW_Account_Executive_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.kw__KW_Template__c</field>
            <operation>equals</operation>
            <value>AccountExecutive</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>kw_lfu_swfwc__Set KW Account County Former Record Type</fullName>
        <actions>
            <name>kw_lfu_swfwc__Set_KW_Account_County_Former_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.kw__KW_Template__c</field>
            <operation>equals</operation>
            <value>AccountLocalCountyFormer</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>kw_lfu_swfwc__Set KW Account County Record Type</fullName>
        <actions>
            <name>kw_lfu_swfwc__Set_KW_Account_County_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.kw__KW_Template__c</field>
            <operation>equals</operation>
            <value>AccountLocalCountyUltimate</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>kw_lfu_swfwc__Set KW Account Municipal Former Record Type</fullName>
        <actions>
            <name>kw_lfu_swfwc__Set_KW_Account_Municipal_Former_RT</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.kw__KW_Template__c</field>
            <operation>equals</operation>
            <value>AccountLocalMunicipalFormer</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>kw_lfu_swfwc__Set KW Account Municipal Record Type</fullName>
        <actions>
            <name>kw_lfu_swfwc__Set_KW_Account_Municipal_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.kw__KW_Template__c</field>
            <operation>equals</operation>
            <value>AccountLocalMunicipalUltimate</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>kw_sfutokwu__Set KW SFAccount Executive Former Record Type</fullName>
        <actions>
            <name>kw_sfutokwu__Set_KW_SF_Account_Exec_Former_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.kw__KW_Template__c</field>
            <operation>equals</operation>
            <value>AccountStateExecutiveFormer</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>kw_sfutokwu__Set KW SFAccount Executive Record Type</fullName>
        <actions>
            <name>kw_sfutokwu__Set_KW_SF_Account_Executive_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.kw__KW_Template__c</field>
            <operation>equals</operation>
            <value>AccountStateExecutive</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>kw_sfutokwu__Set KW SFCaucus Former RType</fullName>
        <actions>
            <name>kw_sfutokwu__Set_KW_SF_Caucus_Former_RType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.kw__KW_Template__c</field>
            <operation>equals</operation>
            <value>AccountStateCaucusFormer</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>kw_sfutokwu__Set KW SFCaucus RType</fullName>
        <actions>
            <name>kw_sfutokwu__Set_KW_SF_Caucus_RType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.kw__KW_Template__c</field>
            <operation>equals</operation>
            <value>AccountStateCaucus</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>kw_sfutokwu__Set KW SFCommittee Former RType</fullName>
        <actions>
            <name>kw_sfutokwu__Set_KW_SF_Committee_Former_RType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.kw__KW_Template__c</field>
            <operation>equals</operation>
            <value>AccountStateCommitteeFormer</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>kw_sfutokwu__Set KW SFCommittee RType</fullName>
        <actions>
            <name>kw_sfutokwu__Set_KW_SF_Committee_RType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.kw__KW_Template__c</field>
            <operation>equals</operation>
            <value>AccountStateCommittee</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>kw_sfutokwu__Set KW SFMember Former RType</fullName>
        <actions>
            <name>kw_sfutokwu__Set_KW_SF_Member_Former_RType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.kw__KW_Template__c</field>
            <operation>equals</operation>
            <value>AccountStateMemberFormer</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>kw_sfutokwu__Set KW SFMember RType</fullName>
        <actions>
            <name>kw_sfutokwu__Set_KW_SF_Member_RType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.kw__KW_Template__c</field>
            <operation>equals</operation>
            <value>AccountStateMember</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>kw_sfutokwu__Set KW SFOffice Former RType</fullName>
        <actions>
            <name>kw_sfutokwu__Set_KW_SF_Office_Former_RType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.kw__KW_Template__c</field>
            <operation>equals</operation>
            <value>AccountStateOfficerFormer</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>kw_sfutokwu__Set KW SFOffice RType</fullName>
        <actions>
            <name>kw_sfutokwu__Set_KW_SF_Office_RType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.kw__KW_Template__c</field>
            <operation>equals</operation>
            <value>AccountStateOfficer</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>kwzd__Reset Processed Date</fullName>
        <actions>
            <name>kwzd__Reset_Last_Processed_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR( ISCHANGED( BillingStreet),  ISCHANGED( BillingCity),  ISCHANGED( BillingState), ISCHANGED( BillingPostalCode) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
