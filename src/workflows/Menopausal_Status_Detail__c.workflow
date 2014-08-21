<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_Approval_Pending_Mail</fullName>
        <description>Send Approval Pending Mail</description>
        <protected>false</protected>
        <recipients>
            <recipient>DCC_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Menopausal_DCC_Template</template>
    </alerts>
    <fieldUpdates>
        <fullName>ConvetRecordType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Live</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>ConvetRecordType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_Date</fullName>
        <field>Effective_Time__c</field>
        <formula>CreatedDate</formula>
        <name>Copy Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Menopausal_Status_Update</fullName>
        <field>Menopausal_Status__c</field>
        <literalValue>Postmenopausal (prior bilateral ovariectomy OR &gt; 12 months since LMP with no prior hysterectomy)</literalValue>
        <name>Menopausal Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Menopausal_Status_for_unknown_dat</fullName>
        <field>Menopausal_Status__c</field>
        <literalValue>Above categories not applicable AND Age &gt; 50</literalValue>
        <name>Menopausal Status for unknown dat</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Menopausal_Status_less_than_50</fullName>
        <field>Menopausal_Status__c</field>
        <literalValue>Above categories not applicable AND Age &lt; 50</literalValue>
        <name>Menopausal Status less than 50</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Menopausal_CRF_Approval_Pending</fullName>
        <field>Status__c</field>
        <literalValue>Approval Pending</literalValue>
        <name>Set Menopausal CRF Approval Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Menopausal_CRF_Approved</fullName>
        <field>Status__c</field>
        <literalValue>Accepted</literalValue>
        <name>Set Menopausal CRF Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Menopausal_CRF_Rejected</fullName>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Set Menopausal CRF Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Approval_Pending</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Updating_Root_CRF_ID_menopausal</fullName>
        <field>Root_CRF_Id__c</field>
        <formula>CASESAFEID(Id)</formula>
        <name>Updating Root CRF ID menopausal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Menopausal Merge Date</fullName>
        <actions>
            <name>Copy_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Menopausal_Status_Detail__c.Effective_Time__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Menopausal Status Update</fullName>
        <actions>
            <name>Menopausal_Status_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Menopausal_Status_Detail__c.Unknown_Date_but_12_Months_Ago__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Menopausal_Status_Detail__c.Menopausal_Status__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Menopausal Status Update for unknown date</fullName>
        <actions>
            <name>Menopausal_Status_for_unknown_dat</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Menopausal_Status_Detail__c.Unknown_Date__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Menopausal_Status_Detail__c.Patient_age__c</field>
            <operation>greaterOrEqual</operation>
            <value>50</value>
        </criteriaItems>
        <criteriaItems>
            <field>Menopausal_Status_Detail__c.Menopausal_Status__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Menopausal Status for unknown date less than 50</fullName>
        <actions>
            <name>Menopausal_Status_less_than_50</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Menopausal_Status_Detail__c.Unknown_Date__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Menopausal_Status_Detail__c.Patient_age__c</field>
            <operation>lessThan</operation>
            <value>50</value>
        </criteriaItems>
        <criteriaItems>
            <field>Menopausal_Status_Detail__c.Menopausal_Status__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send DCC Approval Mail</fullName>
        <actions>
            <name>Send_Approval_Pending_Mail</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Menopausal_Status_Detail__c.Status__c</field>
            <operation>equals</operation>
            <value>Approval Pending</value>
        </criteriaItems>
        <criteriaItems>
            <field>Menopausal_Status_Detail__c.ApprovalURL__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Updating Root CRF ID menopausal</fullName>
        <actions>
            <name>Updating_Root_CRF_ID_menopausal</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>IF( OriginalCRF__c == null, true, false) &amp;&amp; if(Root_CRF_Id__c == null, true, false)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
