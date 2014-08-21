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
        <template>unfiled$public/Lab_And_Test_DCC_Template</template>
    </alerts>
    <fieldUpdates>
        <fullName>ConvertRecordType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Live</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>ConvertRecordType</name>
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
        <fullName>Lab_and_Test_Approval_Pending</fullName>
        <field>Status__c</field>
        <literalValue>Approval Pending</literalValue>
        <name>Lab and Test Approval Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lab_and_Test_Approved</fullName>
        <field>Status__c</field>
        <literalValue>Accepted</literalValue>
        <name>Lab and Test Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lab_and_Test_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Approval_Pending</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Lab and Test Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lab_and_Test_Rejected</fullName>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Lab and Test Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Root_CRF_Id_Update</fullName>
        <field>Root_CRF_Id__c</field>
        <formula>CASESAFEID(Id )</formula>
        <name>Root CRF Id Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Lab and Test Merge Date</fullName>
        <actions>
            <name>Copy_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lab_and_Test__c.Effective_Time__c</field>
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
            <field>Lab_and_Test__c.Status__c</field>
            <operation>equals</operation>
            <value>Approval Pending</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lab_and_Test__c.ApprovalURL__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Updating Root CRF ID</fullName>
        <actions>
            <name>Root_CRF_Id_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>IF( OriginalCRF__c  == null, true, false) &amp;&amp; if(Root_CRF_Id__c == null, true, false)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
