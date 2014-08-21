trigger SetScreeningIdBeforeInsert on Patient_Custom__c (before insert) {
	List<Patient_Custom__c> patientList = Trigger.new;
	List<Phase_Master__c> phMasterList = [Select p.Name From Phase_Master__c p where Name = 'Screening'];
	System.debug('phMasterList----------'+phMasterList);
	if(!phMasterList.isEmpty()){
		for(Patient_Custom__c patient : patientList){
			patient.Phase_Master__c = phMasterList[0].id;
		}
	}
}