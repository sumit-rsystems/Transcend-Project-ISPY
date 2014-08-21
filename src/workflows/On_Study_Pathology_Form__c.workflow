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
        <template>unfiled$public/On_Study_Pathology_DCC_Template</template>
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
        <fullName>RecordType_to_Live</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Live</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>RecordType to Live</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_On_Study_Pathology_Approval_Pending</fullName>
        <field>Status__c</field>
        <literalValue>Approval Pending</literalValue>
        <name>Set On Study Pathology Approval Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_On_Study_Pathology_CRF_Approved</fullName>
        <field>Status__c</field>
        <literalValue>Accepted</literalValue>
        <name>Set On Study Pathology CRF Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_On_Study_Pathology_CRF_Rejected</fullName>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Set On Study Pathology CRF Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_to_Rejected</fullName>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Status to Rejected</name>
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
        <fullName>Updating_Root_CRF_ID_onstudypathology</fullName>
        <field>Root_CRF_Id__c</field>
        <formula>CASESAFEID(Id)</formula>
        <name>Updating Root CRF ID onstudypathology</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>On Study Pathology Merge Date</fullName>
        <actions>
            <name>Copy_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>On_Study_Pathology_Form__c.Effective_Time__c</field>
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
            <field>On_Study_Pathology_Form__c.Status__c</field>
            <operation>equals</operation>
            <value>Approval Pending</value>
        </criteriaItems>
        <criteriaItems>
            <field>On_Study_Pathology_Form__c.ApprovalURL__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Updating Root CRF ID onstudypathology</fullName>
        <actions>
            <name>Updating_Root_CRF_ID_onstudypathology</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>IF( OriginalCRF__c == null, true, false) &amp;&amp; if(Root_CRF_Id__c == null, true, false)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
