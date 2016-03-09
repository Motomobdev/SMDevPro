<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>APC_Created_Notification</fullName>
        <description>APC Created Notification</description>
        <protected>false</protected>
        <recipients>
            <field>DPL_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>cacc26@motorola.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>evaee@motorola.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>gmv736@motorola.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>lynnshu@motorola.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>qa6237.md@motorola.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>qthai.md@motorola.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>quicker1@motorola.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>simbulan@motorola.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>yangm@motorola.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>yanhui2@motorola.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PMD/APC_Entry_Created</template>
    </alerts>
    <alerts>
        <fullName>APC_Description_Notification</fullName>
        <description>APC Description Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>evaee@motorola.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>gmv736@motorola.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>w14087@motorola.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PMD/APC_Desc_Entered</template>
    </alerts>
    <alerts>
        <fullName>Concept_Exit_Trigger_for_APC_Needed_Notification</fullName>
        <description>Concept Exit Trigger for APC Needed Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>gmv736@motorola.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>qthai.md@motorola.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PMD/APC_Needed_Trigger_Email</template>
    </alerts>
    <alerts>
        <fullName>Notification_Template_of_New_Product_Record_Created</fullName>
        <ccEmails>pmd@motorola.com</ccEmails>
        <description>Notification Template of New Product Record Created</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PMD/Notification_Template_of_New_Product_Record_Created</template>
    </alerts>
    <fieldUpdates>
        <fullName>AMPS_Bands</fullName>
        <field>AMPS_Bands__c</field>
        <formula>SUBSTITUTE(
TRIM(  
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;AMPS 800&quot;) , &quot;800 &quot;,&quot;&quot; 
) 
),
&apos; &apos;,&apos;;&apos;)</formula>
        <name>AMPS Bands</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AutoUpdate_of_Activation_Date</fullName>
        <field>Product_Activation_Date__c</field>
        <formula>today()</formula>
        <name>AutoUpdate of Activation Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AutoUpdate_of_Cancellation_Date</fullName>
        <field>Product_Cancellation_Date__c</field>
        <formula>today()</formula>
        <name>AutoUpdate of Cancellation Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AutoUpdate_of_No_Longer_Shipping_Date</fullName>
        <field>Product_No_Longer_Shipping_Date__c</field>
        <formula>today()</formula>
        <name>AutoUpdate of No Longer Shipping Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Blank_APC</fullName>
        <field>APC__c</field>
        <name>Blank APC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Blank_DP_Segment_Code</fullName>
        <field>DP_Segment_Code__c</field>
        <name>Blank DP Segment Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CDMA_Banding</fullName>
        <field>CDMA_Bands__c</field>
        <formula>SUBSTITUTE(
SUBSTITUTE(
TRIM( 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;CDMA 700&quot;) , &quot;700 &quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;CDMA 800&quot;) , &quot;800 &quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;CDMA 800 BC10&quot;) , &quot;800-BC10 &quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;CDMA 850&quot;) , &quot;850 &quot;,&quot;&quot; 
)
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;CDMA 1700&quot;) , &quot;1700 &quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;CDMA 1800&quot;) , &quot;1800 &quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;CDMA 1900&quot;) , &quot;1900 &quot;,&quot;&quot; 
)
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;CDMA BC0&quot;) , &quot;BC0 &quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;CDMA BC1&quot;) , &quot;BC1 &quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;CDMA 2100&quot;) , &quot;2100 &quot;,&quot;&quot; 
)
),
&apos; &apos;,&apos;;&apos;),
&apos;-&apos;,&apos; &apos;)</formula>
        <name>CDMA Banding</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CDMA_Protocols</fullName>
        <field>CDMA_Data_Protocols__c</field>
        <formula>LEFT( 
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;CDMA 1X&quot;) , &quot;1X;&quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;CDMA EV-DO Release 0&quot;) , &quot;EV-DO Release 0;&quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;CDMA EV-DO Release A&quot;) , &quot;EV-DO Release A;&quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;CDMA EV-DO Release B&quot;) , &quot;EV-DO Release B;&quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;CDMA EV-DV&quot;) , &quot;EV-DV;&quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;CDMA LTE&quot;) , &quot;LTE;&quot;,&quot;&quot; 
), 

