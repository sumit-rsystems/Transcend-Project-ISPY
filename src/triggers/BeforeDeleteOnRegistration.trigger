trigger BeforeDeleteOnRegistration on Registration__c (before delete) {
	Set<Id> trialPatientIdSet = new Set<Id>();
	for(Registration__c reg: Trigger.old) {
		trialPatientIdSet.add(reg.TrialPatient__c);
	} 
	
	try {
		system.debug('__trialPatientIdSet__'+trialPatientIdSet);
		List<TrialPatient__c> lstTrialPat = [Select t.Subject_Id__c, t.LastName__c, t.Id, t.FirstName__c, (Select Id From Registrations__r) From TrialPatient__c t where Id IN :trialPatientIdSet];
		List<TrialPatient__c> lstDeleteTrialPatient = new List<TrialPatient__c>();
		for(TrialPatient__c tp : lstTrialPat) {
			if(tp.Registrations__r.size()>1) continue;
			lstDeleteTrialPatient.add(tp);
		}
		//delete [select Id from TrialPatient__c where Id IN :trialPatientIdSet];
		delete lstDeleteTrialPatient;
	} catch(Exception e) {
		system.debug('__Error__'+e.getDmlId(0));
		for(Registration__c reg: Trigger.old) {
			if(reg.TrialPatient__c == e.getDmlId(0) && !Test.isRunningTest()) {
				//reg.addError(e.getMessage());
				reg.addError('Registration can\'t be deleted because Patient has associated with other CRFs in this trial.');
			}
		}
		//return;
	}
}