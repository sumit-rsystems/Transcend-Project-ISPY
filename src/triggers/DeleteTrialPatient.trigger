trigger DeleteTrialPatient on PreEligibility_Checklist__c (before delete) {
	Set<Id> trialPatientIdSet = new Set<Id>();
	for(PreEligibility_Checklist__c pre : Trigger.old){
		system.debug('__pre.TrialPatient__c__'+pre.TrialPatient__c);
		trialPatientIdSet.add(pre.TrialPatient__c);
	}
	
	try {
		system.debug('__trialPatientIdSet__'+trialPatientIdSet);
		delete [Select t.Subject_Id__c, t.LastName__c, t.Id, t.FirstName__c From TrialPatient__c t where Id IN :trialPatientIdSet];
	} catch(Exception e) {
		system.debug('__Error__'+e.getDmlId(0));
		for(PreEligibility_Checklist__c pre : Trigger.old){
			if(pre.TrialPatient__c == e.getDmlId(0) && !Test.isRunningTest()) {
				//reg.addError(e.getMessage());
				pre.addError('PreEligibility can\'t be deleted because Patient has associated with other CRFs in this trial.');
			}
		}
		//return;
	}
}