LEN( 
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;CDMA 1X&quot;) , &quot;1X;&quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;CDMA EV-DO Release 0&quot;) , &quot;EV-DO Release 0;&quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;CDMA EV-DO Release A&quot;) , &quot;EV-DO Release A;&quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;CDMA EV-DO Release B&quot;) , &quot;EV-DO Release B;&quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;CDMA EV-DV&quot;) , &quot;EV-DV;&quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;CDMA LTE&quot;) , &quot;LTE;&quot;,&quot;&quot; 
) 
)-1 
)</formula>
        <name>CDMA Protocols</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EDGE_Protocols</fullName>
        <field>EDGE_Data_Protocols__c</field>
        <formula>LEFT( 
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;EDGE Class 4&quot;) , &quot;Class 4;&quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;EDGE Class 6&quot;) , &quot;Class 6;&quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;EDGE Class 8&quot;) , &quot;Class 8;&quot;,&quot;&quot; 
)
+
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;EDGE Class 10&quot;) , &quot;Class 10;&quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;EDGE Class 11&quot;) , &quot;Class 11;&quot;,&quot;&quot; 
) 
+
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;EDGE Class 12&quot;) , &quot;Class 12;&quot;,&quot;&quot; 
) , 

LEN( 
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;EDGE Class 4&quot;) , &quot;Class 4;&quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;EDGE Class 6&quot;) , &quot;Class 6;&quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;EDGE Class 8&quot;) , &quot;Class 8;&quot;,&quot;&quot; 
)
+
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;EDGE Class 10&quot;) , &quot;Class 10;&quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;EDGE Class 11&quot;) , &quot;Class 11;&quot;,&quot;&quot; 
) 
+
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;EDGE Class 12&quot;) , &quot;Class 12;&quot;,&quot;&quot; 
) 
)-1
)</formula>
        <name>EDGE Protocols</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GPRS_Protocols</fullName>
        <field>GPRS_Data_Protocols__c</field>
        <formula>LEFT( 
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;GPRS Class 4&quot;) , &quot;Class 4;&quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;GPRS Class 8&quot;) , &quot;Class 8;&quot;,&quot;&quot; 
)
+
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;GPRS Class 10&quot;) , &quot;Class 10;&quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;GPRS Class 12&quot;) , &quot;Class 12;&quot;,&quot;&quot; 
) , 

LEN( 
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;GPRS Class 4&quot;) , &quot;Class 4;&quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;GPRS Class 8&quot;) , &quot;Class 8;&quot;,&quot;&quot; 
)
+
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;GPRS Class 10&quot;) , &quot;Class 10;&quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;GPRS Class 12&quot;) , &quot;Class 12;&quot;,&quot;&quot; 
)  
)-1 
)</formula>
        <name>GPRS Protocols</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GSM_Banding</fullName>
        <field>GSM_Bands__c</field>
        <formula>SUBSTITUTE(
TRIM(
IF(
 INCLUDES(Radio_Communication_Technologies__c, &quot;GSM 850&quot;) , &quot;850 &quot;, &quot;&quot;
)
+
IF(
 INCLUDES(Radio_Communication_Technologies__c, &quot;GSM 900&quot;) , &quot;900 &quot;, &quot;&quot;
)
+
IF(
 INCLUDES(Radio_Communication_Technologies__c, &quot;GSM 1800&quot;) , &quot;1800 &quot;, &quot;&quot;
)
+
IF(
 INCLUDES(Radio_Communication_Technologies__c, &quot;GSM 1900&quot;) , &quot;1900 &quot;, &quot;&quot;
)
),
&apos; &apos;,&apos;;&apos;)</formula>
        <name>GSM Banding</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>HSDPA_Protocols</fullName>
        <field>HSPA_Data_Protocols__c</field>
        <formula>LEFT( 
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;HSDPA 1.2 Mbps (Category 1/2)&quot;) , &quot;1.2 Mbps (Category 1/2);&quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;HSDPA 1.8 Mbps (Category 3/4)&quot;) , &quot;1.8 Mbps (Category 3/4);&quot;,&quot;&quot; 
)
+
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;HSDPA 2.8 Mbps (Category 15)&quot;) , &quot;2.8 Mbps (Category 15);&quot;,&quot;&quot; 
)
+
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;HSDPA 3.1Mbps&quot;) , &quot;3.1Mbps;&quot;,&quot;&quot; 
)
+
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;HSDPA 3.6 Mbps (Category 5/6)&quot;) , &quot;3.6 Mbps (Category 5/6);&quot;,&quot;&quot; 
)
+
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;HSDPA 7.2 Mbps (Category 7/8)&quot;) , &quot;7.2 Mbps (Category 7/8);&quot;,&quot;&quot; 
)
+
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;HSDPA 10.1 Mbps&quot;) , &quot;10.1 Mbps;&quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;HSDPA 10.2 Mbps (Category 9/10)&quot;) , &quot;10.2 Mbps (Category 9/10);&quot;,&quot;&quot; 
)
+
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;HSDPA 14.4 Mbps (Category 10)&quot;) , &quot;14.4 Mbps (Category 10);&quot;,&quot;&quot; 
)
+
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;HSDPA 21.1 Mbps (Category 14)&quot;) , &quot;21.1 Mbps (Category 14);&quot;,&quot;&quot; 
)
+
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;HSDPA 42.2 Mbps (Category 20)&quot;) , &quot;42.2 Mbps (Category 20);&quot;,&quot;&quot; 
)
+
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;HSDPA DC 42.2 Mbps (Category 24)&quot;) , &quot;DC 42.2 Mbps (Category 24);&quot;,&quot;&quot; 
) , 

