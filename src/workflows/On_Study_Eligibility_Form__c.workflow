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
        <template>unfiled$public/On_Study_Eligibility_DCC_Template</template>
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
        <fullName>Set_On_Study_Eligib_CRF_Approval_Pending</fullName>
        <field>Status__c</field>
        <literalValue>Approval Pending</literalValue>
        <name>Set On Study Eligib CRF Approval Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_On_Study_Eligibility_CRF_Approved</fullName>
        <field>Status__c</field>
        <literalValue>Accepted</literalValue>
        <name>Set On Study Eligibility CRF Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_On_Study_Eligibility_CRF_Rejected</fullName>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Set On Study Eligibility CRF Rejected</name>
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
        <fullName>Updating_Root_CRF_onstudy</fullName>
        <field>Root_CRF_Id__c</field>
        <formula>CASESAFEID(Id)</formula>
        <name>Updating Root CRF onstudy</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>On Study Eligibility Merge Date</fullName>
        <actions>
            <name>Copy_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>On_Study_Eligibility_Form__c.Effective_Time__c</field>
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
            <field>On_Study_Eligibility_Form__c.Status__c</field>
            <operation>equals</operation>
            <value>Approval Pending</value>
        </criteriaItems>
        <criteriaItems>
            <field>On_Study_Eligibility_Form__c.ApprovalURL__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Updating Root CRF onstudy</fullName>
        <actions>
            <name>Updating_Root_CRF_onstudy</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>IF( OriginalCRF__c == null, true, false) &amp;&amp; if(Root_CRF_Id__c == null, true, false)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
