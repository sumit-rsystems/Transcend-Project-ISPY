<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
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
        <fullName>RecordTypeToAppPending</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Approval_Pending</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>RecordTypeToAppPending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>StatusTorejected</fullName>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>StatusTorejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status</fullName>
        <field>Status__c</field>
        <literalValue>Approval Pending</literalValue>
        <name>Update_Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_To_Accepeted</fullName>
        <field>Status__c</field>
        <literalValue>Accepted</literalValue>
        <name>Update_Status_To_Accepeted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Mamma Print Merge Date</fullName>
        <actions>
            <name>Copy_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>MammaPrintDetail__c.Effective_Time__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