LEN( 
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;HSDPA 1.2 Mbps (Category 1/2)&quot;) , &quot;1.2 Mbps (Category 1/2);&quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;HSDPA 1.8 Mbps (Category 3/4)&quot;) , &quot;1.8 Mbps (Category 3/4);&quot;,&quot;&quot; 
)
+
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;HSDPA 2.8 Mbps (Category 15)&quot;) , &quot;2.8 Mbps (Category 15);&quot;,&quot;&quot; 
)
+
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;HSDPA 3.1Mbps&quot;) , &quot;3.1Mbps;&quot;,&quot;&quot; 
)
+
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;HSDPA 3.6 Mbps (Category 5/6)&quot;) , &quot;3.6 Mbps (Category 5/6);&quot;,&quot;&quot; 
)
+
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;HSDPA 7.2 Mbps (Category 7/8)&quot;) , &quot;7.2 Mbps (Category 7/8);&quot;,&quot;&quot; 
)
+
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;HSDPA 10.1 Mbps&quot;) , &quot;10.1 Mbps;&quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;HSDPA 10.2 Mbps (Category 9/10)&quot;) , &quot;10.2 Mbps (Category 9/10);&quot;,&quot;&quot; 
)
+
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;HSDPA 14.4 Mbps (Category 10)&quot;) , &quot;14.4 Mbps (Category 10);&quot;,&quot;&quot; 
)
+
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;HSDPA 21.1 Mbps (Category 14)&quot;) , &quot;21.1 Mbps (Category 14);&quot;,&quot;&quot; 
)
+
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;HSDPA 42.2 Mbps (Category 20)&quot;) , &quot;42.2 Mbps (Category 20);&quot;,&quot;&quot; 
)
+
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;HSDPA DC 42.2 Mbps (Category 24)&quot;) , &quot;DC 42.2 Mbps (Category 24);&quot;,&quot;&quot; 
)
)-1
)</formula>
        <name>HSDPA Protocols</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>HSUPA_Protocol</fullName>
        <field>HSUPA_Data_Protocols__c</field>
        <formula>LEFT( 
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;HSUPA 1.8 Mbps&quot;) , &quot;1.8 Mbps;&quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;HSUPA 2.0 Mbps&quot;) , &quot;2.0 Mbps;&quot;,&quot;&quot; 
)
+
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;HSUPA 2.2 Mbps&quot;) , &quot;2.2 Mbps;&quot;,&quot;&quot; 
)
+
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;HSUPA 5.6 Mbps&quot;) , &quot;5.6 Mbps;&quot;,&quot;&quot; 
)
+
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;HSUPA 5.76 Mbps&quot;) , &quot;5.76 Mbps;&quot;,&quot;&quot; 
)
+
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;HSUPA 7.6 Mbps&quot;) , &quot;7.6 Mbps;&quot;,&quot;&quot; 
)
+
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;HSUPA 11 Mbps&quot;) , &quot;11 Mbps;&quot;,&quot;&quot; 
) 
, 

