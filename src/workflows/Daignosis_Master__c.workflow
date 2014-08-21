<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notify_Sarah_on_Diagnosis_master_update</fullName>
        <description>Notify Sarah on Diagnosis master update</description>
        <protected>false</protected>
        <recipients>
            <recipient>sarah.davis@ucsfmedctr.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sedavis4@gmail.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Inform_Sarah_about_Diagnosis_master_change</template>
    </alerts>
    <rules>
        <fullName>Notify Sarah On Change</fullName>
        <actions>
            <name>Notify_Sarah_on_Diagnosis_master_update</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Daignosis_Master__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
