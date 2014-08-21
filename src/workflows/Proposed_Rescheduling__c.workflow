<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>endDateUpdate</fullName>
        <field>EndDate__c</field>
        <formula>DATETIMEVALUE(TEXT( StartDateTime__c) + TEXT(  DurationInMinutes__c ) )</formula>
        <name>endDateUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
