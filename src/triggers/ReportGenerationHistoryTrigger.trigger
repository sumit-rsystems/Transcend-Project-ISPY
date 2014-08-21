trigger ReportGenerationHistoryTrigger on ReportGenerationHistory__c (after insert, after update) {
	System.debug('Trigger.new[0].Report_Generated__c : '+Trigger.new[0].Report_Generated__c);
	if(Trigger.new[0].Report_Generated__c == 9) {
		new PatientSummaryReport().generatePatientSummaryReport();
	}
}