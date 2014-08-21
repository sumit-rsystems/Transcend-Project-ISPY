trigger caTissueSchedulerAfterTrigger on caTissueSchedulerDetails__c (after insert) {
	List<caTissueSchedulerDetails__c> lstCaTissueSch = trigger.new;
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
	system.schedule(system.now()+' - '+lstCaTissueSch[0].OperationType__c, scTime, new caTissueSchedulerClass(lstCaTissueSch[0].OperationType__c));   
}