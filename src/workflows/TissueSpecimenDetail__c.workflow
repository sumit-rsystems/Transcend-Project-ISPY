<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
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
        <fullName>Updating_Root_CRF_ID_tissue</fullName>
        <field>Root_CRF_Id__c</field>
        <formula>CASESAFEID(Id)</formula>
        <name>Updating Root CRF ID tissue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Tissue Merge Date</fullName>
        <actions>
            <name>Copy_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>TissueSpecimenDetail__c.Effective_Time__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Updating Root CRF ID tissue</fullName>
        <actions>
            <name>Updating_Root_CRF_ID_tissue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>IF( OriginalCRF__c == null, true, false) &amp;&amp; if(Root_CRF_Id__c == null, true, false)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
