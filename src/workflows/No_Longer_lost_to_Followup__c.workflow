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
        <template>unfiled$public/No_Longer_Lost_To_Followup_DCC_Template</template>
    </alerts>
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
        <fullName>NoLongerFollowupRecordType_to_Live</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Live</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>NoLongerFollowupRecordType to Live</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NoLongerFollowupRecordType_to_app_pend</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Approval_Pending</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>NoLongerFollowupRecordType to app. pend</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NoLongerFollowupStatus_to_Accepted</fullName>
        <field>Status__c</field>
        <literalValue>Accepted</literalValue>
        <name>NoLongerFollowupStatus to Accepted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NoLongerFollowupStatus_to_Approval_Pend</fullName>
        <field>Status__c</field>
        <literalValue>Approval Pending</literalValue>
        <name>NoLongerFollowupStatus to Approval Pend</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NoLongerFollowupStatus_to_Rejected</fullName>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>NoLongerFollowupStatus to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type_field</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Live</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_field</fullName>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Update Status field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Updating_Root_CRF_No_Longer_Lost</fullName>
        <field>Root_CRF_Id__c</field>
        <formula>CASESAFEID(Id)</formula>
        <name>Updating Root CRF No Longer Lost</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>No Longer lost to Followup Merge Field</fullName>
        <actions>
            <name>Copy_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>No_Longer_lost_to_Followup__c.Effective_Time__c</field>
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
            <field>No_Longer_lost_to_Followup__c.Status__c</field>
            <operation>equals</operation>
            <value>Approval Pending</value>
        </criteriaItems>
        <criteriaItems>
            <field>No_Longer_lost_to_Followup__c.ApprovalURL__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Updating Root CRF No Longer Lost</fullName>
        <actions>
            <name>Updating_Root_CRF_No_Longer_Lost</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>IF( OriginalCRF__c == null, true, false) &amp;&amp; if(Root_CRF_Id__c == null, true, false)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
