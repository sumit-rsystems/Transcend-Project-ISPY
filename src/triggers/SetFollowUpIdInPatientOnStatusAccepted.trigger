trigger SetFollowUpIdInPatientOnStatusAccepted on Off_Study_Detail__c (after update) {
	List<Off_Study_Detail__c> offStudyDetailList = Trigger.new;
	
	List<Off_Study_Detail__c> offStudyDetailList2 = [Select o.TrialPatient__r.Patient_Id__c, o.TrialPatient__c, o.Status__c From Off_Study_Detail__c o where id IN :Trigger.newMap.keySet()];
	Map<id,id> patientMap = new Map<id,id>();
	for(Off_Study_Detail__c offstd : offStudyDetailList2){
		if(offStd.TrialPatient__c != null && offStd.TrialPatient__r.Patient_Id__c != null){
			patientMap.put(offstd.id,offStd.TrialPatient__r.Patient_Id__c);
		}
	}
	 
	System.debug('offStudyDetailList------'+offStudyDetailList);
	System.debug('offStudyDetailList---Status__c---'+offStudyDetailList[0].Status__c);
	Set<id> patientIdSet = new Set<id>();
	
	List<Phase_Master__c> phMasterList = [Select p.Name From Phase_Master__c p where Name = 'Follow Up'];
	System.debug('phMasterList----------'+phMasterList);
	
	if(!offStudyDetailList.isEmpty()){
		for(Off_Study_Detail__c offStd : offStudyDetailList){
			System.debug('offStd.TrialPatient__c-----'+offStd.TrialPatient__c);
			System.debug('offStd.Status__c------'+offStd.Status__c);
			System.debug('patientMap.get(offStd.id)------'+patientMap.get(offStd.id));
			if(offStd.TrialPatient__c != null && patientMap.get(offStd.id) != null && offStd.Status__c == 'Accepted'){
				patientIdSet.add(patientMap.get(offStd.id));
			}
		}
	}
	System.debug('patientIdSet----------'+patientIdSet);
	if(!patientIdSet.isEmpty() && !phMasterList.isEmpty()){
		List<Patient_Custom__c> patientList = [Select p.Phase_Master__c From Patient_Custom__c p where Id IN :patientIdSet];
		System.debug('patientList---------'+patientList);
		for(Patient_Custom__c patient : patientList){
			patient.Phase_Master__c = phMasterList[0].id;
		}
		update patientList;
	}
}