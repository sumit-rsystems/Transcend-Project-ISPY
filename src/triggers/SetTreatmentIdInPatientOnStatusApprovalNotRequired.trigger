trigger SetTreatmentIdInPatientOnStatusApprovalNotRequired on Randomization_Form__c (after update) {
	List<Randomization_Form__c> randomizationList = Trigger.new;
	System.debug('randomizationList------'+randomizationList);
	Set<id> trialPatientIdSet = new Set<id>();
	List<Phase_Master__c> phMasterList = [Select p.Name From Phase_Master__c p where Name = 'Treatment'];
	System.debug('phMasterList----------'+phMasterList);
	if(phMasterList.isEmpty())return;
	
	for(Randomization_Form__c rndm : randomizationList){
		if(rndm.TrialPatient__c != null && rndm.Status__c == 'Approval Not Required')trialPatientIdSet.add(rndm.TrialPatient__c);
	}
	List<TrialPatient__c> trialPatientList; 
	if(!trialPatientIdSet.isEmpty()){
		trialPatientList = [Select t.Phase_Master__c, t.Patient_Id__c, t.Name From TrialPatient__c t where id IN :trialPatientIdSet];
	}
	if(!trialPatientList.isEmpty()){
		for(TrialPatient__c tp : trialPatientList){
			tp.Phase_Master__c = phMasterList[0].id;
		}
		System.debug('trialPatientList----------'+trialPatientList.size());
		update trialPatientList;
	}
}