LEN( 
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;HSUPA 1.8 Mbps&quot;) , &quot;1.8 Mbps;&quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;HSUPA 2.0 Mbps&quot;) , &quot;2.0 Mbps;&quot;,&quot;&quot; 
)
+
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;HSUPA 2.2 Mbps&quot;) , &quot;2.2 Mbps;&quot;,&quot;&quot; 
)
+
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;HSUPA 5.6 Mbps&quot;) , &quot;5.6 Mbps;&quot;,&quot;&quot; 
)
+
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;HSUPA 5.76 Mbps&quot;) , &quot;5.76 Mbps;&quot;,&quot;&quot; 
)
+
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;HSUPA 7.6 Mbps&quot;) , &quot;7.6 Mbps;&quot;,&quot;&quot; 
)
+
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;HSUPA 11 Mbps&quot;) , &quot;11 Mbps;&quot;,&quot;&quot; 
) 
)-1
)</formula>
        <name>HSUPA Protocol</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LTE_Banding</fullName>
        <field>LTE_Bands__c</field>
        <formula>SUBSTITUTE(
TRIM( 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;LTE Band 01&quot;) , &quot;01 &quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;LTE Band 02&quot;) , &quot;02 &quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;LTE Band 03&quot;) , &quot;03 &quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;LTE Band 04&quot;) , &quot;04 &quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;LTE Band 05&quot;) , &quot;05 &quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;LTE Band 06&quot;) , &quot;06 &quot;,&quot;&quot; 
)
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;LTE Band 07&quot;) , &quot;07 &quot;,&quot;&quot; 
)
+
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;LTE Band 08&quot;) , &quot;08 &quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;LTE Band 09&quot;) , &quot;09 &quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;LTE Band 10&quot;) , &quot;10 &quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;LTE Band 11&quot;) , &quot;11 &quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;LTE Band 12&quot;) , &quot;12 &quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;LTE Band 13&quot;) , &quot;13 &quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;LTE Band 14&quot;) , &quot;14 &quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;LTE Band 15&quot;) , &quot;15 &quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;LTE Band 16&quot;) , &quot;16 &quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;LTE Band 17&quot;) , &quot;17 &quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;LTE Band 18&quot;) , &quot;18 &quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;LTE Band 19&quot;) , &quot;19 &quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;LTE Band 20&quot;) , &quot;20 &quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;LTE Band 21&quot;) , &quot;21 &quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;LTE Band 22&quot;) , &quot;22 &quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;LTE Band 23&quot;) , &quot;23 &quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;LTE Band 24&quot;) , &quot;24 &quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;LTE Band 25&quot;) , &quot;25 &quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;LTE Band 26&quot;) , &quot;26 &quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;LTE Band 27&quot;) , &quot;27 &quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;LTE Band 28&quot;) , &quot;28 &quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;LTE Band 29&quot;) , &quot;29 &quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;LTE Band 33&quot;) , &quot;33 &quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;LTE Band 34&quot;) , &quot;34 &quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;LTE Band 35&quot;) , &quot;35 &quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;LTE Band 36&quot;) , &quot;36 &quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;LTE Band 37&quot;) , &quot;37 &quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;LTE Band 38&quot;) , &quot;38 &quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;LTE Band 39&quot;) , &quot;39 &quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;LTE Band 40&quot;) , &quot;40 &quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;LTE Band 41&quot;) , &quot;41 &quot;,&quot;&quot; 
)
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;LTE Band 42&quot;) , &quot;42 &quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;LTE Band 43&quot;) , &quot;43 &quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;LTE Band 44&quot;) , &quot;44 &quot;,&quot;&quot; 
) 
),
&apos; &apos;,&apos;;&apos;)</formula>
        <name>LTE Banding</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LTE_Protocols</fullName>
        <field>LTE_Data_Protocols__c</field>
        <formula>LEFT( 
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;LTE CAT 1&quot;) , &quot;CAT 1;&quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;LTE CAT 2&quot;) , &quot;CAT 2;&quot;,&quot;&quot; 
)
+
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;LTE CAT 3&quot;) , &quot;CAT 3;&quot;,&quot;&quot; 
)
+
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;LTE CAT 4&quot;) , &quot;CAT 4;&quot;,&quot;&quot; 
)
+
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;LTE CAT 5&quot;) , &quot;CAT 5;&quot;,&quot;&quot; 
)
+
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;LTE CAT 6&quot;) , &quot;CAT 6;&quot;,&quot;&quot; 
)
+
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;LTE CAT 7&quot;) , &quot;CAT 7;&quot;,&quot;&quot; 
)
+
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;LTE CAT 8&quot;) , &quot;CAT 8;&quot;,&quot;&quot; 
), 

