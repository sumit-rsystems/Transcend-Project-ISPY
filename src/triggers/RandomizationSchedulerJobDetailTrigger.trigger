trigger RandomizationSchedulerJobDetailTrigger on RandomizationSchedulerJobDetail__c (before insert, before update) {
	List<RandomizationSchedulerJobDetail__c> lstRandSchJob = trigger.new;
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
	system.schedule(system.now()+' - '+lstRandSchJob[0].Test_Harness_Type__c, scTime, new HarnessTestScheduler(lstRandSchJob[0].Test_Harness_Type__c));
}