trigger SetAEIdBeforeDelete on Toxicity__c (before delete) {
	Set<Id> TPIds = new Set<Id>();
	for(Toxicity__c tox : Trigger.old) {
		if(tox.Attribution__c != '0 - Baseline') {
			TPIds.add(tox.TrialPatient__c);
		}
	}
	
	List<TrialPatient__c> trialPatientsWithToxicties = [Select t.Id, (Select AE_ID__c, Id, Attribution__c, TrialPatient__c From Toxicities__r where Id NOT IN :Trigger.oldMap.keySet() and Attribution__c != '0 - Baseline' order by CreatedDate) From TrialPatient__c t where t.Id IN :TPIds];
	
	system.debug('trialPatientsWithToxicties: '+trialPatientsWithToxicties);
	List<Toxicity__c> lstUpdateToxicity = new List<Toxicity__c>();
	for(TrialPatient__c tp : trialPatientsWithToxicties) {
		Decimal counter = 0;
		for(Toxicity__c tox : tp.Toxicities__r) {
			tox.AE_ID__c = ++counter;
			system.debug('tox.AE_ID__c: '+tox.AE_ID__c);
			lstUpdateToxicity.add(tox);
		}
	}
	
	system.debug('lstUpdateToxicity: '+lstUpdateToxicity);
	if(!lstUpdateToxicity.isEmpty()) {
		update lstUpdateToxicity;
	}
}