LEN( 
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;LTE CAT 1&quot;) , &quot;CAT 1;&quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;LTE CAT 2&quot;) , &quot;CAT 2;&quot;,&quot;&quot; 
)
+
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;LTE CAT 3&quot;) , &quot;CAT 3;&quot;,&quot;&quot; 
)
+
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;LTE CAT 4&quot;) , &quot;CAT 4;&quot;,&quot;&quot; 
)
+
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;LTE CAT 5&quot;) , &quot;CAT 5;&quot;,&quot;&quot; 
)
+
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;LTE CAT 6&quot;) , &quot;CAT 6;&quot;,&quot;&quot; 
)
+
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;LTE CAT 7&quot;) , &quot;CAT 7;&quot;,&quot;&quot; 
)
+
IF( 
INCLUDES(Data_Network_Protocol__c , &quot;LTE CAT 8&quot;) , &quot;CAT 8;&quot;,&quot;&quot; 
)
)-1
)</formula>
        <name>LTE Protocols</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TDMA_Banding</fullName>
        <field>TDMA_Bands__c</field>
        <formula>SUBSTITUTE(
TRIM( 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;TDMA 800&quot;) , &quot;800 &quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;TDMA 1900&quot;) , &quot;1900 &quot;,&quot;&quot; 
)
),
&apos; &apos;,&apos;;&apos;)</formula>
        <name>TDMA Banding</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TD_LTE_Banding</fullName>
        <field>TD_LTE_Bands__c</field>
        <formula>SUBSTITUTE(
TRIM( 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;TD-LTE Band 38&quot;) , &quot;38 &quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;TD-LTE Band 39&quot;) , &quot;39 &quot;,&quot;&quot; 
)
+
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;TD-LTE Band 40&quot;) , &quot;40 &quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;TD-LTE Band 41&quot;) , &quot;41 &quot;,&quot;&quot; 
)
),
&apos; &apos;,&apos;;&apos;)</formula>
        <name>TD-LTE Banding</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TD_SCDMA_Banding</fullName>
        <field>TD_SCDMA_Bands__c</field>
        <formula>SUBSTITUTE(
TRIM( 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;TD-SCDMA 1880&quot;) , &quot;1880;&quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;TD-SCDMA 1900&quot;) , &quot;1900 &quot;,&quot;&quot; 
)
+
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;TD-SCDMA 1920&quot;) , &quot;1920 &quot;,&quot;&quot; 
)
+
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;TD-SCDMA 2010&quot;) , &quot;2010 &quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;TD-SCDMA 2025&quot;) , &quot;2025 &quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;TD-SCDMA 2100&quot;) , &quot;2100 &quot;,&quot;&quot; 
)
),
&apos; &apos;,&apos;;&apos;)</formula>
        <name>TD-SCDMA Banding</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_DPL_email_field</fullName>
        <field>DPL_Email__c</field>
        <formula>Device_Product_Lead__r.Mail__c</formula>
        <name>Update DPL email field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WCDMA_Banding</fullName>
        <field>WCDMA_Bands__c</field>
        <formula>SUBSTITUTE(
SUBSTITUTE(
TRIM( 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;WCDMA 800&quot;) , &quot;800 &quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;WCDMA 800 Japan&quot;) , &quot;800-Japan &quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;WCDMA 850&quot;) , &quot;850 &quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;WCDMA 850 Japan&quot;) , &quot;850-Japan &quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;WCDMA 900&quot;) , &quot;900 &quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;WCDMA 1500&quot;) , &quot;1500 &quot;,&quot;&quot; 
)
+
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;WCDMA 1700&quot;) , &quot;1700 &quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;WCDMA 1800&quot;) , &quot;1800 &quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;WCDMA 1800 Japan&quot;) , &quot;1800-Japan&quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;WCDMA 1900&quot;) , &quot;1900 &quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;WCDMA 2100&quot;) , &quot;2100 &quot;,&quot;&quot; 
)
),
&apos; &apos;,&apos;;&apos;),
&apos;-&apos;,&apos; &apos;)</formula>
        <name>WCDMA Banding</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WiMAX_Banding</fullName>
        <field>WiMAX_Bands__c</field>
        <formula>SUBSTITUTE(
SUBSTITUTE(
TRIM(  
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;WiMAX 2.5 GHz&quot;) , &quot;2.5-GHz &quot;,&quot;&quot; 
)
+
IF( 
INCLUDES(Radio_Communication_Technologies__c, &quot;WiMAX 3.5 GHz&quot;) , &quot;3.5-GHz &quot;,&quot;&quot; 
)
),
&apos; &apos;,&apos;;&apos;),
&apos;-&apos;,&apos; &apos;)</formula>
        <name>WiMAX Banding</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>iDEN_Banding</fullName>
        <field>iDEN_Bands__c</field>
        <formula>SUBSTITUTE(
TRIM( 
IF( 
INCLUDES( Radio_Communication_Technologies__c , &quot;iDEN 800&quot;) , &quot;800 &quot;,&quot;&quot; 
) 
+ 
IF( 
INCLUDES(Radio_Communication_Technologies__c , &quot;iDEN 800/900&quot;) , &quot;800/900 &quot;,&quot;&quot; 
)
),
&apos; &apos;,&apos;;&apos;)</formula>
        <name>iDEN Banding</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>APC Description Entered</fullName>
        <actions>
            <name>APC_Description_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Triggers to group when an APC Description is entered for a PMD Product record</description>
        <formula>ISCHANGED( APC_Description__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>APC Entry Created</fullName>
        <actions>
            <name>APC_Created_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Triggers to group when an APC entry is created for a PMD Product record</description>
        <formula>AND(ISCHANGED(APC__c),not(isblank(APC__c)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>APC needed when Concept Exit hits</fullName>
        <actions>
            <name>Concept_Exit_Trigger_for_APC_Needed_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>PMD_Product__c.Last_Review_Passed_del__c</field>
            <operation>equals</operation>
            <value>Concept Exit,POR Exit</value>
        </criteriaItems>
        <criteriaItems>
            <field>PMD_Product__c.APC__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Triggers an email to Finance to inform them an APC is needed, when a Product passes &quot;Concept Exit&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Banding Trigger</fullName>
        <actions>
            <name>AMPS_Bands</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CDMA_Banding</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>GSM_Banding</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>LTE_Banding</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>TDMA_Banding</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>TD_LTE_Banding</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>TD_SCDMA_Banding</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>WCDMA_Banding</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>WiMAX_Banding</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>iDEN_Banding</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>PMD_Product__c.Radio_Communication_Technologies__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Data Protocol Trigger</fullName>
        <actions>
            <name>CDMA_Protocols</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>EDGE_Protocols</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>GPRS_Protocols</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>HSDPA_Protocols</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>HSUPA_Protocol</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>LTE_Protocols</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>PMD_Product__c.Data_Network_Protocol__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notification of New Product Record Created</fullName>
        <actions>
            <name>Notification_Template_of_New_Product_Record_Created</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Email notification whenever a NEW Product record is created in PMD</description>
        <formula>true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Product Activation Date Update</fullName>
        <actions>
            <name>AutoUpdate_of_Activation_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>PMD_Product__c.Status__c</field>
            <operation>equals</operation>
            <value>Active</value>
        </criteriaItems>
        <criteriaItems>
            <field>PMD_Product__c.Product_Activation_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Auto-updating of Activation Date field, based on Product Status field change</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Product Cancellation Date Update</fullName>
        <actions>
            <name>AutoUpdate_of_Cancellation_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>PMD_Product__c.Status__c</field>
            <operation>equals</operation>
            <value>Canceled</value>
        </criteriaItems>
        <criteriaItems>
            <field>PMD_Product__c.Product_Cancellation_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Auto-updating of Cancellation Date field, based on Product Status field change</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Product Creation</fullName>
        <actions>
            <name>Blank_APC</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Blank_DP_Segment_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Workflow to blank out and set product fields when a record is created, handles case where product record is created from a cloning process to blank fields that should not be copied.</description>
        <formula>1=1</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Product No Longer Shipping Date Update</fullName>
        <actions>
            <name>AutoUpdate_of_No_Longer_Shipping_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>PMD_Product__c.Status__c</field>
            <operation>equals</operation>
            <value>No Longer Shipping</value>
        </criteriaItems>
        <criteriaItems>
            <field>PMD_Product__c.Product_No_Longer_Shipping_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Auto-updating of No Longer Shipping Date field, based on Product Status field change</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update DPL email field</fullName>
        <actions>
            <name>Update_DPL_email_field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>isblank( DPL_Email__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
