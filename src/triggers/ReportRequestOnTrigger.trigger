trigger ReportRequestOnTrigger on Report_Request__c (before insert, before update) {
	for(Report_Request__c rr : Trigger.new) {
		if(rr.Report_Type__c == 'Patient Summary' && rr.Future_Count__c == 9) {
			rr.Status__c = 'Completed';
		} else if(rr.Report_Type__c == 'Adverse Event' && rr.Future_Count__c == 2) {
			rr.Status__c = 'Completed';
		}
	}
}