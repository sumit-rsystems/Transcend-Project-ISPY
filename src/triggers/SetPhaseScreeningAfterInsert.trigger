trigger SetPhaseScreeningAfterInsert on TrialPatient__c (before insert) {
	List<TrialPatient__c> trialPatientList = Trigger.new;
	List<Phase_Master__c> phMasterList = [Select p.Name From Phase_Master__c p where Name = 'Screening'];
	System.debug('phMasterList----------'+phMasterList);
	if(!phMasterList.isEmpty()){
		for(TrialPatient__c tPatient : trialPatientList){
			tPatient.Phase_Master__c = phMasterList[0].id;
		}
	}
}