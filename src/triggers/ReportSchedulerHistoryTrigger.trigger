trigger ReportSchedulerHistoryTrigger on Reports_Scheduler_History__c (after insert, after update) {
		List<Reports_Scheduler_History__c> lstReportJob = trigger.new;
		datetime dt = system.now();
		dt = dt.addMinutes(1);
		integer sec = dt.second();
		integer min = dt.minute();
		integer hr = dt.hour();
		integer day = dt.day();
		integer mnth = dt.month();
		integer year = dt.year();
		String scTime = sec +' '+min+' '+hr+' '+day+' '+mnth+' ? '+year; 
		system.debug('scTime : '+scTime);
		system.schedule('Report - '+lstReportJob[0].NextReport__c++, scTime, new ReportSchedulerClass(lstReportJob[0].NextReport__c++));
}